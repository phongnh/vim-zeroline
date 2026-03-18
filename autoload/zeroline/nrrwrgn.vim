function! zero#NrrwRgn#Status() abort
    if exists('b:nrrw_instn')
        let b:nrrw_name = 'NrrwRgn#' .. b:nrrw_instn
    else
        let b:nrrw_name = substitute(bufname('%'), '^NrrwRgn_\zs.*\ze_\d\+$', submatch(0), '')
        let b:nrrw_name = substitute(b:nrrw_name, '__', '#', '')
    endif

    let l:status = exists('*nrrwrgn#NrrwRgnStatus()') ? nrrwrgn#NrrwRgnStatus() : {}
    let b:nrrw_buffer = ''

    if len(l:status)
        let b:nrrw_name ..= {v: ' [C]', V: '', '': ' [B]'}[l:status.visual ? l:status.visual : 'V']
        let b:nrrw_buffer = fnamemodify(l:status.fullname, ':~:.')
        if l:status.multi
            let b:nrrw_name = 'Multi' .. l:status['name']
        else
            let b:nrrw_buffer ..= ' [' .. l:status.start[1] .. '-' .. l:status.end[1] .. ']'
        endif
    elseif get(b:, 'orig_buf', 0)
        let b:nrrw_buffer = bufname(b:orig_buf)
    endif

    return '%<[%{b:nrrw_name}]%( %{b:nrrw_buffer}%)'
enddef
