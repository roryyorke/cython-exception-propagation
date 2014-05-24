# -*-python-*-
# Cython-compatible declarations of C types/functions
cdef extern from "callfunc.h":
    ctypedef int (*c_callback)(int input, int *output, void *user_data)
    int c_call(c_callback f, int input, int *output, void *user_data)
