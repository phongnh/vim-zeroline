vim9script

setlocal statusline=%<[Diff]%(\ %{exists('t:diffpanel')&&t:diffpanel.bufname==#expand('%:t')?t:diffpanel.GetStatusLine():''}%)
