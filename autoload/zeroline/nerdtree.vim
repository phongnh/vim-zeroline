function! zeroline#nerdtree#Status() abort
    let l:mode = 'NERDTree'

    if exists(b:NERDTree)
        let l:folder = fnamemodify(b:NERDTree.root.path.str(), ':p:~:.')
        let l:folder = empty(l:folder) ? '.' : l:folder
        return '[' .. l:mode .. ']' .. ' ' .. l:folder
    endif

    return '[' .. l:mode .. ']'
endfunction
