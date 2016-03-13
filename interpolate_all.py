import glob, os
import numpy as np

for root, dirs, files in os.walk("txt"):
    for filename in files:
        if filename.endswith(".txt"):
            print os.path.join(root, filename)
            os.system("python create_lib.py " + os.path.join(root, filename))
