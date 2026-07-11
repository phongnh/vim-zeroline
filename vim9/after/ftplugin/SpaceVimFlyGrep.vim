vim9script

setlocal statusline=%<[FlyGrep]%(\ %{SpaceVim#plugins#flygrep#mode()}%)%(\ %{fnamemodify(getcwd(),\ ':~')}%)%=%{SpaceVim#plugins#flygrep#lineNr()}
