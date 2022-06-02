local M = {}

M.winopts_bottom = {
	height = 0.3,
	width = 1,
	row = 1,
	col = 0,
	border = { "", "─", "", "", "", "", "", "" },
	preview = { horizontal = "right:50%" },
}

function M.setup()
	local fzf = safe_require("fzf-lua")
	if not fzf then
		return
	end

	fzf.setup({
		winopts = {
			height = 0.6,
			width = 0.95,

			preview = {
				title = false,
				scrollbar = false,
				horizontal = "right:40%",
			},
			hl = {
				border = "FloatBorder",
			},
		},

		fzf_opts = {
			["--prompt"] = "›",
			["--pointer"] = "›",
			["--marker"] = "›",
		},

		files = { prompt = "files › " },

		git = {
			files = { prompt = "tree › " },
		},

		grep = {
			prompt = "lines › ",
			winopts = {
				height = 0.95,
				width = 0.98,
				preview = { layout = "vertical", vertical = "up:30%" },
			},
		},

		nvim = {
			command_history = {
				prompt = "command history › ",
				winopts = M.winopts_bottom,
				fzf_opts = {
					["--tiebreak"] = "index",
					["--layout"] = "default",
				},
			},
		},
	})
end

return M
