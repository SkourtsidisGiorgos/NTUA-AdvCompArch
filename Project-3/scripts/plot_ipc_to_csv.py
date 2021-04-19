#!/usr/bin/env python


#       STILL IN TESTING MODE - THE CSV RESULT IS NOT IN PERFECT FORM.
#		THIS SCRIPT WILL NEVER BE COMPLETED					
import sys, os
import itertools, operator
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import csv

def get_params_from_basename(basename):
	tokens = basename.split('.')
	bench = tokens[0].split('/')[0]
	input_size = 'ref'
	dw = int(tokens[1].split('-')[0].split('_')[1])
	ws = int(tokens[1].split('-')[1].split('_')[1])
	return (bench, input_size, dw, ws)

def get_ipc_from_output_file(output_file):
	ipc = -999
	fp = open(output_file, "r")
	line = fp.readline()
	while line:
		if "IPC" in line:
			ipc = float(line.split()[2])
		line = fp.readline()

	fp.close()
	return ipc

global_ws = [1,2,4,8,16,32,64,96,128,192,256,384]

if len(sys.argv) < 2:
	print "usage:", sys.argv[0], "<output_directories>"
	sys.exit(1)

results_tuples = []

for dirname in sys.argv[1:]:
	if dirname.endswith("/"):
		dirname = dirname[0:-1]
	basename = os.path.basename(dirname)
	output_file = dirname + "/sim.out"

	(bench, input_size, dispatch_width, window_size) = get_params_from_basename(basename)
	if(dispatch_width > window_size): continue
	ipc = get_ipc_from_output_file(output_file)
	results_tuples.append((dispatch_width, window_size, ipc))


print results_tuples

with open('csv/hmmer.csv','wb') as out:
    csv_out=csv.writer(out)
    csv_out.writerow(['DW','WS','IPC'])
    for row in results_tuples:
        csv_out.writerow(row)