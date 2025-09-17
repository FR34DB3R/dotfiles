return require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'morhetz/gruvbox'
	use 'junegunn/fzf'
	use 'junegunn/fzf.vim'
	-- use { 'neoclide/coc.nvim', branch = 'release' }
	use 'rust-lang/rust.vim'
	use {
  	'nvim-lualine/lualine.nvim',
  	requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'christoomey/vim-tmux-navigator'
        use {
                'vyfor/cord.nvim',
                run = ':Cord update',
                -- config = function()
                --   require('cord').setup {}
                -- end
        }
end)
