function! s:ZoomState() abort
    return get(b:, 'zeroline_zoomstate', 0) ? '[Z]' : ''
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

    if &spell
        call add(l:parts, '[' .. toupper(tr(&spelllang, ',', '/')) .. ']')
    endif

    call add(l:parts, &expandtab ? '[S:' .. s:Shiftwidth() .. ']' : '[T:' .. &tabstop .. ']')

    let l:encoding = empty(&fileencoding) ? &encoding : &fileencoding
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
    if g:statusline_winid == win_getid(winnr())
        let l:zoom = s:ZoomState()
        let l:indicators = s:Indicators()
        return '%<%f%' .. l:zoom .. ' %w%m%r%=' .. l:indicators .. '%y'
    else
        return '%<%f %m%r'
    endif
endfunction
