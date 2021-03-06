import numpy as np  
from scipy.interpolate import Rbf  
  
import matplotlib.pyplot as plt  
  
#Creating some data, with each coordinate and the values stored in separated lists  
x = [10,60,40,70,10,50,20,70,30,60]  
y = [10,20,30,30,40,50,60,70,80,90]  
values = [1,2,2,3,4,6,7,7,8,10]  
  
#Creating the output grid (100x100, in the example)  
ti = np.linspace(0, 100.0, 100)  
XI, YI = np.meshgrid(ti, ti)  
  
#Creating the interpolation function and populating the output matrix value  
rbf = Rbf(x, y, values, function='inverse')  
ZI = rbf(XI, YI)  
  
# Plotting the result  
n = plt.normalize(0.0, 100.0)  
plt.subplot(1, 1, 1)  
plt.pcolor(XI, YI, ZI)  
plt.scatter(x, y, 100, values)  
plt.title('RBF interpolation')  
plt.xlim(0, 100)  
plt.ylim(0, 100)  
plt.colorbar()  
  
plt.show()   
