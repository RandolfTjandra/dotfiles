-- Java LSP. Started here rather than in `my.plugins.nvim-lspconfig` because
-- jdtls needs a workspace directory per project root, which is only known once
-- a Java buffer exists.

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  vim.notify("nvim-jdtls is not available", vim.log.levels.WARN)
  return
end

local mason = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason")

-- mason's launcher is a python wrapper that resolves the equinox jar, the
-- platform config directory and the JDK for us; only -data is ours to pass.
-- Built from stdpath rather than exepath("jdtls") because mason.nvim is
-- lazy-loaded on its commands, so mason/bin may not be on PATH yet.
local launcher = mason .. "/bin/jdtls"

if vim.fn.executable(launcher) == 0 then
  vim.notify("jdtls not installed; run :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

-- Multi-module markers first so the workspace spans the whole build instead of
-- a single submodule; .git is the last resort.
local root_dir = vim.fs.root(0, {
  "gradlew",
  "mvnw",
  "settings.gradle",
  "settings.gradle.kts",
}) or vim.fs.root(0, {
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "build.xml",
}) or vim.fs.root(0, { ".git" })

-- A loose .java file still gets diagnostics; jdtls treats it as a no-build-tool
-- project rooted at its own directory.
if not root_dir then
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return
  end
  root_dir = vim.fs.dirname(bufname)
end

-- Basename keeps the directory recognisable, the digest keeps two projects with
-- the same basename from sharing one workspace.
local workspace = vim.fs.normalize(
  string.format(
    "%s/jdtls/workspace/%s-%s",
    vim.fn.stdpath("cache"),
    vim.fn.fnamemodify(root_dir, ":p:h:t"),
    vim.fn.sha256(root_dir):sub(1, 8)
  )
)

local cmd = { launcher, "-data", workspace }

-- mason ships lombok with jdtls; without the agent, lombok-generated members
-- show up as errors.
local lombok = mason .. "/packages/jdtls/lombok.jar"
if vim.fn.filereadable(lombok) == 1 then
  table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
end

-- Let projects compile against a JDK other than the one running the server.
--
-- Two Homebrew quirks to work around:
--   * A keg root (/opt/homebrew/opt/openjdk@17) is not a usable JDK home. It has
--     bin/java but no lib/jrt-fs.jar, and pointing jdtls at it makes even
--     java.lang.Object fail to resolve. The real home is nested under libexec.
--   * Uninstalled versioned kegs linger as aliases to whatever openjdk is
--     current (openjdk@19..@23 all symlink to 26.0.1 here), so the keg name lies
--     about the version. Read release/JAVA_VERSION and key on that to collapse
--     the duplicates instead of registering five bogus runtimes.
local function runtimes()
  local found = {}
  local kegs = vim.fn.glob("/opt/homebrew/opt/openjdk@*", false, true)
  table.insert(kegs, "/opt/homebrew/opt/openjdk")

  for _, keg in ipairs(kegs) do
    local home = keg .. "/libexec/openjdk.jdk/Contents/Home"
    if vim.fn.filereadable(home .. "/lib/jrt-fs.jar") == 1 then
      local version = vim.iter(vim.fn.readfile(home .. "/release")):map(function(line)
        return line:match('^JAVA_VERSION="(%d+)')
      end):next()

      if version then
        found[version] = { name = "JavaSE-" .. version, path = home }
      end
    end
  end

  return vim.tbl_values(found)
end

-- java-test / java-debug-adapter are optional; installing them via mason is
-- enough to light up jdtls.test_class() and DAP support.
local function bundles()
  local found = {}
  local globs = {
    mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    mason .. "/packages/java-test/extension/server/*.jar",
  }
  for _, glob in ipairs(globs) do
    vim.list_extend(found, vim.split(vim.fn.glob(glob), "\n", { trimempty = true }))
  end
  return found
end

local function on_attach(_, bufnr)
  require("my.mappings").lsp_mapping(bufnr)

  local function map(lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("<leader>jo", jdtls.organize_imports, "jdtls: organize imports")
  map("<leader>jv", jdtls.extract_variable, "jdtls: extract variable")
  map("<leader>jc", jdtls.extract_constant, "jdtls: extract constant")
  map("<leader>jm", jdtls.extract_method, "jdtls: extract method")
  map("<leader>jv", function()
    jdtls.extract_variable({ visual = true })
  end, "jdtls: extract variable", "v")
  map("<leader>jm", function()
    jdtls.extract_method({ visual = true })
  end, "jdtls: extract method", "v")
  map("<leader>jt", jdtls.test_nearest_method, "jdtls: test nearest method")
  map("<leader>jT", jdtls.test_class, "jdtls: test class")
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

jdtls.start_or_attach({
  cmd = cmd,
  root_dir = root_dir,
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  init_options = {
    bundles = bundles(),
    extendedClientCapabilities = extendedClientCapabilities,
  },
  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = runtimes(),
      },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      format = { enabled = true },
      -- Stop java.awt.* and internal packages from crowding completion.
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.mockito.Mockito.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
    },
  },
})
