function kml = shp2kml(shp,kml_str)
	if (isstr(shp))
		% load shp from file
		shp = shaperead(shp);
	end
	% conversion
	if (nargin() > 1)
		if (~isstr(kml))
			error('optional argument 2 KML must be a valid file name');
		end
		kmlwrite(kmlstr,S) 
	end
end % shp2kml

