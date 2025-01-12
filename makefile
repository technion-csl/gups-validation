# The commands in a recipe are passed to a single invocation of the Bash shell.
SHELL := /bin/bash
# run all lines of a recipe in a single invocation of the shell rather than each line being invoked separately
.ONESHELL:
# invoke recipes as if the shell had been passed the -e flag: the first failing command in a recipe will cause the recipe to fail immediately
.POSIX:

##### constants #####
repeats := 30
memory_node := 0
cpu_core := $(shell cat /sys/devices/system/node/node$(memory_node)/cpulist | cut -d"," -f2)
run := taskset -c $(cpu_core) numactl -m $(memory_node)

##### targets #####
our_results := gups/results.txt
ref_results := hpcc/results.txt
all_results := results.txt
submodule_makefiles := gups/makefile hpcc/makefile

##### recipes #####
.PHONY: all clean

all: $(all_results)
	compare.py < $(all_results)

$(all_results): $(our_results) $(ref_results)
	paste -d ',' $^ > $@

$(our_results): $(submodule_makefiles)
	cd gups
	make
	(for i in $$(seq 1 $(repeats)); do $(run) ./gups --log2_length 27 ; done) > out.txt
	grep GUPS out.txt | cut -d"=" -f2 | tr -d " " > $(notdir $@)

$(ref_results): $(submodule_makefiles)
	cd hpcc
	make single_random_access
	for i in $$(seq 1 $(repeats)); do $(run) ./single_random_access ; done
	grep "Single GUP/s" hpccoutf.txt | cut -d" " -f3 > $(notdir $@)

$(submodule_makefiles):
	git submodule update --init --progress

clean:
	rm -f $(our_results) $(ref_results) $(all_results)
	cd gups && make clean && cd ..
	cd hpcc && make clean

