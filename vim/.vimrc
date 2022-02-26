execute pathogen#infect()

filetype plugin indent on
syntax enable
set ignorecase
set smartcase
set incsearch
set ls=2
set nu

set nocompatible
set title
set number
set numberwidth=5
set novisualbell
set noerrorbells
set cursorline
set laststatus=2
set linespace=0
set matchtime=5
set nostartofline
set showcmd
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
syntax on
set smartindent
set cindent
set undolevels=1000

"Sets default Explore list mode
"let g:netrw_liststyle=3
"
""-------Bundles-------
"ctrlp
"set runtimepath^=~/.vim/bundle/ctrlp.vim
"set wildignore+=*/tmp/*,*.so,*.swp,*.zip
"
""vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set encoding=utf-8

""Colorscheme
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'soft'
set background=dark

au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
