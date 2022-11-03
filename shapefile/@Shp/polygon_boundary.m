% Wed 30 May 10:23:17 CEST 2018
%
%% 
%
function polygon_boundary(shp)
	shp = Shp.split_nan(shp);
	% TODO rename to remove_closure (also applies to line)
	shp = Shp.remove_polygon_closure(shp);
	bnd = [];
	X   = [];
	Y   = [];
	k   = 0;
	for idx=1:length(shp)
		% first and last points
		n = length(shp(idx).X);
		%k(idx+1) = k(idx) + n;
		bnd_ = [[(k+1:k+n-1)', (k+2:k+n)'];
                        [k+1, k+n]];
		k = k+n;
		bnd = [bnd;bnd_];
		X = [X;cvec(shp(idx).X)];	
		Y = [Y;cvec(shp(idx).Y)];
	end
	if (0)	
	% edges
	n   = length(shp.X);
	fdx = cvec(isfinite(shp.X));
	id  = cumsum(fdx).*double(fdx);
	bnd = [id(1:end-1),id(2:end)];
	bnd = bnd(bnd(:,1)>0 & bnd(:,2)>0,:);
	%id  = id(fdx);
	P   = [cvec(shp.X(fdx)),cvec(shp.Y(fdx))];
	end
	P = [X,Y];
end

