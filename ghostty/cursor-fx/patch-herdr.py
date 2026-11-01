#!/usr/bin/env python3
"""Make the cursor-fx shaders find Claude Code's input box inside a pane (herdr),
not only when the box spans the whole window."""
import glob, os, re, sys

HELPERS = '''// Claude Code's box lines run across its whole pane: the window in a plain tab, one
// pane in a multiplexer like herdr. A line at height y counts when its ink runs
// unbroken through the cursor's column for at least BOX_MIN_CELLS cells; a shorter
// line (zsh's underline under a path, a rule in some output) is not one.
const float BOX_MIN_CELLS = 24.0;
bool inkAt(float x, float y, vec2 res) {
    return x >= 0.0 && x <= res.x && colorDist(screenAt(vec2(x, y) / res).rgb, iBackgroundColor) >= 0.03;
}
bool acrossPane(float y, vec2 res) {
    vec4 cur = upCursor(iCurrentCursor);
    float w = max(cellWOf(cur), 0.4 * cur.w), x = cur.x + 0.5 * w;
    if (!inkAt(x, y, res)) return false;
    float run = 1.0;
    bool goL = true, goR = true;
    for (int k = 1; k <= 48; k++) {
        if (goL) { if (inkAt(x - float(k) * w, y, res)) run += 1.0; else goL = false; }
        if (goR) { if (inkAt(x + float(k) * w, y, res)) run += 1.0; else goR = false; }
        if (run >= BOX_MIN_CELLS) return true;
        if (!goL && !goR) break;
    }
    return false;
}
// Where to check for background just above and below a box line: a few cells right
// of the cursor (left of it near the pane's right edge), on the box's empty side.
float lineSideX(vec2 res) {
    vec4 cur = upCursor(iCurrentCursor);
    float w = max(cellWOf(cur), 0.4 * cur.w);
    return cur.x + 3.5 * w <= res.x ? cur.x + 3.5 * w : cur.x - 2.5 * w;
}

'''

