setlocal statusline=%<[Netrw]%(\ %{exists('b:netrw_curdir')?fnamemodify(b:netrw_curdir,':p:~:.:h'):''}%)%=%([%{g:netrw_sort_by}:%{get(g:,'netrw_sort_direction','n')=~#'n'?'+':'-'}]%)
