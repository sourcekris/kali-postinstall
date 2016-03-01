set t_Co=256
syntax on
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

set nu
set ruler
set cmdheight=1
set backspace=eol,start,indent

set shiftwidth=4
set tabstop=4
set expandtab
set softtabstop=4
set shiftround
set smarttab
set smartindent

set smartcase
set incsearch
set ignorecase
set hlsearch
set showmatch

set laststatus=2
set cursorline

highlight LineNr term=bold cterm=NONE ctermfg=Grey gui=NONE guifg=DarkGrey guibg=NONE
highlight CursorLineNr ctermfg=White guifg=White
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

