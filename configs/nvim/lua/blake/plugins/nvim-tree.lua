return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- Define the on_attach function
		local function on_attach(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- This line adds back all the default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- Add the new keymap for yanking file content
			vim.keymap.set("n", "<leader>yf", function()
				local node = api.tree.get_node_under_cursor()
				if node then
					local filepath = node.absolute_path
					if vim.fn.filereadable(filepath) == 1 then
						local content = vim.fn.readfile(filepath)
						vim.fn.setreg("+", table.concat(content, "\n"))
						vim.notify("File content yanked to clipboard", vim.log.levels.INFO)
					else
						vim.notify("Cannot read file", vim.log.levels.ERROR)
					end
				end
			end, opts("Yank file content"))

			-- You can add more custom keymaps here if needed
		end

		nvimtree.setup({
			on_attach = on_attach, -- Add this line to use the on_attach function
			view = {
				width = 35,
				relativenumber = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find/toggle file in explorer" }) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
}
