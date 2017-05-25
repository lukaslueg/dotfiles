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
syntax sync minlines=250 maxlines=250

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

if s:uname == "Darwin\n"
    py3 from powerline.vim import setup as powerline_setup; powerline_setup(); del powerline_setup
else
    python import sys; sys.path.append('/usr/lib/python3.5/site-packages')
    python from powerline.vim import setup as powerline_setup
    python powerline_setup()
    python del powerline_setup
endif

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

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_flake8_exe = 'python3 -m flake8'

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1

let g:EasyMotion_smartcase = 1
hi link EasyMotionTarget2First ErrorMsg
hi link EasyMotionTarget2Second ErrorMsg
let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj'

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#disable_auto_complete = 0
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_fuzzy_completion = 1
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><C-e> neocomplete#cancel_popup()

nmap <Leader>< <Plug>GitGutterPrevHunk
nmap <Leader>> <Plug>GitGutterNextHunk
