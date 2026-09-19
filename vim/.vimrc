" Minimal, portable Vim configuration

" Core
set nocompatible
syntax on
filetype plugin indent on

" Appearance
set number
set relativenumber
set background=dark
set background=dark
colorscheme desert
set scrolloff=5
set nowrap

" Cursor
if !has('gui_running') && exists('&t_SI') && exists('&t_EI')
    let &t_SI = "\<Esc>[6 q"
    let &t_EI = "\<Esc>[1 q"
endif

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Editing
set backspace=indent,eol,start
set hidden
set showmatch

" Status line
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
set statusline+=\ \|\ %f%m
set statusline+=%=
set statusline+=\ [%Y]
set statusline+=\ \|\ %l:%c
set statusline+=\ \|\ %p%%

" Clipboard
if has('clipboard')
    set clipboard=unnamedplus
endif

" Leader
let mapleader = " "
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>

" C
augroup vimrc_c
    autocmd!
    autocmd FileType c setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup END

nnoremap <leader>c :write<CR>:execute '!gcc -Wall -Wextra -std=c11 ' . shellescape(expand('%:p')) . ' -o ' . shellescape(expand('%:p:r'))<CR>
nnoremap <leader>r :write<CR>:execute '!gcc -Wall -Wextra -std=c11 ' . shellescape(expand('%:p')) . ' -o ' . shellescape(expand('%:p:r')) . ' && ' . shellescape(expand('%:p:r'))<CR>
