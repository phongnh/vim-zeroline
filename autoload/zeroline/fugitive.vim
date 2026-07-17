let s:NAMES = { 'staged': 'Staged', 'unstaged': 'Unstaged', 'untracked': 'Untracked' }

function! zeroline#fugitive#Status() abort
    if exists('b:fugitive_status')
        return ['staged', 'unstaged', 'untracked']
                    \ ->filter('len(b:fugitive_status[v:val]) > 0')
                    \ ->map('s:NAMES[v:val] .. ": " .. len(b:fugitive_status[v:val])')
                    \ ->join(' | ')
    endif
    return ''
endfunction

function! zeroline#fugitive#FugitiveChanged() abort
    if !exists('g:_fugitive_last_job')
        return
    endif

    let l:bufnr = get(g:_fugitive_last_job, 'capture_bufnr', -1)
    if l:bufnr > 0
        let l:cmd = join(extendnew(g:_fugitive_last_job.git, g:_fugitive_last_job.args), ' ')
        call setbufvar(l:bufnr, 'fugitive_git_command', l:cmd)
    endif
endfunction
