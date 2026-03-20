let s:names = { 'staged': 'Staged', 'unstaged': 'Unstaged', 'untracked': 'Untracked' }

function! zeroline#fugitive#Status() abort
    if exists('b:fugitive_status')
        " let l:result = []
        " for l:key in ['staged', 'unstaged', 'untracked']
        "     let l:count = len(b:fugitive_status[l:key])
        "     if l:count > 0
        "         call add(l:result, printf('[%s: %d]', s:names[l:key], l:count))
        "     endif
        " endfor
        " return join(l:result)
        return filter(['staged', 'unstaged', 'untracked'], 'len(b:fugitive_status[v:val]) > 0')
                    \ ->map('"[" .. s:names[v:val] .. ": " .. len(b:fugitive_status[v:val]) .. "]"')
                    \ ->join()
    endif
    return ''
endfunction
