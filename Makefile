# Builds the C library, the Cython interface to it, and runs a simple
# Python test

CFLAGS=-Wall -Wextra

.PHONY: test all
test: all

all: libcallfunc.so pycallfunc.so

libcallfunc.so: callfunc.o callfunc.h
	ld -shared -o libcallfunc.so callfunc.o

pycallfunc.so: pycallfunc.pyx c_callfunc.pxd
	python setup.py build_ext --inplace

test:
	python test_callfunc.py
