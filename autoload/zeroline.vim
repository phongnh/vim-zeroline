function! s:ZoomState() abort
    return get(g:, 'zeroline_zoomstate', 0) ? '[Z]' : ''
endfunction

function! s:Shiftwidth() abort
    return exists('*shiftwidth') ? shiftwidth() : &shiftwidth
endfunction

function! s:Indicators() abort
    let l:parts = []

    if stridx(&clipboard, 'unnamed') > -1
        call add(l:parts, '[C]')
    endif

    if &paste
        call add(l:parts, '[P]')
    endif

    if len(l:parts) > 0
        call add(l:parts, ' ')
    endif

    return join(l:parts, '')
endfunction

function! s:BufferIndicators() abort
    let l:parts = []

    if &spell
        call add(l:parts, '[' .. toupper(tr(&spelllang, ',', '/')) .. ']')
    endif

    call add(l:parts, &expandtab ? '[S:' .. s:Shiftwidth() .. ']' : '[T:' .. &tabstop .. ']')

    let l:encoding = !empty(&fileencoding) ? &fileencoding : &encoding
    if !empty(l:encoding) && l:encoding !=# 'utf-8'
        call add(l:parts, '[' .. l:encoding .. ']')
    endif

    if &bomb | call add(l:parts, '[bomb]') | endif
    if !&eol | call add(l:parts, '[noeol]') | endif

    if !empty(&fileformat) && &fileformat !=# 'unix'
        call add(l:parts, '[' .. &fileformat .. ']')
    endif

    return join(l:parts, '')
endfunction

function! zeroline#Statusline() abort
    let l:current_winid = get(g:, 'statusline_winid', get(g:, 'actual_curwin', -1))->str2nr()
    if l:current_winid == win_getid(winnr())
        let l:zoom = s:ZoomState()
        let l:indicators = s:Indicators()
        let l:buffer_indicators = s:BufferIndicators()
        return l:indicators .. '%<%f' .. l:zoom .. '%w%m%r %= ' .. l:buffer_indicators .. '%y'
    else
        return '%<%f%m%r'
    endif
endfunction
