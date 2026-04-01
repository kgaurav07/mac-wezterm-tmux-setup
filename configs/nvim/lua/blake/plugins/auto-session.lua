return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
			-- Fix LSP buf_state nil error after session restore (neovim/neovim#28987)
			post_restore_cmds = {
				function()
					-- Restart LSP to fix change tracking state
					vim.defer_fn(function()
						vim.cmd("LspRestart")
					end, 100)
				end,
			},
		})

		local keymap = vim.keymap

		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd" })
		keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session for auto session root dir" })
	end,
}
