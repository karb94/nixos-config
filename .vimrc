filetype off
filetype plugin on
syntax on
syntax enable


"Settings
let &t_SI.="\e[6 q"             "Change cursor shape in insert mode
"For CX1
if $HOSTNAME !~ "login-[0-9][0-9]*"
    let &t_SR.="\e[4 q"         "Change cursor shape in replace mode
    set signcolumn=yes          "Vim gutter always active
endif
let &t_EI.="\e[2 q"             "Change cursor shape in normal mode
set backspace=indent,eol,start  "Backspace behaves like everywhere else
set shortmess=F                 "Suppresses the file info message
set nohlsearch                  "no highlights during search
set number relativenumber       "set relative number on
set incsearch                   "starts searching while you type
set ignorecase                  "Ingores case in searches
set smartcase                   "In combination with ignorecase, only ignores case when no uppercase is used
set tabstop=4                   "The tab key produces 4 'visual' spaces (only in vim, thus the need for expandtab)
set expandtab                   "Converts tabs into spaces
set path+=**                    "You can search for any file in any subdirectory (as long as you enter the exact name)
set wildmenu                    "It opens a horizontal menu where you cycle with <Tab> and <S-Tab>
set wildmode=longest:full,full  "Will complete to the longest common command
autocmd InsertEnter * set timeoutlen=200    "Time waited for mappings
autocmd InsertLeave * set timeoutlen=600    "Time waited for mappings
set shiftwidth=4                "Sets the number of spaces when indenting with '>>'
set autoindent                  "Sets new line with same indentation as current line
set smartindent                 "Auto-indents for {
if has('mac')
    set clipboard=unnamed
    autocmd VimLeave * call system("xsel -ib", getreg('*'))
else
    set clipboard=unnamedplus
    autocmd VimLeave * call system("xsel -ib", getreg('+'))
endif
let mapleader=" "               "Sets leader key


"Install the plugin manager vim-plug if it is not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call has('python3')
"Plugins
call plug#begin()
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-smooth-scroll'
Plug 'karb94/vim-sneak'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"if has('mac')
"    Plug 'ycm-core/YouCompleteMe', { 'do': '/usr/bin/python ./install.py --clang-completer' }
"elseif $HOSTNAME =~ "login-[0-9][0-9]*"
"else
"    Plug 'ycm-core/YouCompleteMe', { 'do': '/usr/bin/python ./install.py --clang-completer --system-libclang' }
"endif
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex', { 'for': ['tex','bib'] }
call plug#end()

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 1)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 5, 1)<CR>
noremap <silent> K :call smooth_scroll#up(5, 20, 1)<CR>
noremap <silent> J :call smooth_scroll#down(5, 20, 1)<CR>

"Sneak
let g:sneak#use_ic_scs = 1
let g:sneak#map_netrw = 0
let g:sneak#target_labels = ";ftuvnqz/SFGHLTUNRMQZ"
let g:sneak#label = 1
highlight Sneak ctermfg=Black ctermbg=226 cterm=bold
nnoremap <silent> f :<C-U>call sneak#wrap('',           1, 0, 1, 1)<CR>
nnoremap <silent> F :<C-U>call sneak#wrap('',           1, 1, 1, 1)<CR>
xnoremap <silent> f :<C-U>call sneak#wrap(visualmode(), 1, 0, 1, 1)<CR>
xnoremap <silent> F :<C-U>call sneak#wrap(visualmode(), 1, 1, 1, 1)<CR>

"Fuzzy Finder (FZF)
nnoremap <leader>b :Buffers<CR>
nnoremap <C-r> :History:<CR>
nnoremap <C-t> :Files<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>g :Rg<CR>

"" YouCompleteMe
let g:ycm_key_list_select_completion=['<C-j>','<Tab>']
let g:ycm_key_list_previous_completion=['<C-k>','<S-Tab>']
let g:ycm_max_num_identifier_candidates = 3
let g:ycm_max_num_candidates = 5

" Ultisnips
"Stupid workaround
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']
let g:UltiSnipsExpandTrigger="**"
let g:UltiSnipsJumpForwardTrigger="<C-n>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"
let g:UltiSnipsEditSplit="vertical"

" VimTex
if has('mac')
    let g:vimtex_compiler_progname = '~//usr/local/bin/vim'
endif
let g:vimtex_compiler_latexmk = {
            \ 'backend' : 'jobs',
            \ 'background' : 1,
            \ 'build_dir' : 'build',
            \ 'callback' : 1,
            \ 'continuous' : 1,
            \ 'executable' : 'latexmk',
            \ 'hooks' : [],
            \ 'options' : [
            \   '-verbose',
            \   '-file-line-error',
            \   '-synctex=1',
            \   '-interaction=nonstopmode',
            \ ],
            \}
let g:vimtex_view_method = 'zathura'

"Mappings
inoremap lk <Esc>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
vnoremap lk <Esc>
nnoremap <leader>c mbI#<Esc>`b
nnoremap <leader>u mb^x`b
nnoremap <leader>v :vsplit<CR><C-w>w
nnoremap <C-w> <C-w>w
nnoremap <leader>q :q!<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :x<CR>
nnoremap <silent><leader>o :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><leader>O :set paste<CR>m`O<Esc>``:set nopaste<CR>
nnoremap <leader>p :put<CR>=`[
nnoremap p pm`=`]``
nnoremap P Pm`=`]``
nnoremap <leader>rc :source $MYVIMRC<CR>
nnoremap <leader>j J
nnoremap H ^
nnoremap L $
nnoremap U :redo<CR>
nmap <leader>m :w<CR>:!clear; make -C build/<CR>

"Color
colorscheme peachpuff
highlight SpellBad cterm=bold ctermfg=9 ctermbg=0
highlight LineNr ctermfg=Yellow
highlight CursorLineNr ctermfg=Yellow
highlight Normal ctermfg=White
highlight Visual ctermbg=Black ctermfg=202
highlight incsearch ctermbg=Black ctermfg=202
highlight Pmenu ctermbg=233 ctermfg=White
highlight PmenuSel ctermbg=18 ctermfg=White
highlight MatchParen ctermbg=Black ctermfg=202
highlight Comment ctermbg=Black ctermfg=202
highlight SignColumn ctermbg=Black
highlight Error ctermbg=Black ctermfg=Red
hi VertSplit ctermbg=none ctermfg=green cterm=none
hi LineNr ctermfg=226 ctermbg=none 
hi CursorLineNr ctermfg=202 ctermbg=none cterm=bold

"Status bar
set laststatus=2    " Always show status bar
augroup statusBar
autocmd!
au InsertEnter * hi statusline ctermfg=226 ctermbg=none cterm=bold
au InsertLeave * hi statusline ctermfg=196 ctermbg=none cterm=bold
augroup END
" default the statusline to green when entering Vim
hi statusline ctermfg=196 ctermbg=none cterm=bold
hi statuslineNC ctermfg=52 ctermbg=none cterm=none
set statusline=%f%r%m%=%P

hi CursorLineFlash ctermfg=none ctermbg=125 cterm=none
nnoremap <C-K> :call HighlightNearCursor()<CR>
function HighlightNearCursor()
    let ln = line('.')
    for i in [1,2,3]
        let m = matchaddpos("CursorLineFlash", [ln])
        redraw
        sleep 50m
        call matchdelete(m)
        redraw
        sleep 50m
    endfor
endfunction

" Reset cursor on start:
augroup initialization
au!
autocmd VimEnter * :normal! :startinsert :stopinsert    "Reset cursor shape
augroup END
