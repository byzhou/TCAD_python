import math
from scipy.interpolate import Rbf  
import numpy as np 
import scipy.io as sio
import scipy.special as ssp
import matplotlib.pyplot as plt
import scipy.signal as ssi

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

#all the lib results have been combined

extracted_file  = "x1020y1020.txt"

# Read file
r               = 0
x               = 0

read_file       = open ('txt/'+extracted_file,'r')
coords          = []
types           = {}
for lines in read_file:
    coord_Array = lines.split('\t')
    coords.append([coord_Array[1],
                    coord_Array[0], 
                    coord_Array[2], 
                    coord_Array[3], 
                    coord_Array[6], 
                    coord_Array[7]])
    types.update({coord_Array[0]:0})
# put all the information into the coords
for cell_info in coords:
    cell_info.append(ref_lib[cell_info[1]][0])
# types is to determine the number of types
read_file.close()

# some initial data in Script_Imaging
lam_val         = 1.0
pol             = 2

mis             = 0
min_val         = ((3.5 - 1.45)/(3.5 + 1.45))**2

xstep           = 0.2 
ystep           = 0.25 
epsilon         = 0.00001 

M               = 50
NA              = 0.6

pi              = 3.14

# get bounds
xmin            = float(min(min([[coord[2] for coord in coords], [coord[4] for coord in coords]])))
xmax            = float(max(max([[coord[2] for coord in coords], [coord[4] for coord in coords]])))
ymin            = float(min(min([[coord[3] for coord in coords], [coord[5] for coord in coords]])))
ymax            = float(max(max([[coord[3] for coord in coords], [coord[5] for coord in coords]])))

# get sampling points
x_sampled       = []
y_sampled       = []
ref_sampled     = []
for cells in coords:
    # if the gate has only one sampling points
    if len(cells[6]) == 1:
        x_sampled.append((float(coord[2])+float(coord[4]))/2)
        y_sampled.append((float(coord[3])+float(coord[5]))/2)
        ref_sampled.append(float(coord[6]))
    else:
        num_of_sampling = len(cells[6])
        x_min_cell  = float(min([cells[2], cells[4]]))
        x_max_cell  = float(max([cells[2], cells[4]]))
        y_min_cell  = float(min([cells[3], cells[5]]))
        y_max_cell  = float(max([cells[3], cells[5]]))
        x_first_sampled_point   = (x_min_cell + x_max_cell) / 2 - 0.915 * (num_of_sampling - 1) / 2
        y_first_sampled_point   = (y_min_cell + y_max_cell) / 2 
        
        for color_index, colors in enumerate(cells[6]):
            x_sampled.append(x_first_sampled_point + 0.915 * color_index)
            y_sampled.append(y_first_sampled_point)
            ref_sampled.append(float(colors))

# setup meshes
x_interpolate           = np.arange(xmin,xmax,xstep)
y_interpolate           = np.arange(ymin,ymax,ystep)
X, Y                    = np.meshgrid(x_interpolate, y_interpolate)
print [len(x_sampled), len(y_sampled), len(ref_sampled)]

ref_interpolate_func    = Rbf(x_sampled, y_sampled, ref_sampled, method='inverse')
ref_interpolate         = ref_interpolate_func(X, Y)

# plot
plt.pcolor(X, Y, ref_interpolate)
plt.colorbar()
plt.show()


