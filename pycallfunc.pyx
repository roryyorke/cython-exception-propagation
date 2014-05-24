# See Makefile, which will compile and test this
# -*-python-*-

# to keep exception info alive
from cpython cimport Py_INCREF, Py_DECREF

# for exc_info()
import sys

# the C library
cimport c_callfunc

cdef struct calldata:
    void* f    # Python callback function
    void* exc  # Exception info

# C wrapper for Python callback
# Does exception handling
cdef int callback_wrapper(int a, int *b, void *user_data):
    cdef calldata * cd
    cd= <calldata*>user_data
    f= <object>cd.f
    try:
        b[0]=f(a)
        return 0
    except:
        exc=sys.exc_info()
        Py_INCREF(exc)
        # into the void* wormhole
        cd.exc=<void*>exc
        return 1

# Python wrapper around c_callfunc.call
# Checks for error return, extracts exception and rethrows it
def py_call(f,a):
    cdef int b
    cdef calldata cd
    cd.f=<void*>f
    if 0 == c_callfunc.c_call(callback_wrapper, a, &b, <void*>&cd):
        return b
    else:
        exc=<object>cd.exc
        Py_DECREF(exc)
        raise exc[0],exc[1],exc[2]
