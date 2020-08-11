#!/usr/bin/python
# Tue 12 May 12:53:35 +08 2020
# Karl Kastner, Berlin
import shapefile
import sys

if (len(sys.argv) < 2) or (len(sys.argv) > 3) : 
	print "usage: " + sys.argv[0] + " in.shp {out.csv}"
	sys.exit(-1)

shpname = sys.argv[1];
myshp = open(shpname)
dbfname = shpname[0:-4] + ".dbf";
mydbf = open(dbfname);
sf    = shapefile.Reader(shp=myshp, dbf=mydbf);

if len(sys.argv) > 2:
	oname = sys.argv[2];
else:
	oname = shpname[0:-4] + ".csv";


f = open(oname, "w")

shapes = sf.shapes();
for jdx in range(0,len(shapes)-1):
	xy = shapes[jdx].points;
	z  = shapes[jdx].z;
	for idx in range(0,len(z)-1):
		f.write("%d; %f; %f; %f\n"% (jdx, xy[idx][0], xy[idx][1], z[idx])) 

f.close();

