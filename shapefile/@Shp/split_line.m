% Di 29. Sep 10:38:59 CEST 2015
% Karl Kastner, Berlin
%
%% split line features into single sements
%
function obj = split_lines(obj)
	shp = struct();
	n   = 0;
	for idx=1:length(obj.shp)
		X = obj.shp(idx).X;
		Y = obj.shp(idx).Y;
		for jdx=1:length(X)-1
			n = n+1;
			shp(n).X = X(jdx:jdx+1);
			shp(n).Y = Y(jdx:jdx+1);
			shp(n).Id = n;
			shp(n).Geometry = 'Line';
		end % for jdx
	end % for idx
	obj.shp = shp;
end % split_lines

