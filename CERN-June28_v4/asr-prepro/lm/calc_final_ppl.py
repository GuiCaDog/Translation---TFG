#!/usr/bin/pypy

#/usr/bin/python
# Adria A. Martinez Villaronga, 2012

from math import *
import sys

def is_numeric(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

if (len(sys.argv) < 2):
    print error
    exit(0)
if (len(sys.argv) > 2):
    filename=sys.argv[2]
else:
    filename="kk:"

nSent = int(int(sys.argv[1])/2)

tlp = 0
tppl = 0
tppl1 = 0
N = 0
zp = 0
OOVs = 0
for i in range(nSent):
    w = int(sys.stdin.readline())
    zerop = int(sys.stdin.readline())
    zp = zp+zerop

    oov = int(sys.stdin.readline())
    OOVs = OOVs + oov

    
    logp = float(sys.stdin.readline())
    tlp = tlp + logp
    

    ppls = (sys.stdin.readline())
    if is_numeric(ppls):
        ppl = float(ppls)
        aux = (w+1-(oov+zerop))*log(ppl)/log(2)
        tppl= tppl + aux


    ppl1s = (sys.stdin.readline())
    if is_numeric(ppl1s):
        ppl1 = float(ppl1s)
        aux = (w-2*(oov+zerop))*log(ppl1)/log(2)
        tppl1 = tppl1 + aux

    
    N = N + w
tppl = tppl / (N+nSent-(OOVs+zp));
tppl = 2**(tppl)
tppl1 = tppl1 / (N-(OOVs+zp));
tppl1 = 2**(tppl1)
print "file", filename, nSent, "sentences,", N, "words,", OOVs, "OOVs"
print zp, "zeroprobs, logprob=", tlp, "ppl=", tppl, "ppl1=", tppl1
