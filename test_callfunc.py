# See rather Makefile, which will run this
# Test Cython exception catching and reinjection
import traceback
import sys
import pycallfunc

def f(a):
    return 2*a

def g(a):
    if a==23:
        raise RuntimeError("Not 23!")
    else:
        return 101+a

assert 200==pycallfunc.py_call(f,100)
assert 201==pycallfunc.py_call(g,100)

try:
    print pycallfunc.py_call(g,23)
except RuntimeError as e:
    import __main__
    exc=sys.exc_info()
    filename,lineno,funcname,_ = traceback.extract_tb(exc[2])[-1]
    assert filename==__main__.__file__
    assert 12==lineno
    assert 'g'==funcname
    print 'Traceback ok'
