if exists('g:loaded_vim_zeroline') || v:version < 700
    finish
endif

let g:loaded_vim_zeroline = 1

let s:save_cpo = &cpo
set cpo&vim

" Disable Vim Quickfix's statusline
let g:qf_disable_statusline = 1

" Disable NERDTree statusline
let g:NERDTreeStatusline = -1

" ZoomWin
let g:ZoomWin_funcref = function('zeroline#zoomwin#Hook')

" Command-line Window
augroup VimZerolineAutocmds
    autocmd!
    autocmd CmdwinEnter * set filetype=cmdline syntax=vim
augroup END

set statusline=%!zeroline#Statusline()

if exists('+tabline')
    set tabline=%!zeroline#tabline#Status()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
