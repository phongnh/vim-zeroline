vim9script

const spelllang_maps = { 'en_us': 'US', 'en_gb': 'GB' }

# Statusline
def ZoomState(): string
    return get(g:, 'zeroline_zoomstate', 0) ? '[Z]' : ''
enddef

def Shiftwidth(): number
    return exists('*shiftwidth') ? shiftwidth() : &shiftwidth
enddef

def Indicators(): string
    var parts: list<string> = []

    if stridx(&clipboard, 'unnamed') > -1
        add(parts, '[C]')
    endif

    if &paste
        add(parts, '[P]')
    endif

    if len(parts) > 0
        add(parts, ' ')
    endif

    return join(parts, '')
enddef

export def Spelllang(): string
    return &spell ? split(&spelllang, ',')->map((_k, v) => '[' .. get(spelllang_maps, v, toupper(v)) .. ']')->join('/') : ''
enddef

def BufferIndicators(): string
    var parts: list<string> = []

    if &spell
        add(parts, Spelllang())
    endif

    add(parts, &expandtab ? $'[S:{Shiftwidth()}]' : $'[T:{&tabstop}]')

    const encoding = !empty(&fileencoding) ? &fileencoding : &encoding
    if !empty(encoding) && encoding !=# 'utf-8'
        add(parts, $'[{encoding}]')
    endif

    if &bomb | add(parts, '[bomb]') | endif
    if !&eol | add(parts, '[noeol]') | endif

    if !empty(&fileformat) && &fileformat !=# 'unix'
        add(parts, $'[{&fileformat}]')
    endif

    return join(parts, '')
enddef

# Public autoload function callable as zeroline#Statusline()
# In autoload files, exported functions are automatically available as autoload functions
export def Statusline(): string
    const current_winid = get(g:, 'statusline_winid', get(g:, 'actual_curwin', '-1')->str2nr())
    if current_winid == win_getid(winnr())
        return $'{Indicators()}%<%f{ZoomState()}%w%m%r %= {BufferIndicators()}%y'
    else
        return '%<%f%m%r'
    endif
enddef
