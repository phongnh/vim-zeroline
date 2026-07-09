vim9script

setlocal statusline=[%{getwininfo(win_getid())[0]['loclist']?'Location':'Quickfix'}]%(\ %<%{get(w:,'quickfix_title','')}%)
