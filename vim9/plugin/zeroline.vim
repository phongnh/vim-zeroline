if exists('g:loaded_vim_zeroline') || !has('vim9script') || v:version < 900
    finish
endif

vim9script

g:loaded_vim_zeroline = true

# Disable Vim Quickfix's statusline
g:qf_disable_statusline = 1

# ZoomWin
g:ZoomWin_funcref = function('zeroline#zoomwin#Hook')

# Disable NERDTree statusline
g:NERDTreeStatusline = -1

augroup VimZerolineAutocmds
    autocmd!
    autocmd CmdwinEnter * set filetype=cmdline syntax=vim
    autocmd User FugitiveChanged zeroline#fugitive#FugitiveChanged()
augroup END

# For statusline and tabline expressions, use legacy autoload function syntax
set statusline=%!zeroline#Statusline()
set tabline=%!zeroline#tabline#Tabline()
