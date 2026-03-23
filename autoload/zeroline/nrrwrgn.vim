let s:visual_mode_indicators = { '': '', 'v': ' [C]', 'V': '', '': ' [B]', '\<C-V>': ' [B]' }

function! s:GetMode() abort
    let l:name = exists('b:nrrw_instn') ? 'NrrwRgn#' .. b:nrrw_instn : 'NrrwRgn'
    let l:prefix = stridx(bufname('%'), 'NrrwRgn_multi') == 0 ? 'Multi' : ''
    let l:visual = ''
    let l:status = nrrwrgn#NrrwRgnStatus()
    if !empty(l:status)
        let l:prefix = l:status.multi ? 'Multi' : ''
        let l:visual = s:visual_mode_indicators[l:status.visual]
    endif
    return '[' .. l:prefix .. l:name .. ']' .. l:visual
endfunction

function! s:GetLineRange() abort
    let l:status = nrrwrgn#NrrwRgnStatus()
    if !empty(l:status) && !l:status.multi
        return printf(' [%d-%d]', l:status.start[1], l:status.end[1])
    endif
    return ''
endfunction

function! s:GetBufName() abort
    let l:fullname = get(nrrwrgn#NrrwRgnStatus(), 'fullname', '')
    let l:bufname = !empty(l:fullname) ? l:fullname : bufname(get(b:, 'orig_buf', '%'))
    return fnamemodify(l:bufname, ':~:.')
endfunction

function! zeroline#nrrwrgn#Status() abort
    return s:GetMode() .. ' ' .. s:GetBufName() .. s:GetLineRange()
endfunction
