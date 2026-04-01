return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = "markdown",
	opts = {
		-- Disable latex to remove warnings
		latex = { enabled = false },

		-- Fix async issues
		debounce = 100,
		render_modes = { "n", "c" },

		-- Headings
		heading = {
			enabled = true,
			sign = false,
			position = "overlay",
			icons = {},
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH6Bg",
			},
			foregrounds = {
				"RenderMarkdownH1",
				"RenderMarkdownH2",
				"RenderMarkdownH3",
				"RenderMarkdownH4",
				"RenderMarkdownH5",
				"RenderMarkdownH6",
			},
		},

		-- Code blocks
		code = {
			enabled = true,
			sign = false,
			style = "full",
			position = "left",
			left_pad = 2,
			right_pad = 2,
			width = "block",
			border = "thin",
			highlight = "RenderMarkdownCode",
			-- This replaces inline_code in v8+
			above = "▄",
			below = "▀",
		},

		-- Checkboxes
		checkbox = {
			enabled = true,
			unchecked = {
				icon = "󰄱 ",
				highlight = "RenderMarkdownTodo",
			},
			checked = {
				icon = "✓ ",
				highlight = "RenderMarkdownChecked",
				scope_highlight = "RenderMarkdownCheckedText",
			},
			custom = {
				in_progress = { raw = "[/]", rendered = "󰡖 ", highlight = "RenderMarkdownProgress" },
			},
		},

		-- Callouts (markdown blockquote callout styles)
		callout = {
			-- Blue callouts
			note = { raw = "[!note]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
			work = { raw = "[!work]", rendered = "󰒋 Work", highlight = "RenderMarkdownInfo" },
			info = { raw = "[!info]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
			todo = { raw = "[!todo]", rendered = "󰄱 Todo", highlight = "RenderMarkdownInfo" },
			-- Teal/Cyan callouts
			tip = { raw = "[!tip]", rendered = "󰌶 Tip", highlight = "RenderMarkdownHint" },
			hint = { raw = "[!hint]", rendered = "󰌶 Hint", highlight = "RenderMarkdownHint" },
			important = { raw = "[!important]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
			abstract = { raw = "[!abstract]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownHint" },
			summary = { raw = "[!summary]", rendered = "󰨸 Summary", highlight = "RenderMarkdownHint" },
			tldr = { raw = "[!tldr]", rendered = "󰨸 TL;DR", highlight = "RenderMarkdownHint" },
			-- Yellow callouts
			question = { raw = "[!question]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
			help = { raw = "[!help]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
			faq = { raw = "[!faq]", rendered = "󰘥 FAQ", highlight = "RenderMarkdownWarn" },
			warning = { raw = "[!warning]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
			caution = { raw = "[!caution]", rendered = "󰳦 Caution", highlight = "RenderMarkdownWarn" },
			attention = { raw = "[!attention]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
			-- Green callouts
			success = { raw = "[!success]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
			check = { raw = "[!check]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
			done = { raw = "[!done]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
			example = { raw = "[!example]", rendered = "󰉹 Example", highlight = "RenderMarkdownSuccess" },
			-- Purple callouts
			quote = { raw = "[!quote]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
			cite = { raw = "[!cite]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
			-- Red callouts
			failure = { raw = "[!failure]", rendered = "󰅙 Failure", highlight = "RenderMarkdownError" },
			fail = { raw = "[!fail]", rendered = "󰅙 Fail", highlight = "RenderMarkdownError" },
			missing = { raw = "[!missing]", rendered = "󰅙 Missing", highlight = "RenderMarkdownError" },
			danger = { raw = "[!danger]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
			error = { raw = "[!error]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
			bug = { raw = "[!bug]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
		},

		-- Bullets
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
			left_pad = 0,
			right_pad = 1,
			highlight = "RenderMarkdownBullet",
		},

		-- Links
		link = {
			enabled = true,
			image = "󰥶 ",
			hyperlink = "󰌹 ",
			highlight = "RenderMarkdownLink",
		},

		-- Tables
		pipe_table = {
			enabled = true,
			preset = "round",
			style = "full",
			cell = "padded",
			min_width = 0,
			border = {
				"╭", "┬", "╮",
				"├", "┼", "┤",
				"╰", "┴", "╯",
				"│", "─",
			},
		},

		-- Block quotes
		quote = {
			enabled = true,
			icon = "▋",
			repeat_linebreak = true,
			highlight = "RenderMarkdownQuote",
		},

		-- Horizontal rules
		dash = {
			enabled = true,
			icon = "─",
			width = "full",
			highlight = "RenderMarkdownDash",
		},
	},

	config = function(_, opts)
		require("render-markdown").setup(opts)

		-- Custom highlight groups
		vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#F5A97F", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#88FF98", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#C6A0F6", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#8AADF4", bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#CAD3F5" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#CAD3F5" })

		-- Checkboxes
		vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#f78c6c" })
		vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#6c9a77" }) -- Subtle green for checkmark
		vim.api.nvim_set_hl(0, "RenderMarkdownCheckedText", { fg = "#7a7f8a" }) -- Greyed out text
		vim.api.nvim_set_hl(0, "RenderMarkdownProgress", { fg = "#ffaa00" })

		-- Code blocks
		vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#1E1E2E" })

		-- Horizontal rules
		vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "#565970" })

		-- Fix bold rendering
		vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
		vim.api.nvim_set_hl(0, "@text.strong", { bold = true })
		vim.api.nvim_set_hl(0, "markdownBold", { bold = true })

		-- Toggle command
		vim.keymap.set("n", "<leader>mr", ":RenderMarkdown toggle<CR>", { desc = "Toggle markdown rendering" })
	end,
}
