return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",

		config = function()
			----------------------------------------------------------------------
			-- Parsers to install
			----------------------------------------------------------------------

			local ts = require("nvim-treesitter")

			local parsers = {
				"bash",
				"c",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
			}

			ts.install(parsers)

			----------------------------------------------------------------------
			-- Enable Treesitter highlighting and indentation
			----------------------------------------------------------------------

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),

				callback = function(args)
					local ok = pcall(vim.treesitter.start, args.buf)

					if not ok then
						return
					end

					-- Disable regex highlighting in favor of Treesitter
					vim.bo[args.buf].syntax = "off"

					local lang = vim.treesitter.language.get_lang(args.match)

					-- Enable Treesitter indentation when available
					if lang and vim.treesitter.query.get(lang, "indents") then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
}
