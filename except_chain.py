# The model is this:
#
#    There's a C function (c_call) that takes a callback (a function
#    pointer of predetermined signature) as an argument.  This
#    signature includes returning an integer to indicate success (0)
#    or failure (non-zero).
#
#    We want to be able to use a Python function as the callback for
#    c_call.
#
#    The idea is to pass a C wrapper function to c_call; this wrapper
#    extracts the Python function from an opaque memory area (C void*).
#
#    The C wrapper will also save exception info, and a Python wrapper
#    to c_call will check for and re-raise the exception.

import sys

# notional C library function
def c_call(f, a, b, user_data):
    return f(a, b, user_data)

# notional Cython function wrapping Python callback
def callback_wrapper(a, b, user_data):
    try:
        # 1-element list models a C pointer
        b[0]=user_data.func(a)
        return 0
    except:
        user_data.exc = sys.exc_info()
        return 1

# 'data structure' for user_data
class call_data(object):
    def __init__(self,func):
        self.func = func
        self.exc = None

# Python interface to caller
def py_call(f,a,b):
    cd=call_data(f)
    if c_call(callback_wrapper, a, b, cd):
        raise cd.exc[0],cd.exc[1],cd.exc[2]

def foo(a):
    if 23==a:
        raise RuntimeError('not 23!')
    return a+101

if __name__=='__main__':
    b=[None]
    py_call(foo,100,b)
    print 'foo(100):',b[0]
    # c_call is "missing" from the traceback generated here:
    py_call(foo,23,b)
    print 'foo(23):',b[0]
