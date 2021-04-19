#!/usr/bin/env python

#----------------------------------------------#
#       USAGE: run the following command       #
#  python ipc_per_gs.py D*/*.THR_*-GS_001.out  #
#----------------------------------------------#
import sys, os
import itertools, operator
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
# plt.style.use('classic')



def get_params_from_basename(basename):
	tokens = basename.split('.')
	bench = tokens[0].split('/')[0]
	input_size = 'ref'
	thr = int(tokens[1].split('-')[0].split('_')[1])
	gs = int(tokens[1].split('-')[1].split('_')[1])
	return (bench, input_size, thr, gs)

def get_ipc_from_output_file(output_file):
	ipc = float("NaN")
	try:
		fp = open(output_file, "r")
	except IOError:
		return ipc
	line = fp.readline()
	while line:
		if "total" in line:
			ipc = float(line.split()[3])
			if str(line.split()[4]) == 'kJ':
				ipc*=1000
		line = fp.readline()

	fp.close()
	return ipc

def tuples_by_thr(tuples):
	ret = []
	tuples_sorted = sorted(tuples, key=operator.itemgetter(0))
	for key,group in itertools.groupby(tuples_sorted,operator.itemgetter(0)):
		ret.append((key, zip(*map(lambda x: x[1:], list(group)))))
	print(ret)
	return ret

global_ws = [1,2,4,8,16]

if len(sys.argv) < 2:
	print "usage:", sys.argv[0], "<output_directories>"
	sys.exit(1)

results_tuples = []

for dirname in sys.argv[1:]:
	if dirname.endswith("/"):
		dirname = dirname[0:-1]
	basename = os.path.basename(dirname)
	output_file = dirname + "/power.total.out"

	(bench, input_size, thr, gs) = get_params_from_basename(basename)


	ipc = get_ipc_from_output_file(output_file)
	results_tuples.append((bench, thr, ipc))


markers = ['.', 'o', 'v', '*', 'D']
fig = plt.figure()
plt.grid(True)
ax = plt.subplot(111)
ax.set_xlabel("$Threads$")
ax.set_ylabel("$Energy (Joule)$")

i = 0
locks_names = []
tuples_by_dw = tuples_by_thr(results_tuples)
for tuple in tuples_by_dw:
	##############  TESTING  #######################
	# print(tuple[0])
	# print("tuple[1][0] =%s"%(tuple[1][0]))
	################################################
	dw = tuple[0]
	locks_names.append(dw)
	ws_axis = tuple[1][0]
	ipc_axis = tuple[1][1]
	x_ticks = np.arange(0, len(global_ws))
	x_labels = map(str, global_ws)
	ax.xaxis.set_ticks(x_ticks)
	ax.yaxis.major.formatter._useMathText = True
	ax.xaxis.set_ticklabels(x_labels)

	print x_ticks
	print ipc_axis
	ax.plot(x_ticks, ipc_axis, label=str(bench), marker=markers[i%len(markers)])
	i = i + 1
# print("tuple=")
# print(tuple)
ax.set_title("Grain Size = "+str(gs))
lgd = ax.legend(locks_names,ncol=len(tuples_by_dw), bbox_to_anchor=(0.94, -0.12), prop={'size':8})
plt.savefig("power_GS="+str(gs)+'.png', bbox_extra_artists=(lgd,), bbox_inches='tight')
