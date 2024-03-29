set omnifunc=ale#completion#OmniFunc
let g:ale_rust_analyzer_executable = '/Users/llueg/.rustup/toolchains/stable-x86_64-apple-darwin/bin/rust-analyzer'
let g:ale_linters = {'rust': ['analyzer']}
set completeopt=menu,popup
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 0
let g:ale_completion_delay = 500
let g:ale_python_auto_virtualenv = 1

call pathogen#infect()

autocmd! bufwritepost .vimrc source %

set pastetoggle=<F2>
if $TMUX == ''
    set clipboard=unnamed
endif

set mouse=a
set bs=2

let mapleader=","

noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

vnoremap <Leader>s :sort<CR>

vnoremap < <gv
vnoremap > >gv

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

set t_Co=256
set showbreak=↪
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set cursorline
set wildmenu

filetype off
filetype plugin indent off
filetype plugin indent on
syntax on
syntax sync minlines=450 maxlines=450

set number
set tw=79
"set nowrap
set fo-=t
set colorcolumn=80
highlight ColorColumn ctermbg=233
set rnu

set history=700
set undolevels=700
set laststatus=2
set scrolloff=3
set sidescrolloff=5
set sidescroll=1

set hlsearch
set incsearch
set ignorecase
set smartcase

set matchpairs+=<:>

set termguicolors
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 1
let g:gruvbox_contrast_dark = "hard"
colorscheme gruvbox
set background=dark

if has('unix')
    let s:uname = system('uname -s')
else
    if has('win32')
        let s:uname = 'win32'
    else
        let s:uname = 'other'
    endif
endif

let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1

let g:ctrlp_max_height = 10
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'rg --files  %s'
set wildignore+=*.pyc,*.pyo
set wildignore+=*_build/*
set wildignore+=*/coverage/*
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.swp,*.zip,*.png,*.jpg,*.gif,*.pdf
set wildignore+=*DS_Store*

set nofoldenable

nnoremap <silent> <Leader>t :TagbarToggle<CR>

" GUI and stuff
if has('gui_running')
    if s:uname == 'win32'
        set guifont=Consolas:h8
        set enc=utf-8
    elseif s:uname == "Darwin\n"
        set guifont=Sauce\ Code\ Powerline:h11
    else
        set guifont=Monospace\ 8
    endif
    set guioptions-=T
    set lines=60 columns=100
endif

" Syntax highlighting for SQL embedded into python scripts
function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
    let ft=toupper(a:filetype)
    let group='textGroup'.ft
    if exists('b:current_syntax')
        let s:current_syntax=b:current_syntax
        " Remove current syntax definition, as some syntax files
        " (e.g. cpp.vim)
        " do nothing if b:current_syntax is defined.
        unlet b:current_syntax
    endif
    execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
    try
        execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
        let b:current_syntax=s:current_syntax
    else
        unlet b:current_syntax
    endif
    execute 'syntax region textSnip'.ft.'
    \ matchgroup='.a:textSnipHl.'
    \ start="'.a:start.'" end="'.a:end.'"
    \ contains=@'.group
endfunction
au FileType python call TextEnableCodeSnip('sqlinformix', "sql = '''", "'''", 'SpecialComment')

" In the 21th century .md is markdown, not modula2
au BufRead,BufNewFile *.md set filetype=markdown

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1

let g:EasyMotion_smartcase = 1
hi link EasyMotionTarget2First ErrorMsg
hi link EasyMotionTarget2Second ErrorMsg
let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj'

nmap <Leader>< <Plug>(GitGutterPrevHunk)
nmap <Leader>> <Plug>(GitGutterNextHunk)
