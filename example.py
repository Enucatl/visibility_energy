import h5py
import matplotlib.pyplot as plt

sample = "/afs/psi.ch/project/hedpc/raw_data/2016/2016_08_02/visibility_energy/series.160802.152721800685.h5"
h5file = h5py.File(sample)
dataset = h5file["/postprocessing/visibility"]
plt.figure()
plt.imshow(dataset)
plt.show()
input()
