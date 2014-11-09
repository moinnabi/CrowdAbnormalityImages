#!/bin/sh
export LIB_GCC=/usr/local/lib/gcc/x86_64-apple-darwin13.0.0/4.7.3/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/gcc/x86_64-apple-darwin13.0.0/4.7.3/:/
export LD_PRELOAD=$LIB_GCC/libgfortran.so:$LIB_GCC/libgcc_s.so:$LIB_GCC/libstdc++.so:$LIB_GCC/libgomp.so
matlab $* -r "addpath('./build/'); addpath('./test_release'); setenv('MKL_NUM_THREADS','1'); setenv('MKL_SERIAL','YES');"
