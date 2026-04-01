return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("treesitter-context").setup({
			enable = true,
			max_lines = 3,
			patterns = {
				default = {
					"class",
					"function",
					"method",
				},
				markdown = {
					"section",
					"atx_heading",
					"setext_heading",
				},
			},
		})
	end,
}
