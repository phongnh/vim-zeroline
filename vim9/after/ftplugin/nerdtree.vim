vim9script

setlocal statusline=%<[NERDTree]%(\ %{exists('b:NERDTree')?fnamemodify(b:NERDTree.root.path.str(),':p:~:.:h'):''}%)
