" =====================================================================================================================
" Basic vim settings
syntax on
set clipboard+=unnamedplus

" disable error sounds
set belloff=all
set noerrorbells

" set tab as 4 spaces
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab

" set indentation based on file type
set smartindent
filetype on
filetype plugin indent on

" add line number, disable wrapping, disable swapfiles & backup
set relativenumber  " adds relative line numbers
set nowrap
set smartcase
set noswapfile
set nobackup

" setting undo directory for undotree
set undodir=~/.vim/undodir
set undofile

" incremental search using / and do not highlight
set incsearch
set nohlsearch

" sane file settings
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" show ruler at 120 column
set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey

" vim settings for updatetime, font, always show status bar and cmd height
set updatetime=50
set guifont=Fira\ Mono:h15
set laststatus=2
set cmdheight=1

" enable mouse
set mouse=a
let g:is_mouse_enabled = 1
noremap <silent> <Leader>m :call ToggleMouse()<CR>
function ToggleMouse()
    if g:is_mouse_enabled == 1
        echo "Mouse OFF"
        set mouse=
        let g:is_mouse_enabled = 0
    else
        echo "Mouse ON"
        set mouse=a
        let g:is_mouse_enabled = 1
    endif
endfunction

" =====================================================================================================================
" Augroups and some functions

" html, css and javascript will have tab as 2 spaces
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup filetype_html
    autocmd!
    :autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup end

augroup filetype_css
    autocmd!
    :autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup end

augroup filetype_javascript
    autocmd!
    :autocmd FileType javascript setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup end

augroup THE_PRIMEAGEN
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
    "autocmd VimEnter * :VimApm
augroup END

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 50})
augroup END

" =====================================================================================================================
" Install plugins

" anything between call plug#begin() and call plug#end() will be installed
call plug#begin('~/.vim/plugged')
" color schemes
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'chriskempson/base16-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'joshdick/onedark.vim'

" python specific plugins
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/syntastic'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'prettier/vim-prettier'
Plug 'psf/black' , { 'tag': '19.10b0' }
Plug 'preservim/nerdcommenter'

" vim improvement plugins
Plug 'vim-utils/vim-man'  " man pages for vim
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
Plug 'ap/vim-buftabline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/vim-gitbranch'
Plug 'mbbill/undotree'
Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'tpope/vim-dispatch'
Plug 'qpkorr/vim-bufkill'
" a game to learn vim
Plug 'ThePrimeagen/vim-be-good'
call plug#end()

" Plugins not in use
" Plug 'valloric/youcompleteme'
" Plug 'jremmen/vim-ripgrep'  " very fast grep
" Plug 'ctrlpvim/ctrlp.vim' " fast file finding
" Plug 'jiangmiao/auto-pairs'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'gruvbox-community/gruvbox'
" Plug 'tjdevries/colorbuddy.vim'
" Plug 'tjdevries/gruvbuddy.nvim'
" Plug 'mhinz/vim-startify'
" Plug 'sainnhe/lightline_foobar.vim'
" Plug 'itchyny/lightline.vim'
" Plug 'ThePrimeagen/vim-apm'

" =====================================================================================================================
" Setting the color scheme

" base 16 settings
"if filereadable(expand("~/.vimrc_background"))
  "let base16colorspace=256
  "source ~/.vimrc_background
"endif

" gruvbox settings
" set contrast first and then the color scheme
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
colorscheme gruvbox

" gruvbox material settings
"set termguicolors
"let g:gruvbox_material_background = 'hard'
"colorscheme gruvbox-material
"set background=dark

" gruvbuddy settings
" lua require('colorbuddy').colorscheme('gruvbuddy')

" ayu settings
"set termguicolors     " enable true colors support
"let ayucolor="dark"   " for dark version of theme
"colorscheme ayu

" one dark settings
"set background=dark
"colorscheme onedark

" =====================================================================================================================
" Disable auto indent while pasting

" source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" =====================================================================================================================
" Plugin Settings: ripgrep

" run rip grep at the root of current dir
if executable('rg')
    let g:rg_derive_root='true'
endif

" =====================================================================================================================
" Plugin Settings: git-checkout

let g:fzf_layout = {'window': {'width': 0.8, 'height': 0.8} }
let $FZF_DEFAULT_OPTS='--reverse'

" =====================================================================================================================
" Plugin Settings: ctrl-p

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:netrw_browse_split=2
let g:netrw_banner=0
let g:netrw_winsize=25
let g:ctrlp_use_caching=0

" =====================================================================================================================
" Plugin Settings: syntastic

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args="--ignore=E501"
let g:syntastic_python_pylint_args="-d C0301,C0103,C0111,W0105,W0621"

let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_typescript_checkers=['eslint']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" =====================================================================================================================
"Plugin Settings: youcompleteme
" ycm is disabled as of now
" use pipenv if activated

"  let g:ycm_auto_hover=''
" let g:ycm_autoclose_preview_window_after_completion=1
" let pipenv_venv_path = system('pipenv --venv')
" if v:shell_error == 0
"    let venv_path = substitute(pipenv_venv_path, '\n', '', '')
"    let g:ycm_binary_path = venv_path . '/bin/python'
" else
"    let g:ycm_binary_path = 'python'
" endif
" let g:ycm_min_num_of_chars_for_completion = 99
" let g:ycm_semantic_triggers = {
"    \   'python': [ 're!\w{2}' ]
"    \ }

