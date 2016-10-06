function! Incr()
  let l:a = line('.') - line("'<")
  let l:c = virtcol("'<")
  if a > 0
    execute 'normal! '.l:c.'|'.l:a."\<C-a>"
  endif
  normal `<
endfunction
vnoremap <C-b> :call Incr()<CR>

"function! Class()
"
"    let l:file_name = expand("%:t:r")
"    let l:file_extension = expand("%:e")
"    echo l:file_name
"    echo l:file_extension
"    if l:file_extension is 'c'
"        let l:header_file = l:file_name . '.h'
"        if exists(l:header_file)
"            " echo a
"            " let a=system( 'grep ");" ' . l:header_file)
"            " let a = substitute(l:a,";","{\n}","g")
"            
"            " echo a
"
"            echo l:header_file
"        endif
"    elseif l:file_extension is 'h'
"        
"        let l:current_file=@%
"        let l:source_file =   l:file_name . '.c'
"        
"        let l:bu = bufnr(l:source_file)
"        echo "Buffer ".l:source_file." is ".l:bu
"        "remove buffer
"        if l:bu > 0
"            echo "remove buffer ".l:bu
"            execute 'bdelete ' . l:source_file
"        endif
"
"         "let l:bu = bufnr(l:source_file)
"        
"        " create file if not exist
"         if ! exists(l:source_file)
"             echo "Create file".l:source_file
"             echo system('ls')
"             execute 'edit ' . l:source_file
"             " swap buffer
"             execute 'buffer ' . l:current_file
"             ls
"         else
"             echo "file ".l:source_file." already exist"
"             ls
"         endif
"        
"        let  l:func_names = system( 'grep ");" ' . @%)
"        let  l:func_names = substitute(l:func_names,";","{\n}","g")
"        "echo l:func_names
"        "
"         "redir > @" | echo l:func_names | redir END
"         let @s="#include \"" . l:current_file ."\"\n\n"
"         let @s .=l:func_names
"
"         execute 'edit ' . l:source_file
"         " insert register s at end of file
"         $put s
"         " swap buffer
"         execute 'buffer ' . l:current_file
"         
"        " execute 'read!' l:source_file
"
"    else
"        echo "file extension not .c or .h"
"    endif
"endfunction
"function! _for()
"let @f="for(;;) {
"            \\n
"            \}"
"
"endfunction


function! PyUtility()
python << PYEND
# -*- coding: utf-8 -*-
import vim
import sys
import time
class CUtility(object):
    @classmethod
    def for_loop(cls):
        text=\
"""for(;;) {

}
"""
        return text
    @classmethod
    def while_loop(cls):
        text=\
"""while() {

}
"""
        return text

    @classmethod
    def switch_case(cls):
        text=\
"""switch () {
    case :

    break;
    default:
    
    break;
}
"""
        return text

class CFunction(object):
    @classmethod
    def mainFunction(cls):
        text=\
"""#include <stdio.h>
#include<stdlib.h>
int main(void) {

    return 0;
}
"""
        return text
class CInsert(object):
    def __init__(self):
        self.w = vim.current.window
        self.b = vim.current.buffer
        self.l = vim.current.line
    def run(self):
             print "hello\nhello2\n\nhello3" 
             cc=CUtility.for_loop()
             l=len(cc.switch_case().split('\n'))
             t = cc.switch_case().split('\n')
             r,c = self.w.cursor
             self.b[r:l-1]=t
PYEND
endfunction

function! ExeC()
    :call PyUtility()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @function: BeforeRotate
" @description: Create backup of current registers from a to z in a
" dictionary
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! BeforeRotate()
    call PyUtility()
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
" @description: Change register content and start rotation
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Rotate(language)
    call BeforeRotate()
    let g:reg_rotate_flag = 1

    "echo g:reg_backup
    if a:language ==? "c"
        call CRotate()
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
    for [l:k, l:v] in items(g:reg_backup)
        if empty(l:v)
            call setreg(l:k, '')
        else
            if (g:c_rotate_flag == 0)
                redir => l:tmp
                    silent! py print CUtility.for_loop()
                redir END
                call setreg(l:k, l:tmp)
            elseif(g:c_rotate_flag == 1) 
                redir => l:tmp
                    silent! py print CFunction.mainFunction()
                redir END
                call setreg(l:k, l:tmp)
            elseif(g:c_rotate_flag == 2)
                call setreg(l:k, l:v)
            endif
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
" @function: TestRotate
" @description: test for Rotate
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! TestRotate()
     unlet g:reg_backup
     unlet g:reg_rotate_flag
     call Rotate()
endfunction
"
" Seting the cmdwin height
function! Set_cmdheight() 
    let l:a =&cmdheight
    execute 'echo'.l:a
    if l:a == 1
        set cmdheight=5
    else 
        set cmdheight=1
    endif
endfunction
au CmdwinEnter : set cmdheight=5
" S-k = help for cursor key word
let &keywordprg=':help'
let mapleader = ","
" edit ~/.vimrc in a split

nnoremap  <leader>v   :vs ~/.vimrc<CR>
nnoremap  <leader>s   :so ~/.vimrc<CR> :echo "source vimrc"<CR>
nnoremap  <leader>sch :call Set_cmdheight()<CR>
nnoremap  <leader>e   :call ExeC()<CR> 
nnoremap  <leader>x   :call Rotate('c')<Enter>
