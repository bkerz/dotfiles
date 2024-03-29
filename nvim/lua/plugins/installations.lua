local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
	print('Installing lazy.nvim....')
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
	{

		--Colors
		{
			'navarasu/onedark.nvim',
			lazy = false,
			priority = 1000,
			config = function()
				--colorscheme
				require('onedark').setup({
					style = 'cool',
				})
				require('onedark').load()
			end
		},
		{
			"mhartington/formatter.nvim",
			config = function()
				require("formatter").setup({
					filetype = {
						javascript = { require("formatter.filetypes.javascript").biome },
						javascriptreact = { require("formatter.filetypes.javascriptreact").biome },
						typescript = { require("formatter.filetypes.typescript").biome },
						typescriptreact = { require("formatter.filetypes.typescriptreact").biome },
					},
				})
			end,
		},
		--IDE
		{
			"akinsho/toggleterm.nvim",
			config = function()
				require("toggleterm").setup()
			end

		},
		{
			"tpope/vim-fugitive"
		},
		{
			'numToStr/Comment.nvim',
			config = function()
				require('Comment').setup {
					pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
					mappings = false
				}
			end
		},
		{ 'vim-airline/vim-airline' },
		{ 'vim-airline/vim-airline-themes' },
		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.5',
			lazy = false,
			dependencies = { 'nvim-lua/plenary.nvim' },
			config = function()
				require("plugins.telescope")
			end
		},
		{ 'tpope/vim-surround',       lazy = true },
		{
			'windwp/nvim-autopairs',
			config = function()
				require("nvim-autopairs").setup()
			end
		},
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
				commit = "313d9e7193354c5de7cdb1724f9e2d3f442780b0" -- this is temporal while wating for PR to fix weird errors
			},
			config = function()
				require("plugins.nvim-tree")
			end,
		},
		{ 'simrat39/rust-tools.nvim', ft = "rs" },
		{
			'nvim-treesitter/nvim-treesitter',
			dependencies = {
				'JoosepAlviste/nvim-ts-context-commentstring',
				config = function()
					require("plugins.ts-context-commentstring")
				end
			},
			config = function()
				require("plugins.treesitter")
			end
		},
		{ 'virchau13/tree-sitter-astro',   ft = "astro" },
		{ 'christoomey/vim-tmux-navigator' },
		{
			"windwp/nvim-ts-autotag",
			ft = {
				'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
				'rescript',
				'xml',
				'php',
				'markdown',
				'astro', 'glimmer', 'handlebars', 'hbs'
			},
		},
		{ 'lambdalisue/suda.vim', lazy = true },
		{ 'mhinz/vim-signify', },
		{
			'ThePrimeagen/harpoon',
			config = function()
				require("plugins.harpoon")
			end
		},
		--Godot
		{
			'habamax/vim-godot',
			ft = "gdscript"
		},
		--Development
		{ 'simrat39/rust-tools.nvim',         ft = { "rs" } },
		{
			'VonHeikemen/lsp-zero.nvim',
			branch = 'v2.x',
			lazy = true,
			config = function()
				-- This is where you modify the settings for lsp-zero
				-- Note: autocompletion settings will not take effect

				require('lsp-zero.settings').preset({})
			end
		},

		-- Autocompletion
		{
			'hrsh7th/nvim-cmp',
			event = 'InsertEnter',
			dependencies = {
				{ 'L3MON4D3/LuaSnip' },
			},
			config = function()
				-- Here is where you configure the autocompletion settings.
				-- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
				-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

				require('lsp-zero.cmp').extend()

				-- And you can configure cmp even more, if you want to.
				local cmp = require('cmp')
				-- local cmp_action = require('lsp-zero.cmp').action()

				--cmp.setup({
				--		mapping = {
				--			['<C-Space>'] = cmp.mapping.complete(),
				--			['<C-f>'] = cmp_action.luasnip_jump_forward(),
				--			['<C-b>'] = cmp_action.luasnip_jump_backward(),
				--		}
				--	})
				cmp.setup({})
			end
		},
		{ 'williamboman/mason-lspconfig.nvim' },
		{
			'williamboman/mason.nvim',
			build = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		},

		-- LSP
		{
			'neovim/nvim-lspconfig',
			cmd = 'LspInfo',
			event = { 'BufReadPre', 'BufNewFile' },
			dependencies = {
				{ 'hrsh7th/cmp-nvim-lsp' },
				{ 'hrsh7th/cmp-buffer' },
			},
			config = function()
				-- This is where all the LSP shenanigans will live

				local lsp = require('lsp-zero')

				lsp.on_attach(function(client, bufnr)
					lsp.default_keymaps({ buffer = bufnr })
				end)

				-- (Optional) Configure lua language server for neovim
				require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
				require('lspconfig').gdscript.setup {
					flags = {
						debounce_text_changes = 150,
					}
				}
				require("lspconfig").biome.setup {}

				lsp.setup()
			end
		}

	})
