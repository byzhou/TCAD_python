import numpy as np 
import scipy.io as sio
import matplotlib.pyplot as plt

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

xstep           = 0.1 
ystep           = 0.1 
epsilon         = 0.00001 

M               = 50
NA              = 0.6

# get bounds
xmin            = float(min([coord[2] for coord in coords]))
xmax            = float(max([coord[4] for coord in coords]))
ymin            = float(min([coord[5] for coord in coords]))
ymax            = float(max([coord[3] for coord in coords]))

# setup meshes
xlist           = list(np.arange(xmin,xmax,xstep))
ylist           = list(np.arange(ymin,ymax,ystep))
X, Y            = np.meshgrid(xlist, ylist)

# for each gate, set mesh values to the reflectance
RMAP            = min_val*np.ones(X.shape)
for cells in coords:
    x_min_cell  = float(min([cells[2], cells[4]]))
    x_max_cell  = float(max([cells[2], cells[4]]))
    y_min_cell  = float(min([cells[3], cells[5]]))
    y_max_cell  = float(max([cells[3], cells[5]]))
    if len(cells[6]) == 1:
        for x_coord_index, x_coord in enumerate(xlist):
            if x_coord >= x_min_cell and x_coord <= x_max_cell:
                for y_coord_index, y_coord in enumerate(ylist):
                    if y_coord >= y_min_cell and y_coord <= y_max_cell:
                        RMAP[y_coord_index][x_coord_index] = cells[6]
    else:
        total_cell_length   = x_max_cell - x_min_cell
        each_piece_of_cell  = total_cell_length / len(cells[6])
        for color_index, colors in enumerate(cells[6]):
            for x_coord_index, x_coord in enumerate(xlist):
                if (x_coord >= x_min_cell + each_piece_of_cell * color_index) and\
                    (x_coord <= x_min_cell + each_piece_of_cell * (color_index + 1)):
                    for y_coord_index, y_coord in enumerate(ylist):
                        if y_coord >= y_min_cell and y_coord <= y_max_cell:
                            RMAP[y_coord_index][x_coord_index] = colors 

plt.pcolor(X,Y,RMAP)
plt.show()
