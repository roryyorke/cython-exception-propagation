#ifndef CALLFUNC_H
#define CALLFUNC_H

/* function signature
   pointed-to function must operate on "in" to produce "out", and
   should return 0 on success, non-zero on error */

typedef int (*c_callback)(int in, int *out, void *user_data);

/* calls f with given arguments.  Returns 0 on success, non-zero on error */
int c_call(c_callback f, int in, int *out, void *user_data);

#endif
