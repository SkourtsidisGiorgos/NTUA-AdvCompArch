#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

fp = open(sys.argv[1])
line = fp.readline()
while line:
	tokens = line.split()
	if line.startswith("  Total-Branches:"):
		total_bra = float(tokens[1])
       	elif line.startswith("  Conditional-Taken-Branches:"):
		total_taken = float(tokens[1])
	elif line.startswith("  Conditional-NotTaken-Branches:"):
		total_notTaken = float(tokens[1])	
	elif line.startswith("  Unconditional-Branches:"):
		total_unco = float(tokens[1])
       	elif line.startswith("  Calls:"):
		total_calls = long(tokens[1])
	elif line.startswith("  Returns:"):
		total_returns = float(tokens[1])
	line = fp.readline()
x=[1]
y=[100]
xt=[2]
yt=[100*total_taken/total_bra]
xn=[3]
yn=[100*total_notTaken/total_bra]
xu=[4]
yu=[100*total_unco/total_bra]
xc=[5]
yc=[100*total_calls/total_bra]
xr=[6]
yr=[100*total_returns/total_bra]

onoma=sys.argv[1].split(".")
rects1=plt.bar(x,y,label='Total-Branches=%d' % total_bra, color='k')
rects2=plt.bar(xt,yt,label='Taken-Branches',color='b')
rects3=plt.bar(xn,yn,label='NotTaken-Branches', color='m')
rects4=plt.bar(xu,yu,label='Unconditional-Branches', color='r')
rects5=plt.bar(xc,yc,label='Calls',color='c')
rects6=plt.bar(xr,yr,label='Returns', color='y')

plt.xlabel('x')
plt.ylabel('Percentage (%)')
plt.title(onoma[0]+': Taken-NotTaken-Unconditional-Calls-Returns')
plt.legend()


def autolabel(rects):
    # attach some text labels
    for rect in rects:
        height = rect.get_height()
        plt.text(rect.get_x() + rect.get_width()/2., 1.05*height,
                "%0.2f %%" % height,
                ha='center', va='bottom')
#autolabel(rects1)
autolabel(rects2)
autolabel(rects3)
autolabel(rects4)
autolabel(rects5)
autolabel(rects6)

name=sys.argv[1]
plt.savefig("L2"+name+".png",bbox_inches="tight")
