vim9script

# Tabline
var tabline_cache = {bufnames: {}, last_cleanup: 0}

def Hi(section: string): string
    return $'%#{section}#'
enddef

def TabPlaceholder(tab: number): string
    return Hi('TabLineFill') .. $'%{tab}  … %*'
enddef

def TabNumber(n: number): string
    return $'{n}: '
enddef

def TabBufferType(bufnr: number): string
    const buftype = getbufvar(bufnr, '&filetype')
    return !empty(buftype) ? buftype : getbufvar(bufnr, '&buftype')
enddef

# Get buffer name with caching to improve performance
def TabBufferName(bufnr: number): string
    # Check cache first - return cached result if buffer hasn't changed
    const changedtick = getbufvar(bufnr, 'changedtick', -1)
    var cached = get(tabline_cache.bufnames, bufnr, {})

    if !empty(cached) && cached.tick == changedtick
        return cached.name
    endif

    # Compute buffer name
    var bufname = bufname(bufnr)
    var result: string

    if bufname =~# '^\[preview'
        result = 'Preview'
    else
        const buftype = TabBufferType(bufnr)

        if buftype ==# 'nofile' && bufname =~# '\/.'
            bufname = substitute(bufname, '.*\/\ze.', '', '')
        endif

        bufname = fnamemodify(bufname, ':p:~:.')

        if strlen(bufname) > 30
            if bufname =~# '^[~/]'
                bufname = pathshorten(bufname, 1)
            else
                bufname = fnamemodify(bufname, ':t')
            endif
        endif

        result = empty(bufname) ? '[No Name]' : bufname
    endif

    # Store in cache
    tabline_cache.bufnames[bufnr] = {name: result, tick: changedtick}

    return result
enddef

def TabName(tabnr: number): string
    const winnr = tabpagewinnr(tabnr)
    const bufnr = tabpagebuflist(tabnr)[winnr - 1]
    const hi = (tabnr == tabpagenr() ? Hi('TabLineSel') : Hi('TabLine'))
    return $'%{tabnr}T{hi}' .. ' ' .. TabNumber(tabnr) .. TabBufferName(bufnr) .. ' '
enddef

export def Tabline(): string
    # Periodic cache cleanup to prevent memory leaks
    const now = localtime()
    if now - tabline_cache.last_cleanup > 60
        tabline_cache.bufnames = {}
        tabline_cache.last_cleanup = now
    endif

    const tab_count = tabpagenr('$')
    const max_tabs = &columns >= 120 ? (&columns / 35) : 3

    # Build tabline using array + join for better performance
    var parts = [Hi('Title'), ' TABS']

    if tab_count > max_tabs
        add(parts, $' [{tab_count}]')
    endif

    add(parts, ' %*')

    if tab_count <= max_tabs
        # Simple case: show all tabs
        for num in range(1, tab_count)
            add(parts, TabName(num))
        endfor
    else
        # Complex case: show windowed tabs around current tab
        const current_tab = tabpagenr()
        const current_index = current_tab - 1

        # Calculate visible window bounds
        var start_index: number
        var end_index: number

        if current_tab == 1
            start_index = 0
            end_index = max_tabs - 1
        elseif current_tab == tab_count
            start_index = tab_count - max_tabs
            end_index = tab_count - 1
        else
            start_index = max([0, current_index - max_tabs + 2])
            end_index = start_index + max_tabs - 1
        endif

        # Left placeholder for hidden tabs
        if current_index == (tab_count - 1) && start_index > 0
            add(parts, TabPlaceholder(start_index))
        elseif start_index > 0
            add(parts, TabPlaceholder(start_index + 1))
        endif

        # Visible tabs
        for num in range(start_index + 1, min([end_index + 1, tab_count]))
            add(parts, TabName(num))
        endfor

        # Right placeholder for hidden tabs
        if current_index < (tab_count - 1) && end_index < (tab_count - 1)
            add(parts, TabPlaceholder(end_index + 2))
        endif
    endif

    add(parts, Hi('TabLineFill') .. '%=')
    add(parts, Hi('TabLineSel') .. '%999X  ×  ')

    return join(parts, '')
enddef
