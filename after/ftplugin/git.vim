setlocal statusline=%<[Git]\ %{get(b:,'fugitive_type','')==#'commit'?(winwidth(0)>=60?expand('%:t'):expand('%:t')[0:8]):''}%=%4l:%-3c\ %P
