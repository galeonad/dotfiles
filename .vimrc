let mapleader=' '
let maplocalleader = ' '

" plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" NOTE: Here is where you install your plugins.
call plug#begin()

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" "gc" to comment visual regions/lines
Plug 'tpope/vim-commentary'

Plug 'tpope/vim-sleuth'

" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

set number
set relativenumber
set nowrap
syntax on
filetype plugin indent on
set autoindent
set autoread
set background=dark
set encoding=utf-8
set history=1000
set incsearch
set nohlsearch
set ruler
set smarttab
set expandtab
set omnifunc=syntaxcomplete#Complete  " great completion with CTRL+O
set updatetime=250   " to trigger plugins more frequently


" Keymaps for better default experience
nnoremap <silent> <Space> <Nop>
xnoremap <silent> <Space> <Nop>

" Remap for dealing with word wrap
" nnoremap <expr> <silent> k v:count == 0 ? 'gk' : 'k'
" nnoremap <expr> <silent> j v:count == 0 ? 'gj' : 'j'

" Remap to move lines in visual mode
vnoremap J  :m '>+1<CR>gv=gv
vnoremap K  :m '<-2<CR>gv=gv

" Remap to cursor in the middle when searching
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap N Nzzzv
nnoremap n nzzzv

xnoremap <leader>y y:call system("wl-copy", @")<cr>
xnoremap <leader>p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
xnoremap <leader>d "_d
nnoremap <leader>d "_d

nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
" [[ Configure fzf.vim ]]
" See `:help fzf-vim`
nmap <leader>? :History<CR>
nmap <leader><space> :Buffers<CR>
nmap <leader>/ :BLines<CR>
nmap <leader>gf :GFiles<CR>
nmap <leader>sf :Files<CR>
nmap <leader>sh :Helptags<CR>



" Performance related settings, requires Vim 8.2+
let g:lsp_use_native_client = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_semantic_enabled = 0
let g:lsp_format_sync_timeout = 200
" let g:lsp_diagnostics_virtual_text_align = "right"
let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_padding_left = 8
let g:lsp_diagnostics_signs_enabled = 0

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  " Keymaps
  " Go to previous diagnostic message
  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  " Go to next diagnostic message
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)

  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>ca <plug>(lsp-code-action-float)

  " [G]oto [D]efinition
  nmap <buffer> gd <plug>(lsp-definition)
  " [G]oto [R]eferences
  nmap <buffer> gr <plug>(lsp-references)
  " [G]oto [I]mplementation
  nmap <buffer> gI <plug>(lsp-implementation)

  nmap <buffer> <leader>D <plug>(lsp-peek-type-definition)
  nmap <buffer> <leader>ds <plug>(lsp-document-symbol-search)
  nmap <buffer> <leader>ws <plug>(lsp-workspace-symbol-search)

  " See `:help K` for why this keymap
  " Hover Documentation
  nmap <buffer> K <plug>(lsp-hover)
  " Signature Documentation
  nmap <buffer> <C-k> <plug>(lsp-signature-help)

  " Lesser used LSP functionality
  " [G]oto [D]eclaration
  nmap <buffer> gD <plug>(lsp-declaration)

  " Create a command `:Format` local to the LSP buffer
  command Format LspDocumentFormatSync
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
