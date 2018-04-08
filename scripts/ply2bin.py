from plyfile import PlyData
import os
import sys

reconstruction_dir = sys.argv[1]
readpath = os.path.join(reconstruction_dir, "PMVS", "models", "option-0000.ply")
fname = os.path.basename(os.path.dirname(os.path.dirname(reconstruction_dir)))
writepath = os.path.join(reconstruction_dir, "PMVS", "models", fname + ".ply")
plydata = PlyData.read(str(readpath))
plydata = PlyData([plydata['vertex']], text=False, byte_order='<')
plydata.write(str(writepath))