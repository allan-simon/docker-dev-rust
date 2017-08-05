set mouse=a
"
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab

set expandtab
set smartindent

set wildmode=longest,full 

set autochdir

set showcmd

colorscheme torte

"the status bar is always displayed
set laststatus=2 
if has("statusline")
    set statusline=%<%f%h%m%r%=%l,%c\ %P  
elseif has("cmdline_info")
    set ruler " display cursor position
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'rust-lang/rust.vim'

Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" for autocompletion

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" for fuzzy completion
Plug 'Shougo/denite.nvim'
Plug 'Shougo/echodoc.vim'
" to display in red extra whitespaces
Plug 'ntpeters/vim-better-whitespace'

Plug 'benekastah/neomake'


" Initialize plugin system
call plug#end()


" for language server

set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" used by deoplete
let g:deoplete#enable_at_startup = 1


" to easily switch from a split containing a terminal to an other split
" see https://medium.com/@garoth/neovim-terminal-usecases-tricks-8961e5ac19b9
func! s:mapMoveToWindowInDirection(direction)
    func! s:maybeInsertMode(direction)
        stopinsert
        execute "wincmd" a:direction

        if &buftype == 'terminal'
            startinsert!
        endif
    endfunc

    execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
                \ "<C-\\><C-n>"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
    execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
endfunc
for dir in ["h", "j", "l", "k"]
    call s:mapMoveToWindowInDirection(dir)
endfor
