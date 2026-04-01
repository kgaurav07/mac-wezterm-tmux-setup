return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")
		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"pyright",
				"yamlls",
				"sqlls",
				"svelte",
				"graphql",
				"emmet_ls",
			}, -- ← Added closing brace here
			handlers = {
				-- The first entry is the default handler.
				-- It's used for all servers that don't have a specific handler below.
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
					})
				end,

				-- Disable sqlls - we use vim-dadbod instead
				["sqlls"] = function()
					-- Do nothing - prevents sqlls from attaching to SQL files
				end,

				-- Custom handler for Svelte
				["svelte"] = function()
					require("lspconfig").svelte.setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						on_attach = function(client, bufnr)
							vim.api.nvim_create_autocmd("BufWritePost", {
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end,
							})
						end,
					})
				end,

				-- Custom handler for GraphQL
				["graphql"] = function()
					require("lspconfig").graphql.setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				end,

				-- Custom handler for Emmet
				["emmet_ls"] = function()
					require("lspconfig").emmet_ls.setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						filetypes = {
							"html",
							"typescriptreact",
							"javascriptreact",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				end,

				-- Custom handler for Lua
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								completion = { callSnippet = "Replace" },
							},
						},
					})
				end,
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Formatters
				"prettier",
				"stylua",
				"black",
				"isort",
				"sql-formatter",

				-- Linters
				"eslint_d",
				"pylint",
			},
		})
	end,
}
