return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		default = {
			-- Use relative paths
			relative_to_current_file = true,

			-- Prompt for filename (set to false for auto-naming)
			prompt_for_file_name = false,

			-- Auto-generated filename format
			file_name = "%Y-%m-%d-%H%M%S",

			-- Where to save images (relative to current file)
			dir_path = "assets/imgs",

			-- Insert markdown image syntax
			template = "![$FILE_NAME]($FILE_PATH)",
		},

		-- Filetype overrides
		filetypes = {
			markdown = {
				url_encode_path = false,
				template = "![$FILE_NAME]($FILE_PATH)",
			},
		},

		-- Drag and drop support
		drag_and_drop = {
			enabled = true,
			insert_mode = true,
		},
	},

	keys = {
		{ "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
		{ "<leader>id", "<cmd>ImgClipDebug<cr>", desc = "Debug image clipboard" },
	},
}
