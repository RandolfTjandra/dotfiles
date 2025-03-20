---@module "lazy"

---@type LazySpec
local P = {
  "ibhagwan/fzf-lua",
}

local grep_ignored = {
  "static/dist/**/*",
  "CHANGES",
  "stats.json",
  "static/images/*",
  "static/images/**/*",
  "static/app/icons/*",
  "static/less/debugger*",
  "**/vendor/*",
  "**/migrations/*",
  "src/sentry/static/sentry/dist/**/*",
  "src/sentry/static/sentry/images/*",
  "src/sentry/static/sentry/images/**/*",
  "src/sentry/static/sentry/app/icons/*",
  "src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl",
  "src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl",
  "tests/js/**/*.snap",
  "tests/fixtures/*",
  "tests/fixtures/**/*",
  "tests/*/fixtures/*",
  "tests/**/fixtures/*",
  "tests/**/snapshots/**/*",
  "tests/sentry/lang/*/fixtures/*",
  "tests/sentry/lang/**/*.map",
  "tests/sentry/grouping/**/*",
  "tests/sentry/db/*",
  "src/sentry/locale/**/*",
  "src/sentry/data/**/*",
}

function grep_ignored.toString(self)
  local str = ""
  for _, pattern in ipairs(self) do
    str = str .. string.format('-g "!%s" ', pattern)
  end
  return str
end

function P.config()
  local fzf = require("fzf-lua")

  local winopts_bottom = {
    height = 0.3,
    width = 1,
    row = 1,
    col = 0,
    border = { "", "─", "", "", "", "", "", "" },
    preview = { horizontal = "right:50%" },
  }

  local highlights = {
    normal = "NormalFloat",
    border = "FloatBorder",
    preview_normal = "Normal",
    preview_border = "Normal",
  }

  fzf.setup({
    hls = highlights,
    winopts = {
      height = 0.6,
      width = 0.95,
      preview = {
        title = false,
        scrollbar = false,
        hl = highlights,
      },
    },

    fzf_opts = {
      ["--prompt"] = "›",
      ["--pointer"] = "›",
      ["--marker"] = "›",
      ["--info"] = "default",
      ["--no-separator"] = "",
      ["--no-scrollbar"] = "",
    },

    fzf_colors = {
      ["gutter"] = { "bg", "NormalFloat" },
      ["bg+"] = { "bg", "Normal" },
    },

    files = {
      -- previewer = false,
      prompt = "files › ",
    },

    buffers = {
      -- previewer = false,
      prompt = "buffers › ",
    },

    git = {
      files = {
        previewer = false,
        prompt = "tree › ",
        cmd = "git ls-files --exclude-standard --cached --other",
      },
    },

    grep = {
      prompt = "lines › ",
      winopts = {
        height = 0.95,
        width = 0.98,
        preview = {
          layout = "vertical",
          vertical = "up:30%",
        },
      },
      rg_opts = grep_ignored:toString() .. " " .. fzf.config.globals.grep.rg_opts,
      fzf_opts = { ["--nth"] = "1.." },
    },

    command_history = {
      prompt = "command history › ",
      winopts = winopts_bottom,
      fzf_opts = {
        ["--tiebreak"] = "index",
        ["--layout"] = "default",
      },
    },

    lsp = {
      code_actions = {
        prompt = "actions › ",
        winopts = winopts_bottom,
        fzf_opts = { ["--info"] = "hidden" },
      },
      references = {
        prompt = "references › ",
        winopts = winopts_bottom,
        previewer = false,
      },
    },
  })

  -- local projects_root = "~/Dev"
  --
  -- local select_project = function(actions)
  --   fzf.files({
  --     cwd = projects_root,
  --     prompt = "projects › ",
  --     cwd_prompt = false,
  --     no_header = true,
  --     fd_opts = "--follow --max-depth=1",
  --     fzf_opts = { ["--info"] = "hidden" },
  --     winopts = {
  --       col = 0,
  --       height = 1,
  --       width = 0.2,
  --     },
  --     actions = actions,
  --   })
  -- end
  --
  -- -- Open files from specific project
  -- fzf.specific_project_git_files = function()
  --   local find_files = function(path)
  --     local entry = fzf.path.entry_to_file(path[1], { cwd = projects_root })
  --     fzf.git_files({ cwd = entry.path })
  --   end
  --
  --   select_project({ ["default"] = find_files })
  -- end
  --
  -- fzf.specific_project_grep = function()
  --   local search = function(path)
  --     local entry = fzf.path.entry_to_file(path[1], { cwd = projects_root })
  --     fzf.grep({ cwd = entry.path })
  --   end
  --
  --   select_project({ ["default"] = search })
  -- end

  -- Load fzf mappings
  require("my.mappings").fzf_mapping(fzf)
end

return P
