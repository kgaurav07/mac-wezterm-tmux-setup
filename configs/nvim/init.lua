require("blake.core")
require("blake.lazy")

-- Function to set colorscheme
local function set_colorscheme(color)
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)
end

-- Set default colorscheme
set_colorscheme()

-- Command to switch colorschemes
vim.api.nvim_create_user_command("ColorScheme", function(opts)
	set_colorscheme(opts.args)
end, {
	nargs = 1,
	complete = function()
		return { "tokyonight", "catppuccin" }
	end,
})

-- OSC52 clipboard for SSH sessions
-- Copy (yank): Works - sends to Mac clipboard via terminal
-- Paste (p): Use Cmd+V to paste from Mac clipboard when SSH'd
if vim.env.SSH_CONNECTION then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = function()
				return vim.split(vim.fn.getreg('"'), "\n")
			end,
			["*"] = function()
				return vim.split(vim.fn.getreg('"'), "\n")
			end,
		},
	}
end
