-- opening file with fzf
vim.keymap.set('n', '<c-p>', ':Files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g>', ':Rg<CR>', { noremap = true, silent = true })

-- new tab and move (neovim natvie featrue)
vim.keymap.set('n', '<c-n>', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'H', 'gt', { noremap = true, silent = true })
vim.keymap.set('n', 'L', 'gT', { noremap = true, silent = true })

-- easily split window
vim.keymap.set('n', '|', ':vs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '_', ':sp<CR>', { noremap = true, silent = true })

-- easily resize splited window
vim.keymap.set('n', '<c-w>,', '<c-w><', { noremap = true, silent = true })
vim.keymap.set('n', '<c-w>.', '<c-w>>', { noremap = true, silent = true })

-- disable F1 key
vim.keymap.set('n', '<f1>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('i', '<f1>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('v', '<f1>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('c', '<f1>', '<nop>', { noremap = true, silent = true })


-- insert mode array with hjkl
vim.keymap.set('i', '<c-h>', '<left>', { noremap = true, silent = true })
vim.keymap.set('i', '<c-j>', '<down>', { noremap = true, silent = true })
vim.keymap.set('i', '<c-k>', '<up>', { noremap = true, silent = true })
vim.keymap.set('i', '<c-l>', '<right>', { noremap = true, silent = true })

-- normal mode c-hjkl -> vim tmux navigator
vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set('n', '<c-h>', ':TmuxNavigateLeft<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-j>', ':TmuxNavigateDown<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-k>', ':TmuxNavigateUp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-l>', ':TmuxNavigateRight<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-\\>', ':TmuxNavigatePrevious<CR>', { noremap = true, silent = true })
