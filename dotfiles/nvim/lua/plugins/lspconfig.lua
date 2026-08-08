-- Lua-specific Neovim development support
return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",

		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "j-hui/fidget.nvim", opts = {} },

			-- Provides additional completion capabilities to LSPs
			"saghen/blink.cmp",
		},

		config = function()
			----------------------------------------------------------------------
			-- LSP keymaps
			----------------------------------------------------------------------

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),

				callback = function(event)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, {
							buffer = event.buf,
							desc = "LSP: " .. desc,
						})
					end

					local telescope = require("telescope.builtin")

					map("grn", vim.lsp.buf.rename, "Rename")
					map("gra", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

					map("grr", telescope.lsp_references, "References")
					map("gri", telescope.lsp_implementations, "Implementation")
					map("grd", telescope.lsp_definitions, "Definition")
					map("grt", telescope.lsp_type_definitions, "Type Definition")

					map("grD", vim.lsp.buf.declaration, "Declaration")

					map("gO", telescope.lsp_document_symbols, "Document Symbols")
					map("gW", telescope.lsp_dynamic_workspace_symbols, "Workspace Symbols")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					------------------------------------------------------------------
					-- Highlight symbol references under cursor
					------------------------------------------------------------------

					if client and client:supports_method("textDocument/documentHighlight") then
						local group = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })

						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.clear_references,
						})
					end

					------------------------------------------------------------------
					-- Toggle inlay hints
					------------------------------------------------------------------

					if client and client:supports_method("textDocument/inlayHint") then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})

			----------------------------------------------------------------------
			-- Diagnostics UI
			----------------------------------------------------------------------

			vim.diagnostic.config({
				severity_sort = true,

				float = {
					border = "rounded",
					source = "if_many",
				},

				underline = {
					severity = vim.diagnostic.severity.ERROR,
				},

				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},

				virtual_text = {
					source = "if_many",
					spacing = 2,
				},
			})

			----------------------------------------------------------------------
			-- Completion capabilities (Blink)
			----------------------------------------------------------------------

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			----------------------------------------------------------------------
			-- Language servers
			----------------------------------------------------------------------

			local servers = {
				-- C / C++
				clangd = {},

				-- Neovim Lua development
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			----------------------------------------------------------------------
			-- Install tools via Mason
			----------------------------------------------------------------------

			local ensure_installed = vim.tbl_keys(servers)

			vim.list_extend(ensure_installed, {
				"stylua",
				"clang-format",
			})

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			----------------------------------------------------------------------
			-- Configure servers
			----------------------------------------------------------------------

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,

				handlers = {
					function(server_name)
						local server = servers[server_name] or {}

						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
