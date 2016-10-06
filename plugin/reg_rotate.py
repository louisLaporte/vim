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

    @classmethod
    def get_method(cls):
        meth = [x for x in dir(cls) if not x.startswith('__')]
        return meth 
        

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
    @classmethod
    def get_method(cls):
        meth = [x for x in dir(cls) if not x.startswith('__')]
        return meth 
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
