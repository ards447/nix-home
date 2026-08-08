return {
	{
		-- Completion engine
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",

		dependencies = {
			----------------------------------------------------------------------
			-- Snippets
			----------------------------------------------------------------------
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",

				build = (function()
					-- Enable regex snippets when make is available
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end

					return "make install_jsregexp"
				end)(),

				opts = {},
			},

			-- Better Lua completion for Neovim config files
			"folke/lazydev.nvim",
		},

		opts = {
			----------------------------------------------------------------------
			-- Keymaps
			----------------------------------------------------------------------
			keymap = {
				preset = "default",
			},

			----------------------------------------------------------------------
			-- Appearance
			----------------------------------------------------------------------
			appearance = {
				nerd_font_variant = "mono",
			},

			----------------------------------------------------------------------
			-- Completion Menu
			----------------------------------------------------------------------
			completion = {
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 500,
				},
			},

			----------------------------------------------------------------------
			-- Completion Sources
			----------------------------------------------------------------------
			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"lazydev",
				},

				providers = {
					lazydev = {
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},

			----------------------------------------------------------------------
			-- Snippets
			----------------------------------------------------------------------
			snippets = {
				preset = "luasnip",
			},

			----------------------------------------------------------------------
			-- Fuzzy Matching
			----------------------------------------------------------------------
			fuzzy = {
				implementation = "lua",
			},

			----------------------------------------------------------------------
			-- Function Signatures
			----------------------------------------------------------------------
			signature = {
				enabled = true,
			},
		},
	},
}
