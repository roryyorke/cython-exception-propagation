#include "callfunc.h" /* see this file for info */

int c_call(c_callback f, int in, int *out, void *user_data)
{
  return f(in, out, user_data);
}
