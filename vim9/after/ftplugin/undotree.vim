vim9script

setlocal statusline=%<[Undo]%(\ %{exists('t:undotree')?t:undotree.GetStatusLine():''}%)
