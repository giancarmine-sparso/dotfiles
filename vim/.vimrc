" ============================================================
" Minimal Vim configuration
" ============================================================

" --- Core ---------------------------------------------------

set nocompatible

syntax on
filetype plugin indent on


" --- Appearance ---------------------------------------------

set number
set relativenumber

set background=dark

" True color, se supportato dal terminale
if has('termguicolors')
    set termguicolors
endif

set termguicolors 
set background=dark
colorscheme  elflord

" Evidenzia la riga corrente
set nocursorline

" Mostra la modalità corrente (-- INSERT --, ecc.)
set showmode

" Un po' di spazio sopra/sotto il cursore
set scrolloff=5

" Non andare a capo visivamente sulle righe lunghe
set nowrap


" --- Cursor -------------------------------------------------

" Normal mode  -> blocco
" Insert mode  -> barra verticale
" Replace mode -> underscore

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"


" --- Indentation --------------------------------------------

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent


" --- Search -------------------------------------------------

set ignorecase
set smartcase
set incsearch
set hlsearch


" --- Editing ------------------------------------------------

" Backspace normale anche su indentazione e newline
set backspace=indent,eol,start

" Permette di cambiare buffer senza salvare subito
set hidden

" Undo persistente tra sessioni
if has('persistent_undo')
    set undofile
endif

" Evidenzia la parentesi corrispondente
set showmatch


" --- Status line --------------------------------------------

function! ModeName()
    let l:mode = mode()
    if l:mode ==# 'n'
        return 'NORMAL'
    elseif l:mode ==# 'i'
        return 'INSERT'
    elseif l:mode ==# 'v'
        return 'VISUAL'
    elseif l:mode ==# 'V'
        return 'V-LINE'
    elseif l:mode ==# "\<C-v>"
        return 'V-BLOCK'
    elseif l:mode ==# 'R'
        return 'REPLACE'
    elseif l:mode ==# 'c'
        return 'COMMAND'
    endif
    return toupper(l:mode)
endfunction

set laststatus=2
set noshowmode

set statusline=
set statusline+=\ %{ModeName()}
set statusline+=\ │\ %f
set statusline+=%m
set statusline+=%=
set statusline+=\ [%Y]
set statusline+=\ │\ %l:%c
set statusline+=\ │\ %p%%
set statusline+=\ 
" --- Clipboard ----------------------------------------------

" Usa la clipboard di sistema solo se Vim la supporta
if has('clipboard')
    set clipboard=unnamedplus
endif

" --- Auto pairs ---------------------------------------------

inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" --- Leader -------------------------------------------------

let mapleader = " "

" Rimuove highlight della ricerca
nnoremap <leader>h :nohlsearch<CR>

" Salva
nnoremap <leader>w :write<CR>

" Esci
nnoremap <leader>q :quit<CR>
