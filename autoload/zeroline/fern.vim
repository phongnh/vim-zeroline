function! zeroline#fern#Status() abort
    let l:mode = 'Fern'

    let l:data = matchlist(expand('%'), '^fern://\(.\+\)/file://\(.\+\)\$')

    if len(l:data)
        if stridx(get(l:data, 1, ''), 'drawer') > -1
            let l:mode = 'Drawer'
        endif

        let l:folder = substitute(get(data, 2, ''), ';\?\(#.\+\)\?\$\?$', '', '')
        let l:folder = fnamemodify(l:folder, ':p:~:.:h')

        return '[' .. l:mode .. ']' .. ' ' .. l:folder
    endif

    return '[' .. l:mode .. ']'
endfunction
