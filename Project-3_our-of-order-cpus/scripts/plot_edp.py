#!/usr/bin/env python

import sys, os
import itertools, operator
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

def get_params_from_basename(basename):
	tokens = basename.split('.')
	bench = tokens[0].split('/')[0]
	input_size = 'ref'
	dw = int(tokens[1].split('-')[0].split('_')[1])
	ws = int(tokens[1].split('-')[1].split('_')[1])
	return (bench, input_size, dw, ws)

def get_joule_from_joule_file(output_file):
	print("get joule,file = %s"%(output_file))
	joule = -999
	fp = open(output_file, "r")
	line = fp.readline()
	while line:
		# print("line")
		if "total" in line:
			joule = float(line.split()[3])

	fp.close()
	return joule

def get_time_from_sim_out_file(output_file):
	print("get time")
	time = -999
	fp = open(output_file, "r")
	line = fp.readline()
	while line:
		if "Time" in line:
			time = float(line.split()[3])/(10000000000)

	fp.close()
	return time	


def tuples_by_dispatch_width(tuples):
	ret = []
	tuples_sorted = sorted(tuples, key=operator.itemgetter(0))
	for key,group in itertools.groupby(tuples_sorted,operator.itemgetter(0)):
		ret.append((key, zip(*map(lambda x: x[1:], list(group)))))
	# print(ret)
	return ret

global_ws = [16,32,64,96,128,192,256,384]

if len(sys.argv) < 2:
	print "usage:", sys.argv[0], "<output_directories>"
	sys.exit(1)

results_tuples = []

for dirname in sys.argv[1:]:
	if dirname.endswith("/"):
		dirname = dirname[0:-1]
	basename = os.path.basename(dirname)
	joule_file = dirname + "/power.total.out"
	sim_file = dirname +"/sim.out"

	(bench, input_size, dispatch_width, window_size) = get_params_from_basename(basename)
	print("dsf")
	# uncomment the following line if u wish to throw away some non-necessary benchmarks
	# if(dispatch_width > window_size): continue  
	joule = get_joule_from_joule_file(joule_file)
	time  = get_time_from_sim_out_file(sim_file)
	edp = time * joule
	results_tuples.append((dispatch_width, window_size, edp))
	


markers = ['.', 'o', 'v', '*', 'D']
fig = plt.figure()
plt.grid(True)
ax = plt.subplot(111)
ax.set_xlabel("$Window Size$")
ax.set_ylabel("$EDP$")

i = 0
tuples_by_dw = tuples_by_dispatch_width(results_tuples)
for tuple in tuples_by_dw:
	##############  TESTING  #######################
	# print("tuple[0] = %s"%(tuple[0]))
	# print("tuple[1][0] =%s"%(tuple[1][0]))
	################################################
	dw = tuple[0]
	ws_axis = tuple[1][0]
	edp_axis = tuple[1][1]
	x_ticks = np.arange(0, len(global_ws))
	x_labels = map(str, global_ws)
	ax.xaxis.set_ticks(x_ticks)
	ax.xaxis.set_ticklabels(x_labels)

	print x_ticks
	print edp_axis
	ax.plot(x_ticks, edp_axis, label="DW_"+str(dw), marker=markers[i%len(markers)])
	i = i + 1

ax.set_title(bench)
lgd = ax.legend(ncol=len(tuples_by_dw), bbox_to_anchor=(0.9, -0.1), prop={'size':8})
plt.savefig(bench+'-'+input_size+'.power.png', bbox_extra_artists=(lgd,), bbox_inches='tight')
