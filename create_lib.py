import numpy as np 
import scipy.io as sio

sig1 = sio.loadmat('batch1.mat')
sig2 = sio.loadmat('batch2.mat')
sig3 = sio.loadmat('batch3.mat')
sig4 = sio.loadmat('batch4.mat')

data1 = sig1['sig'][0,0]
data2 = sig2['sig'][0,0]
data3 = sig3['sig'][0,0]
data4 = sig4['sig'][0,0]

ref_lib = {}
for name in data1.dtype.names:
    ref_lib.update({name:data1[name]})
for name in data2.dtype.names:
    ref_lib.update({name:data2[name]})
for name in data3.dtype.names:
    ref_lib.update({name:data3[name]})
for name in data4.dtype.names:
    ref_lib.update({name:data4[name]})

print ref_lib


