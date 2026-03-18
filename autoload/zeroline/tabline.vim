" Tabline
let s:tabline_cache = { 'bufnames': {}, 'last_cleanup': 0 }

function! s:ShortenPath(filename) abort
    if exists('*pathshorten')
        return pathshorten(a:filename, 1)
    else
        return substitute(a:filename, '\v\w\zs.{-}\ze(\\|/)', '', 'g')
    endif
endfunction

function! s:Hi(section) abort
    return '%#' .. a:section .. '#'
endfunction

function! s:TabPlaceholder(tab) abort
    return s:Hi('TabLineFill') .. '%' .. a:tab .. '  … %*'
endfunction

function! s:TabNumber(n) abort
    return a:n .. ': '
endfunction

function s:TabBufferType(bufnr) abort
    let l:buftype = getbufvar(a:bufnr, '&filetype')
    return !empty(l:buftype) ? l:buftype : getbufvar(a:bufnr, '&buftype')
endfunction

" Get buffer name with caching to improve performance
function s:TabBufferName(bufnr) abort
    " Check cache first - return cached result if buffer hasn't changed
    let l:changedtick = getbufvar(a:bufnr, 'changedtick', -1)
    let l:cached = get(s:tabline_cache.bufnames, a:bufnr, {})

    if !empty(l:cached) && l:cached.tick == l:changedtick
        return l:cached.name
    endif

    " Compute buffer name
    let l:bufname = bufname(a:bufnr)

    if l:bufname =~# '^\[preview'
        let l:result = 'Preview'
    else
        let l:buftype = s:TabBufferType(a:bufnr)

        if l:buftype ==# 'nofile' && l:bufname =~# '\/.'
            let l:bufname = substitute(l:bufname, '.*\/\ze.', '', '')
        endif

        let l:bufname = fnamemodify(l:bufname, ':p:~:.')

        if strlen(l:bufname) > 30
            if l:bufname =~# '^[~/]'
                let l:bufname = s:ShortenPath(l:bufname)
            else
                let l:bufname = fnamemodify(l:bufname, ':t')
            endif
        endif

        let l:result = empty(l:bufname) ? '[No Name]' : l:bufname
    endif

    " Store in cache
    let s:tabline_cache.bufnames[a:bufnr] = {'name': l:result, 'tick': l:changedtick}

    return l:result
endfunction

function! s:TabName(tabnr) abort
    let l:winnr = tabpagewinnr(a:tabnr)
    let l:bufnr = tabpagebuflist(a:tabnr)[l:winnr - 1]
    let l:hi = (a:tabnr == tabpagenr() ? s:Hi('TabLineSel') : s:Hi('TabLine'))
    return '%' .. a:tabnr .. 'T' .. l:hi .. ' ' .. s:TabNumber(a:tabnr) .. s:TabBufferName(l:bufnr) .. ' '
endfunction

function! zeroline#tabline#Status() abort
    " Periodic cache cleanup to prevent memory leaks
    let l:now = localtime()
    if l:now - s:tabline_cache.last_cleanup > 60
        let s:tabline_cache.bufnames = {}
        let s:tabline_cache.last_cleanup = l:now
    endif

    let l:tab_count = tabpagenr('$')
    let l:max_tabs = &columns >= 120 ? (&columns / 35) : 3

    " Build tabline using array + join for better performance
    let l:parts = [s:Hi('TabLineLabel'), ' TABS']

    if l:tab_count > l:max_tabs
        call add(l:parts, ' [' .. l:tab_count .. ']')
    endif

    call add(l:parts, ' %*')

    if l:tab_count <= l:max_tabs
        " Simple case: show all tabs
        for l:num in range(1, l:tab_count)
            call add(l:parts, s:TabName(l:num))
        endfor
    else
        " Complex case: show windowed tabs around current tab
        let l:current_tab = tabpagenr()
        let l:current_index = l:current_tab - 1

        " Calculate visible window bounds
        if l:current_tab == 1
            let l:start_index = 0
            let l:end_index = l:max_tabs - 1
        elseif l:current_tab == l:tab_count
            let l:start_index = l:tab_count - l:max_tabs
            let l:end_index = l:tab_count - 1
        else
            let l:start_index = max([0, l:current_index - l:max_tabs + 2])
            let l:end_index = l:start_index + l:max_tabs - 1
        endif

        " Left placeholder for hidden tabs
        if l:current_index == (l:tab_count - 1) && l:start_index > 0
            call add(l:parts, s:TabPlaceholder(l:start_index))
        elseif l:start_index > 0
            call add(l:parts, s:TabPlaceholder(l:start_index + 1))
        endif

        " Visible tabs
        for l:num in range(l:start_index + 1, min([l:end_index + 1, l:tab_count]))
            call add(l:parts, s:TabName(l:num))
        endfor

        " Right placeholder for hidden tabs
        if l:current_index < (l:tab_count - 1) && l:end_index < (l:tab_count - 1)
            call add(l:parts, s:TabPlaceholder(l:end_index + 2))
        endif
    endif

    call add(l:parts, s:Hi('TabLineFill') .. '%=')
    call add(l:parts, s:Hi('TabLineClose') .. '%999X  ×  ')

    return join(l:parts, '')
endfunction
