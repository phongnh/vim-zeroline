function! zeroline#fern#Status() abort
    let l:data = matchlist(expand('%'), '^fern://\(.\+\)/file://\(.\+\)\$')

    if empty(data)
        return '[Fern]'
    endif

    let l:name = get(l:data, 1, '')
    let l:name = stridx(l:name, 'drawer') > -1 ? 'Drawer' : 'Fern'

    let l:folder = get(data, 2, '')
    let l:folder = substitute(l:folder, ';\?\(#.\+\)\?\$\?$', '', '')
    let l:folder = fnamemodify(l:folder, ':p:~:.:h')

    return '[' .. l:name .. ']' .. ' ' .. l:folder
endfunction
