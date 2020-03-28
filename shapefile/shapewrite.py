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

#if len(sys.argv) > 2:
#	ofile = str(sys.argv[2])
#else:
#	print("Requiring output file name")
#	sys.exit(-1)
# end if

#ifile = "test.csv"
#ofile = "test.shp"
ofile = ifile[:-4] + ".shp";
delimiter = ";";

# create shapefile writer
shp = shapefile.Writer(shapefile.POINT)

#shp.field('X','F',10,8)
#shp.field('Y','F',10,8)

#shp.field("test","C",40)
shp.field("time", "N", 14,6);
shp.field("mean_Depth", "N", 10,6);
shp.field("std_Depth", "N", 10,6);
#shp.field("nsample",6,0);

x    = []
y    = []
time = []
mean_Depth = []
std_Depth  = []
nsample    = []

#test = []

# Open the csv file and set up a reader
with open(ifile,'r') as csvfile:
    reader = csv.reader(csvfile, delimiter=delimiter);
    #reader = csv.DictReader(csvfile, 'delimiter', delimiter);
    for i,row in enumerate(reader):
#	print(len(row))
	if len(row) > 0:
#	 print row
      	 # shp.record(row["mean_Depth"], row["std_Depth"]);
	 x.append(float(row[0]));
	 y.append(float(row[1]));
	 time.append(float(row[2]));
#	 test.append("C")
	 mean_Depth.append(float(row[3]));
	 std_Depth.append(float(row[4]));
	 nsample.append(row[5]);
    # end for i,row
# end with
	
for j,xj in enumerate(x):
	# shp.point(row["X"], row ["Y"], 0, 0)
	shp.point(xj,y[j]);
	shp.record(time[j], mean_Depth[j], std_Depth[j], nsample[j]);
#	shp.record(time[j], mean_Depth[j], std_Depth[j]);
# end for

shp.save(ofile)

