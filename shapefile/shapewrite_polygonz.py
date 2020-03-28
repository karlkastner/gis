#!/usr/bin/python
# Wed  1 Jun 13:22:34 CEST 2016
# Karl Kastner, Berlin

import sys
import csv
import shapefile

if len(sys.argv) > 1:
	ifile = str(sys.argv[1])
else:
	print("Requiring input file name")
	sys.exit(-1)
# end if

ofile = ifile[:-4] + ".shp";
delimiter = ";";

geometry = "polygonz";

# create shapefile writer
geometry = geometry.lower();
if   (geometry == "point"):
	shp = shapefile.Writer(shapefile.POINT)
elif (geometry == "polygon"):
	shp = shapefile.Writer(shapefile.POLYGON)
elif (geometry == "polygonz"):
	shp = shapefile.Writer(shapefile.POLYGONZ)
else
	return -1
# end if

shp.field("ID","N",8,0);

x = []
y = []
z = []

shp.poly(parts=[[[0, 0, 0], [1, 0, 1], [0, 1, 2]]], shapeType=shapefile.POLYGONZ);
#shp.poly(parts=[[[0, 0], [1, 0], [0, 1]]], shapeType=shapefile.POLYGON);
#shp.poly(parts=[[[0, 0], [1, 0], [0, 1], [0, 0]]], shapeType=shapefile.POLYGON);

	# Open the csv file and set up a reader
#with open(ifile,'r') as csvfile:
#    reader = csv.reader(csvfile, delimiter=delimiter);
#    for i,row in enumerate(reader):
#	if len(row) > 0:
#	 x.append(float(row[0]));
#	 y.append(float(row[1]));
#	 z.append(float(row[2]));
    # end for i,row
# end with

shp.record(1);
	
#for j,xj in enumerate(x):
#	# shp.point(row["X"], row ["Y"], 0, 0)
#	shp.point(xj,y[j]);
#	shp.record(time[j], mean_Depth[j], std_Depth[j], nsample[j]);
#	shp.record(time[j], mean_Depth[j], std_Depth[j]);
# end for

shp.save(ofile);

