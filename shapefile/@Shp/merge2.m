% 2015-10-30 15:59:09.389253410 +0100
% Karl Kastner, Berlin

function shp1 = merge(shp1,shp2,dmax)

	shp1 = Shp.cat(shp1,NaN);
	shp2 = Shp.cat(shp2,NaN);

	[n dist] = knnsearch([cvec(shp1.X),cvec(shp1.Y)],[cvec(shp2.X),cvec(shp2.Y)]);

	% limit
	fdx = find(diff([0; dist > dmax; 0]));
	for idx=1:2:length(fdx)-1
		shp1.X = [cvec(shp1.X); NaN; cvec(shp2.X(fdx(idx):fdx(idx+1)))];
		shp1.Y = [cvec(shp1.Y); NaN; cvec(shp2.Y(fdx(idx):fdx(idx+1)))];
	end
end

