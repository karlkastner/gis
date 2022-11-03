% Mon 26 Sep 19:55:27 CEST 2016
%
%% import poly file
%
function [shp, XY, edge, XYhole, C] = import_poly(filename)
	fid = fopen(filename);
	line_C = textread(fid, '%s', 'delimiter', '\n');
	fclose(fid);
	id = 0;

	A = fscanf_(fid,'%d %d %d %d');
	np = A(1);
	XY = zeros(np,2);
	for idx=1:np
		A = fscanf_(fid,'%d %f %f');
		XY(idx,:) = A(2:3);
	end
	A = fscanf_(fid,'%d %d');
	ne = A(1);
	edge = zeros(ne,2);
	for idx=1:ne
		A = fscanf_(fid,'%d %d %d');
		edge(idx,:) = A(2:3);
	end
	A = fscanf_(fid,'%d');
	nh = A(1);
	XYhole = zeros(nh,2);
	for idx=1:nh
		A = fscanf_(fid,'%d %f %f');
		XYhole(idx,:) = A(2:3);
	end
	function A = fscanf_(fid,format)
		id = id+1;
		line = line_C{id};
		A = sscanf(line,format);
	end

	% make chains
	E = zeros(ne,2);
	N = zeros(ne,1);
	for idx=1:ne
		N(edge(idx,1)) = N(edge(idx,1))+1;
		E(edge(idx,1),N(edge(idx,1))) = edge(idx,2);
		N(edge(idx,2)) = N(edge(idx,2))+1;
		E(edge(idx,2),N(edge(idx,2))) = edge(idx,1);
	end
	if (min(N) < 2)
		warning('some points are not connected properly');
	end
	if (max(N) > 2)
		warning('Inconsistent boundary: some points connected to more than 2 neighbours');
	end
	% start hangling
	id = 1;
	start = 1;
	C     = 1;
	flag  = false(np,1);
	flag(1) = true;
	next = E(1,2);
	while (1)
		flag(next) = true;
		C(end+1) = next;
		% close loop
		if (next == start)
			% separator
			C(end+1) = NaN;
			% continue to the next unprocessed point
			while (id <= np && flag(id))
				id=id+1;
			end
			% all points processed, terminate
			if (np+1 == id)
				break;
			end
			% start new loop
			C(end+1) = id;
			start    = id;
			next     = id;
		end
		if (C(end-1) == E(next,1))
			next = E(next,2);
		else
			% TODO verify connection
			next = E(next,1);
		end
	end % while
	shp.X = NaN(size(C));
	shp.Y = NaN(size(C));
	fdx = isfinite(C);
	shp.X(fdx) = XY(C(fdx),1);
	shp.Y(fdx) = XY(C(fdx),2);
%	shp.Geometry = 'Polygon';
	shp.Geometry = 'Line';
end

