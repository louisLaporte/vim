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

nnoremap  <leader>r   :call Rotate('c')<Enter>
