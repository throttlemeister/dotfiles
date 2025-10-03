return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		strategies = {
			chat = {
				adapter = "anthropic",
				model = "claude-sonnet-4-20250514",
			},
		},
		opts = {
			-- NOTE: The log_level is in `opts.opts`
			opts = {
				log_level = "DEBUG", -- or "TRACE"
			},
		},
	},
}
