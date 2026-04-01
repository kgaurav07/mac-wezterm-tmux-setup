return {
	"gaoDean/autolist.nvim",
	ft = { "markdown", "text" },
	config = function()
		require("autolist").setup()

		-- Custom function to create or cycle checkbox in insert mode
		local function create_or_cycle_checkbox_insert()
			local line = vim.api.nvim_get_current_line()
			local cursor = vim.api.nvim_win_get_cursor(0)
			local row = cursor[1]
			local col = cursor[2]

			-- Check if line is empty or only whitespace
			if line:match("^%s*$") then
				-- Create new checkbox with preserved indentation
				local indent = line:match("^%s*") or ""
				vim.api.nvim_set_current_line(indent .. "- [ ] ")
				-- Position cursor at end to start typing
				vim.api.nvim_win_set_cursor(0, { row, #indent + 6 })
				return
			end

			-- Line has content - cycle the checkbox
			-- Temporarily exit insert mode to cycle
			vim.cmd("stopinsert")

			require("checkbox-cycle").cycle_next()

			-- Schedule re-entering insert mode to happen after the cycle completes
			vim.schedule(function()
				-- Get the new line after cycling
				local new_line = vim.api.nvim_get_current_line()
				-- Try to maintain cursor position, or go to end if position is invalid
				local new_col = math.min(col, #new_line)
				vim.api.nvim_win_set_cursor(0, { row, new_col })
				vim.cmd("startinsert")
			end)
		end

		-- Set up autocommand to apply keymaps to all markdown/text buffers
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown", "text" },
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()

				-- Auto-create new checkbox/bullet on Enter
				vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>", { buffer = bufnr })
				vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>", { buffer = bufnr })
				vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", { buffer = bufnr })

				-- Checkbox cycling with Cmd+Enter (sent as M-CR from WezTerm)
				-- Normal mode: just cycle
				vim.keymap.set("n", "<M-CR>", "<Cmd>CheckboxCycleNext<CR>", { buffer = bufnr, desc = "Cycle checkbox state" })
				-- Insert mode: create or cycle
				vim.keymap.set("i", "<M-CR>", create_or_cycle_checkbox_insert, { buffer = bufnr, desc = "Create or cycle checkbox" })

				-- Recalculate list on delete
				vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>", { buffer = bufnr })

				-- Tab/Shift-Tab to indent/dedent
				vim.keymap.set("i", "<Tab>", "<cmd>AutolistTab<cr>", { buffer = bufnr })
				vim.keymap.set("i", "<S-Tab>", "<cmd>AutolistShiftTab<cr>", { buffer = bufnr })

				-- Recalculate on editing
				vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>", { buffer = bufnr })
				vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>", { buffer = bufnr })
			end,
		})
	end,
}
