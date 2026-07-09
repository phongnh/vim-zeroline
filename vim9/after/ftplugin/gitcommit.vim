vim9script

setlocal statusline=%<[Commit\ Message]%=%(%{&spell?zeroline#Spelllang():''}\ %)%4l:%-3c\ %P
