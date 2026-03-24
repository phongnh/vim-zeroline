let s:NAMES = { 'staged': 'Staged', 'unstaged': 'Unstaged', 'untracked': 'Untracked' }

function! zeroline#fugitive#Status() abort
    if exists('b:fugitive_status')
        return ['staged', 'unstaged', 'untracked']
                    \ ->filter('len(b:fugitive_status[v:val]) > 0')
                    \ ->map('s:NAMES[v:val] .. ": " .. len(b:fugitive_status[v:val])')
                    \ ->join(' | ')
    endif
    return ''
endfunction
