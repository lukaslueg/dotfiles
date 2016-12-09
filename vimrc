" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -so ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim
" Now you can install any plugin into a .vim/bundle/plugin-name/ folder
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

map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

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
"set runtimepath+=/usr/local/go/misc/vim
filetype plugin indent on
syntax on
syntax sync minlines=250

" Showing line numbers and length
set number  " show line numbers
set tw=79   " width of document (used by gd)
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
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

" sudo dnf install vim-plugin-powerline
let $PYTHONPATH='/usr/lib/python3.5/site-packages'
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2
set t_Co=256

" cd ~/.vim/bundle
" git clone https://github.com/kien/ctrlp.vim.git
let g:ctrlp_max_height = 30
set wildignore+=*.pyc,*.pyo
set wildignore+=*_build/*
set wildignore+=*/coverage/*
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.swp,*.zip,*.png,*.jpg,*.gif
set wildignore+=*DS_Store*
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

let g:flake8_cmd="python3-flake8"
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1
autocmd BufWritePost *.py call Flake8()

" Better navigating through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Python folding
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492
set nofoldenable

" Riv
" https://github.com/Rykka/riv.vim
let g:riv_fold_auto_update = 0

" Tagbar
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
    set guioptions-=T  "remove toolbar
    set lines=60 columns=100  " Some more space for GUI-version
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
