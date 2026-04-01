return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness
		vim.diagnostic.config({
			-- Configure virtual text (inline messages) to only show errors
			virtual_text = {
				severity = { min = vim.diagnostic.severity.ERROR }, -- Only show ERROR level
				-- Optional: uncomment and adjust if you want specific spacing/prefix
				-- spacing = 4,
				-- prefix = '!', -- Example prefix for errors
			},
			-- Configure signs (icons in the gutter/sign column) to only show errors
			signs = {
				severity = { min = vim.diagnostic.severity.ERROR }, -- Only show ERROR level
			},
			-- Configure underlining to only show errors
			underline = {
				severity = { min = vim.diagnostic.severity.ERROR }, -- Only show ERROR level
			},
			-- Keep other settings like update_in_insert or severity_sort as you prefer
			update_in_insert = true, -- Or false
			severity_sort = true, -- Sort diagnostics by severity

			-- Float configuration (for hover/popups) - keep default (HINT) or make stricter
			float = {
				-- source = "always", -- Show diagnostic source
				-- border = "rounded",
				severity = { min = vim.diagnostic.severity.WARN }, -- Example: Show errors and warnings in float, but not info/hints
				-- Or set to ERROR if you ONLY want errors in the float too:
				-- severity = { min = vim.diagnostic.severity.ERROR }
			},
		})
		-- turn off diagnostics by default for markdown
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(args)
				vim.diagnostic.enable(false, { bufnr = args.buf })
			end,
		})
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- This section now only defines the *available* signs.
		-- The vim.diagnostic.config({signs = ...}) above controls *which* are shown.
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		function PrintDiagnostics()
			-- Define the severity filter to only include errors
			local error_filter = {
				severity = {
					min = vim.diagnostic.severity.ERROR,
					max = vim.diagnostic.severity.ERROR, -- Ensures ONLY errors are included
				},
			}

			-- Get only ERROR diagnostics for the current buffer (0), applying the filter
			local diagnostics = vim.diagnostic.get(0, error_filter)
			local output = {}

			-- Sort diagnostics by line number for better readability
			table.sort(diagnostics, function(a, b)
				return a.lnum < b.lnum
			end)

			for _, diag in ipairs(diagnostics) do
				-- Format: LineNum: Message (Severity Number) - You can remove diag.severity if you don't want the number 1 printed
				local line = string.format("Line %d: %s (%s)", diag.lnum + 1, diag.message, diag.severity)
				table.insert(output, line)
			end

			if #output == 0 then
				print("No errors found.") -- Updated message
			else
				local result = table.concat(output, "\n")
				vim.fn.setreg("+", result) -- Copy to clipboard
				print("Errors copied to clipboard:\n" .. result) -- Updated message
			end
		end

		-- Make sure this function is accessible where your command/keymap is defined
		-- If it's not global, you might need to expose it differently depending on your setup.

		vim.api.nvim_create_user_command("PrintDiagnostics", PrintDiagnostics, {})

		-- Function to write diagnostics to a file
		function WriteDiagnosticsToFile()
			local diagnostics = vim.diagnostic.get(0) -- Get diagnostics for the current buffer
			local output = {}

			for _, diag in ipairs(diagnostics) do
				local line = string.format("Line %d: %s (%s)", diag.lnum + 1, diag.message, diag.severity)
				table.insert(output, line)
			end

			if #output == 0 then
				print("No diagnostics found.")
				return
			end

			local file = io.open("diagnostics.txt", "w") -- Change the filename as needed
			for _, line in ipairs(output) do
				file:write(line .. "\n")
			end
			file:close()

			print("Diagnostics written to diagnostics.txt")
		end

		-- Command to write diagnostics to a file
		vim.api.nvim_create_user_command("WriteDiagnostics", WriteDiagnosticsToFile, {})
	end,
}
