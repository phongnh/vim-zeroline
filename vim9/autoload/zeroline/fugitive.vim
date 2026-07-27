vim9script

const names = {'staged': 'Staged', 'unstaged': 'Unstaged', 'untracked': 'Untracked'}

export def Status(): string
    if exists('b:fugitive_status')
        return ['staged', 'unstaged', 'untracked']
            ->filter((_, key) => len(b:fugitive_status[key]) > 0)
            ->map((_, key) => $'{names[key]}: {len(b:fugitive_status[key])}')
            ->join(' | ')
    endif
    return ''
enddef
