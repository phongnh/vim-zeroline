vim9script

setlocal statusline=%<[GV]%(\ %{winwidth(0)>=60?'o:\ open\ split\ \|\ O:\ open\ tab\ \|\ gb:\ GBrowse\ \|\ q:\ quit':''}%)%=%4l:%-3c\ %P
