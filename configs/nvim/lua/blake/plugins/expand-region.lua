return {
	"terryma/vim-expand-region",
	keys = {
		{ "+", "<Plug>(expand_region_expand)", mode = "v", desc = "Expand selection" },
		{ "_", "<Plug>(expand_region_shrink)", mode = "v", desc = "Shrink selection" },
	},
	config = function()
		-- Configure what text objects to expand through
		vim.g.expand_region_text_objects = {
			["iw"] = 0, -- word
			["iW"] = 0, -- WORD
			["i'"] = 0, -- single quotes
			['i"'] = 0, -- double quotes
			["i`"] = 0, -- backticks
			["i)"] = 1, -- parentheses
			["i]"] = 1, -- square brackets
			["i}"] = 1, -- curly braces
			["it"] = 1, -- xml/html tags
			["ip"] = 0, -- paragraph
		}
	end,
}
