#!/usr/bin/env python2
import sys
fname=sys.argv[1]
f=open(fname+'.ped')
fout=open(fname+'2.ped','w')
for l in f:
        split=l.split(' ')
        split[5]=split[0]
        fout.write(' '.join(split))
f.close()
fout.close()
