let s:names = { 'staged': 'Staged', 'unstaged': 'Unstaged', 'untracked': 'Untracked' }

function! zeroline#fugitive#Status() abort
    if exists('b:fugitive_status')
        return filter(['staged', 'unstaged', 'untracked'], 'len(b:fugitive_status[v:val]) > 0')
                    \ ->map('s:names[v:val] .. ": " .. len(b:fugitive_status[v:val])')
                    \ ->join(' | ')
    endif
    return ''
endfunction