" =====================================================================================================================
" Plugin Settings: kite
" kite is disabled as of now

" kite settings
" let g:kite_snippets=0
" let g:kite_tab_complete=1
" set belloff+=ctrlg  " if vim beeps during completion
" autocmd CompleteDone * if !pumvisible() | pclose | endif

" =====================================================================================================================
" Plugin Settings: coc
" coc related settings including keymaps are stored in below file
" source /home/smit/.vim/plug-config/coc.vim

" =====================================================================================================================
" nvim lsp settings & mappings

set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c
lua require'nvim_lsp'.pyls_ms.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.tsserver.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.html.setup{ on_attach=require'completion'.on_attach }

nnoremap gd :lua vim.lsp.buf.definition()<CR>
nnoremap vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>

" =====================================================================================================================
" Plugin Settings: black

" black format on save
autocmd BufWritePre *.py execute ':Black'

" =====================================================================================================================
" Plugin Settings: prettier

" prettier format on save
let g:prettier#autoformat = 0
let g:prettier#autoformat_config_files = ['.prettierrc']
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.html,*.css Prettier

" =====================================================================================================================
" Plugin Settings: NERDtree

" file browser
let g:NERDTreeNodeDelimiter = "\u00a0"
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 0  " setting it to 1 hides ..(up a dir) button in nerdtree
let g:nerdtree_open = 0
let g:nerdtree_tabs_open_on_gui_startup = 0  " this stops nerdtree from opening in gui version

" =====================================================================================================================
" Plugin Settings: light-line
"
"set noshowmode
"let g:lightline = {
      "\ 'colorscheme': 'gruvbox_material',
      "\ 'active': {
      "\   'left': [ [ 'mode', 'paste' ],
      "\             [ 'gitbranch', 'readonly', 'filename', 'modified'] ],
      "\ },
      "\ 'component_function': {
      "\   'gitbranch': 'gitbranch#name',
      "\ }
      "\ }

" install fonts from below repository for arrow like separators in lightline
" default fonts dont have those separator characters
" https://github.com/powerline/fonts

" =====================================================================================================================
" Keymaps:

let mapleader = " "
inoremap jj <esc>
" move between windows
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>l :wincmd l<CR>
" move through buffers
nmap <leader>[ :bp!<CR>
nmap <leader>] :bn!<CR>
nmap <leader>x :BD<CR>
" file finding in current directory
nnoremap <C-p> :Files<CR>
" perform a string/regex search in project
nnoremap <leader>ps :Rg <C-R>=expand("<cword>")<CR><CR>
" word movement
imap <S-Left> <Esc>bi
nmap <S-Left> b
imap <S-Right> <Esc><Right>wi
nmap <S-Right> w
" shortcuts: copy, cut and paste
vmap <C-c> "+y
vmap <C-x> "+c
map <C-a> :%y+<CR>
vmap <C-v> <ESC>"+p
imap <C-v> <ESC>"+pa
" shortcuts: indent/unindent with tab/shift-tab
nmap <Tab> >>
imap <S-Tab> <Esc><<i
nmap <S-tab> <<
" shortcuts: syntastic
map <leader>s :SyntasticCheck<CR>
map <leader>d :SyntasticReset<CR>
map <leader>e :lnext<CR>
map <leader>r :lprev<CR>
" shortcuts: tag list
map <leader>t :TagbarToggle<CR>
" shortcuts: NerdTree
map <leader>n :NERDTreeToggle<CR>
nnoremap <silent> <leader>pv :NERDTreeFind<CR>
" shortcuts: UndoTree
map <leader>u :UndotreeShow<CR>
" shortcuts: youcompleteme: now disabled
" nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>
" nnoremap <silent> <Leader>gr :YcmCompleter GoToReferences<CR>
" nnoremap <silent> <Leader>rr :YcmCompleter RefactorRename<CR>
" nnoremap <silent> <Leader>gf :YcmCompleter FixIt<CR>
" shortcuts: vim-fugitive
nmap <Leader>ga :diffget //3<CR>
nmap <Leader>gl :diffget //2<CR>
nmap <Leader>gs :G<CR>
" shortcuts: git checkout
nnoremap <Leader>gc :Gcommit<CR>
" shortcuts: nerd commenter
" https://github.com/preservim/nerdcommenter#default-mappings

" shortcuts: visual mode remaps
vnoremap X "_d
" greatest remap ever
vnoremap <leader>p "_dP
com! W w
nnoremap <leader>rc :e ~/.vimrc<CR>
" =====================================================================================================================
" EXPERIMENTAL SECTION: Hard mode: Disabling arrow keys in Normal & Visual mode only Keymaps will still work
" Hard mode: Disabling arrow keys in all modes.
" https://stackoverflow.com/questions/1737163/traversing-text-in-insert-mode
" If you just want to disable the keys in normal and visual mode, delete
" inoremap and cnoremap in the loop

for key in ['<Up>', '<Down>', '<Left>', '<Right>']
  exec 'noremap' key '<Nop>'
  exec 'inoremap' key '<Nop>'
"  exec 'cnoremap' key '<Nop>'
endfor
