vim9script

export def Status(): string
    const data = matchlist(expand('%'), '^fern://\(.\+\)/file://\(.\+\)\$')

    if empty(data)
        return '[Fern]'
    endif

    var name = get(data, 1, '')
    name = stridx(name, 'drawer') > -1 ? 'Drawer' : 'Fern'

    var folder = get(data, 2, '')
    folder = substitute(folder, ';\?\(#.\+\)\?\$\?$', '', '')
    folder = fnamemodify(folder, ':p:~:.:h')

    return $'[{name}] {folder}'
enddef
