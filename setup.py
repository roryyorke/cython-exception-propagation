# see rather Makefile
# minimal code to get Cython code compiled
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
    cmdclass = {'build_ext': build_ext},
    ext_modules = [Extension("pycallfunc", ["pycallfunc.pyx"],
                             libraries=['callfunc'],library_dirs=['.'],runtime_library_dirs=['.'])]
)
