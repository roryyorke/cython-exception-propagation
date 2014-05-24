# -*-python-*-
# See Makefile, which will compile and test this

# for exc_info()
import sys

# the C library
cimport c_callfunc

cdef class calldata:
    cdef:
        object f    # Python callback function
        object exc  # Exception info

# C wrapper for Python callback
# Does exception handling
cdef int callback_wrapper(int a, int *b, void *user_data):
    cdef calldata cd
    cd= <object>user_data
    f= <object>cd.f
    try:
        b[0]=f(a)
        return 0
    except:
        cd.exc=sys.exc_info()
        return 1

# Python wrapper around c_callfunc.call
# Checks for error return, extracts exception and rethrows it
def py_call(f,a):
    cdef int b
    cdef calldata cd
    cd=calldata()
    cd.f=f
    if 0 == c_callfunc.c_call(callback_wrapper, a, &b, <void*>cd):
        return b
    else:
        raise cd.exc[0],cd.exc[1],cd.exc[2]
