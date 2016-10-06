""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @function: BeforeRotate
" @description: Create backup of current registers from a to z in a
" dictionary
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! BeforeRotate()
    pyfile reg_rotate.py
    if ! exists("g:reg_rotate_flag")
        let g:reg_rotate_flag = 0
    endif

    if g:reg_rotate_flag == 0
        let g:reg_backup = {}
        let l:char_a = 97
        let l:char_z = 122
        for c in range(l:char_a, l:char_z)
            let l:reg_name = nr2char(c)
            let g:reg_backup[l:reg_name] = getreg(l:reg_name)
        endfor
    endif

endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @function: Rotate
" @param:
"       - language = language name
" @description: Change register content and start rotation
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Rotate(language)
    call BeforeRotate()
    let g:reg_rotate_flag = 1

    if a:language ==? "c"
        call CRotate()
    " elseif a:language ==? "py"
    "     call PyRotate()
    endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @function: Rotate
" @description: Rotation for the C language
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CRotate()
    if ! exists("g:c_rotate_flag")
        let g:c_rotate_flag = 0
    endif

  echo "reg rotate ".g:c_rotate_flag
  let l:counter = -1
    for [l:k, l:v] in items(g:reg_backup)
        let counter +=1
        if (g:c_rotate_flag == 0)
            " TODO: - Change that part its ugly
            "       - Remove get_method from list
            let l:meth = Str2List(ExecCmd("py print CUtility.get_method()"))
            if l:counter < len(l:meth) && l:meth[l:counter] != "get_method"
                let l:cmd = "py print getattr(CUtility,".l:meth[l:counter] .")()"
                let l:tmp  = ExecCmd(l:cmd)
            else
                let l:tmp = ''
            endif
            call setreg(l:k, l:tmp)
        elseif(g:c_rotate_flag == 1)
            let l:meth = Str2List(ExecCmd("py print CFunction.get_method()"))
            if l:counter < len(l:meth) && l:meth[l:counter] != "get_method"
                let l:cmd = "py print getattr(CFunction,".l:meth[l:counter] .")()"
                let l:tmp  = ExecCmd(l:cmd)
            else
                let l:tmp = ''
            endif
            call setreg(l:k, l:tmp)
        elseif(g:c_rotate_flag == 2)
            call setreg(l:k, l:v)
        endif
     endfor
    " next rotation
    if g:c_rotate_flag == 2
        let g:c_rotate_flag = 0
    else
        let g:c_rotate_flag += 1
    endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @function: Str2List
" @param:
"       - str = string to convert
" @description: convert a string to a list
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Str2List(str)
    let l:list = substitute(a:str, '\[\(.*\)\]', '\1', '')
    let l:list = split(l:list, ',')
    return l:list
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @function: TestRotate
" @description: test for Rotate
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! TestRotate()
     unlet g:reg_backup
     unlet g:reg_rotate_flag
     call Rotate()
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @function: ExecCmd
" @param: 
"       - cmd = command to output
" @description: return a command output
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ExecCmd(cmd)
    redir => message
        silent execute a:cmd
    redir END
    if empty(message)
        echoerr "no output"
        return -1
    else
    " use "new" instead of "tabnew" below if you prefer split windows 
    " instead of tabs tabnew
        return message
    endif
endfunction
command! -nargs=+ -complete=command ExecCmd call ExecCmd(<q-args>)

nnoremap  <leader>r   :call Rotate('c')<Enter>
