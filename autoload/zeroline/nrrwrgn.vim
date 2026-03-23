let s:visual_mode_indicators = { 'v': ' [C]', 'V': '', '': ' [B]'}

function! s:GetName() abort
    if exists('b:nrrw_instn')
        return 'NrrwRgn#' .. b:nrrw_instn
    endif
    let l:name = substitute(bufname('%'), '^NrrwRgn_\zs.*\ze_\d\+$', submatch(0), '')
    return substitute(l:name, '__', '#', '')
endfunction

function! zeroline#nrrwrgn#Status() abort
    let l:name = s:GetName()
    let l:buffer = ''

    if exists('*nrrwrgn#NrrwRgnStatus()')
        let l:status = nrrwrgn#NrrwRgnStatus()

        if !empty(l:status)
            let l:prefix = l:status.multi ? 'Multi' : ''
            let l:indicator = s:visual_mode_indicators[l:status.visual ? l:status.visual : 'V']
            let l:name = l:prefix .. l:name .. l:indicator

            let l:buffer = fnamemodify(l:status.fullname, ':~:.')
            if !l:status.multi
                let l:buffer ..= printf(' [%d-%d]', l:status.start[1], l:status.end[1])
            endif
        endif
    endif

    if empty(l:buffer) && get(b:, 'orig_buf', 0)
        let l:buffer = bufname(b:orig_buf)
    endif

    if empty(buffer)
        return '[' .. l:name .. ']'
    endif

    return '[' .. l:name .. '] ' .. l:buffer
enddef
