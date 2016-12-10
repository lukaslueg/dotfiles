call pathogen#infect()

autocmd! bufwritepost .vimrc source %

set pastetoggle=<F2>
if $TMUX == ''
    set clipboard=unnamed
endif

set mouse=a  " on OSX press ALT and click
set bs=2     " make backspace behave like normal again

let mapleader=","

noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

vnoremap <Leader>s :sort<CR>

vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

set t_Co=256

set background=dark

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
syntax sync minlines=250

set number
set tw=79
set nowrap
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

colorscheme solarized

let $PYTHONPATH='/usr/lib/python3.5/site-packages'
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2

let g:ctrlp_max_height = 10
set wildignore+=*.pyc,*.pyo
set wildignore+=*_build/*
set wildignore+=*/coverage/*
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.swp,*.zip,*.png,*.jpg,*.gif
set wildignore+=*DS_Store*
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

set nofoldenable

nnoremap <silent> <Leader>t :TagbarToggle<CR>

" GUI and stuff
if has('gui_running')
    if has('win32')
        set guifont=Consolas:h8
        set enc=utf-8
    else
        if has('unix')
            set guifont=Monospace\ 8
        else
            let s:uname = system('uname')
            if s:uname == 'Darwin'
                set guifont=Menlo\ Regular:h11
            endif
        endif
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
au FileType python call TextEnableCodeSnip('c', "iface.verify('''", "'''", 'SpecialComment')
"au FileType python call TextEnableCodeSnip('c', "iface.cdef('''", "'''", 'SpecialComment')

let g:UltiSnipsExpandTrigger="<c-j>"

" Go related mappings
au FileType go nmap <Leader>gi <Plug>(go-info)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gr <Plug>(go-run)
au FileType go nmap <Leader>gb <Plug>(go-build)
au FileType go nmap <Leader>gt <Plug>(go-test)
au FileType go nmap <Leader>gx <Plug>(go-def-tab)
au FileType go nnoremap <Leader>gs :sp <CR>:exe "GoDef"<CR>

" In the 21th century .md is markdown, not modula2
au BufRead,BufNewFile *.md set filetype=markdown

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1
