vim9script

setlocal statusline=%<[Netrw]%(\ %{exists('b:netrw_curdir')?fnamemodify(b:netrw_curdir,':p:~:.:h'):''}%)%=%([%{get(g:,'netrw_sort_direction','n')=~#'n'?'+':'-'}%{get(g:,'netrw_sort_by','')}]%)
