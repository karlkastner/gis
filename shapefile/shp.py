# Thu  2 Jun 10:06:18 CEST 2016
# Karl Kastner, Berlin
# Shp.py

import shapefile

def shapewrite(*arg):
    # get output name
    ofilename = arg[0];
    print(ofilename)
    # get geometry
    geometry = arg[1];
    print(geometry)
    # get x
    x = arg[2];
    print('x')
    # get y
    y = arg[3];
    print('y')

    # create shapefile writer
    # TODO line
    geometry = geometry.lower();
    if   (geometry == "point"):
    	shp = shapefile.Writer(shapefile.POINT)
    elif (geometry == "line"):
    	shp = shapefile.Writer(shapefile.LINE)
    elif (geometry == "polygon"):
    	shp = shapefile.Writer(shapefile.POLYGON)
#    elif (geometry == "polygonz"):
#    	shp = shapefile.Writer(shapefile.POLYGONZ)
    else:
    	return -1
    # end if

    # create fields, every second field is a field name
    print('Creating fields');
    for i in range(4,len(arg),2):
        if (isinstance(arg[i+1][0], str)):
    	    shp.field(arg[i],"C",256);
        else:
    	    shp.field(arg[i],"N",20,6);
        # end if
    # end for i

    # write polygon (must not contain holes / NAN)
    print('Stacking shape structure')
    for i in range(0,len(x)):
#      	print(i)
	if (geometry == "point"):
            shp.point(x[i],y[i]);
        elif (geometry == "polygon"):
	    poly = [];
            for j in range(0,len(x[i])):
#		print(j)
		poly.append([x[i][j],y[i][j]]);
	    # end for j
            #print(poly)
	    shp.poly([poly]);
	# end if

        # build the record
	if (len(arg) > 4):
            r = [];
            for j in range(5,len(arg)+1,2):
    	        # print(j)
    	        r.append(arg[j][i]);
            # end for j
            # print(r)
            shp.record(*r)
        # end if 
    # end for i
    print('Writing shape file');
    shp.save(ofilename);
    return 0

