return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	config = function()
		require("dressing").setup({
			input = {
				enabled = true,
				-- Center the input prompt
				relative = "editor",
				prefer_width = 40,
				width = nil,
				max_width = { 140, 0.9 },
				min_width = { 20, 0.2 },

				-- Position it in the center
				anchor = "NW",
				border = "rounded",

				-- Title positioning
				title_pos = "center",

				-- Prompt positioning
				prompt_align = "left",

				-- Window options
				win_options = {
					winblend = 0,
					wrap = false,
				},

				-- Override function for positioning
				get_config = function(opts)
					if opts.prompt and opts.prompt:match("Add to") then
						return {
							relative = "editor",
							position = "50%",
						}
					end
				end,
			},
			select = {
				enabled = true,
				backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

				-- Telescope will handle select menus
				telescope = require("telescope.themes").get_dropdown({
					layout_config = {
						width = 0.8,
						height = 0.8,
					},
				}),
			},
		})
	end,
}
