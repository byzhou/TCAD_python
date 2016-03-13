import random 
import glob, os, sys
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import scipy.stats as stats

# ref_interpolate_lib = []
# if len(sys.argv) != 2:
#     print "Help Message"
#     print "You need to put the command in such format"
#     print "python monte_carlo_test.py project_name"
# project_name        = sys.argv[1]
# 
# ref_interpolate_TjIn = []
# for root, dirs, files in os.walk("npy/" + project_name + "/TjIn"):
#     for filename in files:
#         if filename.endswith(".npy"):
#             print os.path.join(root, filename)
#             ref_interpolate_TjIn.append(np.load(os.path.join(root, filename)))
# 
# ref_interpolate_TjFree = []
# for root, dirs, files in os.walk("npy/" + project_name + "/TjIn-Tj"):
#     for filename in files:
#         if filename.endswith(".npy"):
#             print os.path.join(root, filename)
#             ref_interpolate_TjFree.append(np.load(os.path.join(root, filename)))

# data has been fully collected

ref_matrix      = 1 + np.random.random((100,100))
test_matrix     = np.random.random((100,100))
dif_matrix      = ref_matrix - test_matrix
dif_matrix_flatten = dif_matrix.ravel()


bar_gaussion    = np.random.normal(0, 3, 10000)
print stats.normaltest(dif_matrix_flatten)
print stats.normaltest(bar_gaussion)

n, bins, patches = plt.hist([bar_gaussion, bar_gaussion - 10 * dif_matrix_flatten], 20, normed=1, alpha=0.75)
plt.show()
print test_matrix - ref_matrix
