vim9script

export def Status(): string
    if exists('g:_fugitive_last_job') && (g:_fugitive_last_job.file ==# expand('%:p') || get(g:_fugitive_last_job, 'capture_bufnr', -1) ==# bufnr('%'))
        const cmd = join(extendnew(g:_fugitive_last_job.git, g:_fugitive_last_job.args), ' ')
        return cmd
    endif
    return expand('%:t')
enddef
