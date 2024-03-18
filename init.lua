function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

local g = vim.g

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

g.mapleader=","
g.t_Co=256
g.showbreak="↪"
g.tabstop=4
g.softtabstop=4
g.shiftwidth=4
g.shiftround = true
g.expandtab = true
g.cursorline = true
g.wildmenu = true

g.ctrlp_max_height = 10
g.ctrlp_match_window = 'bottom,order:ttb'
g.ctrlp_switch_buffer = 0
g.ctrlp_working_path_mode = 0
g.ctrlp_user_command = 'rg --files  %s'

g.ale_linters = {rust = {'analyzer'}}
g.ale_rust_analyzer_executable = '/Users/llueg/.rustup/toolchains/stable-x86_64-apple-darwin/bin/rust-analyzer'
g.ale_completion_enabled = 0
g.ale_python_auto_virtualenv = 1

g.EasyMotion_smartcase = 1
g.EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj'

local o = vim.opt
-- o.omnifunc="ale#completion#OmniFunc"
o.cursorline = true
o.number = true
o.colorcolumn = "120"
o.relativenumber = true
o.signcolumn = "yes"
o.scrolloff=3
o.sidescrolloff=5
o.sidescroll=1
o.updatetime = 1000
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.completeopt = "menu,preview"
o.termguicolors = true


map('n', '<Leader>n', '<esc>:tabprevious<CR>')
map('n', '<Leader>m', '<esc>:tabnext<CR>')
map('v', '<Leader>s', ':sort<CR>')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {"ellisonleao/gruvbox.nvim", priority = 1000, config = true},
    {'folke/tokyonight.nvim', lazy = false, priority = 1000, opts = {}, },
    {'rebelot/kanagawa.nvim', priority = 1000, },
    {'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
    'ctrlpvim/ctrlp.vim',
    'dense-analysis/ale',
    'nvim-treesitter/nvim-treesitter',
    -- {'nvim-treesitter/nvim-treesitter-context', dependencies={'nvim-treesitter/nvim-treesitter'}},
    {'hiphish/rainbow-delimiters.nvim', dependencies={'nvim-treesitter/nvim-treesitter'}},
    'tpope/vim-fugitive',
    'airblade/vim-gitgutter',
    'easymotion/vim-easymotion',
    {'neoclide/coc.nvim', build = 'npm ci'},
    'petertriho/nvim-scrollbar',
    {'stevearc/aerial.nvim', dependencies = {'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons'}},
    {'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = { indent = { char = '┊' }}},
    {'nvim-tree/nvim-tree.lua', dependencies = {'nvim-tree/nvim-web-devicons'}},
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
})

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = true,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
--vim.cmd("colorscheme gruvbox")

require("tokyonight").setup({
    style = 'night',
    dim_inactive = true,
    lualine_bold = true,
})
--vim.cmd('colorscheme tokyonight')

require('kanagawa').setup({
 dimInactive = true,
 background = {
  dark = 'wave',
 },
})
vim.cmd('colorscheme kanagawa')


require('lualine').setup{}

vim.cmd([[
    highlight GitGutterAddLine guibg=#2c301d
    highlight GitGutterChangeLine guibg=#31261b
    highlight GitGutterDeleteLine guibg=#3b1114
]])

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "rust" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- require'treesitter-context'.setup{
--  separator = '―',
--  mode = 'topline'
-- }

vim.cmd("GitGutterLineNrHighlightsEnable")
--vim.cmd("GitGutterLineHighlightsEnable")
nmap('<Leader><', '<Plug>(GitGutterPrevHunk)')
nmap('<Leader>>', '<Plug>(GitGutterNextHunk)')

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})
vim.cmd("highlight link CocHighlightText Search")

-- GoTo code navigation
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", {silent = true})
vim.keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        --vim.fn.CocActionAsync('doHover')
        vim.fn.CocActionAsync('definitionHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Run the Code Lens actions on the current line
vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)", {silent = true, nowait = true})

require("scrollbar").setup({})

require("aerial").setup({
  backends = { "treesitter" },
  highlight_on_hover = true,
  show_guides = true,
  layout = {
   default_direction = 'right',
   preserve_equality = true,
  },
})
vim.keymap.set("n", "<leader>t", "<cmd>AerialToggle!<CR>")

require("nvim-tree").setup({ filters = { dotfiles = true, } })
vim.keymap.set("n", "<leader>z", "<cmd>NvimTreeToggle<CR>")

require("bufferline").setup{
  options = { mode = 'tabs', numbers = "both", diagnostics = 'coc', separator_style = 'slant',},
}
