% Do 24. Sep 16:07:54 CEST 2015
% Karl Kastner, Berlin

function export_ldb(shp,ldbname,twoutm)
	% read input file
%	shp = shaperead(shpname);
	X = [shp.X];
	X = X(:);
	Y = [shp.Y];
	Y = Y(:);
	if (nargin() > 2 && twoutm)
		[X Y] = utm2latlon(X, Y, '49M');
	end
	n = length(X);
	% open output file
	fid = fopen(ldbname,'w');
	if (-1 == fid)
		error(['Cannot open file ', ldbname, ' for writing']);
	end
	% replace NaN by error value 999.999
	X(isnan(X)) = 999.999;
	Y(isnan(Y)) = 999.999;
	% write output
	fprintf(fid,'*column 1 = x coordinate\n');
	fprintf(fid,'*column 2 = y coordinate\n');
	fprintf(fid,'    1\n');
	fprintf(fid,' %d %d\n',n,2);
	% note: lat lon is swapped in the ldb file
	fprintf(fid,' %18.15f %18.15f\n',[X Y]');
	% close output file
	if (-1 == fclose(fid))
		error(['Cannot close file ', ldbname]);
	end
end % export_ldb

