#!/bin/bash
export REPLACE_ITER_DIR="$( cd "$( dirname "$BASH_SOURCE" )" && pwd )"

ROOT_DIR="$REPLACE_ITER_DIR"
directories=`grep -E '^[^#].*' "$REPLACE_ITER_DIR/directory.list"`
for bench_group in $directories
do
	cd "$ROOT_DIR/$bench_group"
	benchmarks=`ls -d */`
	for bench_dir in $benchmarks
	do
		cd $bench_dir
		cuda_file=`ls | grep -E '.cu$'`	
		echo $cuda_file
    cp -f $cuda_file $cuda_file".backup"
		cd ..
	done
done