def patch(src):
    n = {}
    def sub(name, pat, rep, count_expected, flags=re.S):
        allowed = count_expected if isinstance(count_expected, tuple) else (count_expected,)
        nonlocal src
        src, k = re.subn(pat, rep, src, flags=flags)
        n[name] = k
        if k not in allowed:
            raise SystemExit(f"{name}: expected {count_expected}, got {k}")
    if "bool acrossPane(" in src:
        return src, "already patched"
    # 1. helpers, before boxLineY's comment block
    sub("helpers", r"(// Claude Code draws its input box with a thin grey line)", lambda m: HELPERS + m.group(1), 1)
    # 2. boxLineY / clLineNear: three samples across the window + the whole-window
    #    check -> one pane-relative check; the background-above/below sample moves too.
    sub("xs", r"\n    vec3 xs = vec3\(0\.45, 0\.66, 0\.88\) \* res\.x;", "", 2)
    sub("span",
        r"        if \(colorDist\(screenAt\(vec2\(xs\.x, y\) / res\)\.rgb, iBackgroundColor\) < 0\.03\n"
        r"\s*\|\| colorDist\(screenAt\(vec2\(xs\.y, y\) / res\)\.rgb, iBackgroundColor\) < 0\.03\n"
        r"\s*\|\| colorDist\(screenAt\(vec2\(xs\.z, y\) / res\)\.rgb, iBackgroundColor\) < 0\.03\) continue;\n"
        r"        // Claude Code's box lines run across the whole window; a shorter line \(zsh's\n"
        r"        // underline under a path, a rule in some output\) is not one\.\n"
        r"        if \(colorDist\(screenAt\(vec2\(0\.05 \* res\.x, y\) / res\)\.rgb, iBackgroundColor\) < 0\.03\n"
        r"\s*\|\| colorDist\(screenAt\(vec2\(0\.95 \* res\.x, y\) / res\)\.rgb, iBackgroundColor\) < 0\.03\) continue;\n",
        "        if (!acrossPane(y, res)) continue;\n", 2)
    sub("side", r"vec2\(xs\.x, y ([+-]) 4\.0\)", r"vec2(lineSideX(res), y \1 4.0)", 4)
    # 3. clMarkAbove's cheap pre-check: ink at the cursor's column, not the window's right edge.
    sub("markpre",
        r"if \(colorDist\(screenAt\(vec2\(0\.95 \* res\.x, y\) / res\)\.rgb, iBackgroundColor\) < 0\.03\) continue;",
        "if (!inkAt(cur.x + 0.5 * w, y, res)) continue;", 1)
    # 4. promptLook's "a line across the window just above" -> across the pane.
    sub("under",
        r"if \(colorDist\(screenAt\(vec2\(0\.95 \* res\.x, y\) / res\)\.rgb, iBackgroundColor\) > 0\.03\n"
        r"\s*&& colorDist\(screenAt\(vec2\(0\.05 \* res\.x, y\) / res\)\.rgb, iBackgroundColor\) > 0\.03\n"
        r"\s*&& colorDist\(screenAt\(vec2\(0\.5 \* res\.x, y\) / res\)\.rgb, iBackgroundColor\) > 0\.03\)",
        "if (acrossPane(y, res))", 1)
    # 5. linesLook's cheap pre-check.
    sub("lines",
        r"if \(!look && \(colorDist\(screenAt\(vec2\(0\.05 \* res\.x, p\.y\) / res\)\.rgb, iBackgroundColor\) < 0\.02\n"
        r"\s*\|\| colorDist\(screenAt\(vec2\(0\.95 \* res\.x, p\.y\) / res\)\.rgb, iBackgroundColor\) < 0\.02\)\) return col;",
        "if (!look && !acrossPane(p.y, res)) return col;", (0, 1))
    # 6. cyber's own line finder for its rain: twelve points across the window -> the
    #    pane-relative check, and its one-pixel pre-check at the cursor's column.
    sub("fullLine",
        r"    vec3 first = screenAt\(vec2\(0\.05 \* res\.x, y\) / res\)\.rgb;\n"
        r"    if \(colorDist\(first, iBackgroundColor\) < 0\.03\) return false;\n"
        r"    for \(int i = 1; i < 12; i\+\+\)\n"
        r"        if \(distance\(screenAt\(vec2\(\(0\.05 \+ 0\.08 \* float\(i\)\) \* res\.x, y\) / res\)\.rgb, first\) > 0\.03\) return false;\n"
        r"    return colorDist\(screenAt\(vec2\(0\.45 \* res\.x, y \+ 4\.0\) / res\)\.rgb, iBackgroundColor\) < 0\.03\n"
        r"        && colorDist\(screenAt\(vec2\(0\.45 \* res\.x, y - 4\.0\) / res\)\.rgb, iBackgroundColor\) < 0\.03;",
        "    if (!acrossPane(y, res)) return false;\n"
        "    return colorDist(screenAt(vec2(lineSideX(res), y + 4.0) / res).rgb, iBackgroundColor) < 0.03\n"
        "        && colorDist(screenAt(vec2(lineSideX(res), y - 4.0) / res).rgb, iBackgroundColor) < 0.03;", (0, 1))
    sub("lineIn", r"x = 0\.97 \* res\.x;", "x = upCursor(iCurrentCursor).x + 0.5 * upCursor(iCurrentCursor).z;", (0, 1))
    left = re.findall(r"0\.(?:05|95|97) \* res\.x", src)
    return src, f"ok {n} leftover-window-checks={len(left)}"

paths = sys.argv[1:] or sorted(glob.glob(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "shaders", "*-cursor.glsl")))
for path in paths:
    src = open(path).read()
    out, msg = patch(src)
    if out != src:
        open(path, "w").write(out)
    print(path.rsplit("/", 1)[1], msg)
