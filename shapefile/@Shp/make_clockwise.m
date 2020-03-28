% Fr 27. Nov 16:03:14 CET 2015
% make elements clock wise, except the largest element

function shp = make_clockwise(shp)
	area = Shp.area(shp);
	% flip
	% TODO, this also flips outside areas
	% TODO, can be combined with sorting
	[amax mdx] = max(abs(area));
	for idx=1:length(area)
		% make all negative except mdx
	%	if (mdx == idx)
		if (area(idx) < 0 && idx ~= mdx)
			shp(idx).X = fliplr(rvec(shp(idx).X));
			shp(idx).Y = fliplr(rvec(shp(idx).Y));
		end
	%	shp(idx).X(end) = [];
	%	shp(idx).Y(end) = [];
	end
	% invert largest element
	if ( area(mdx) > 0 )
		shp(mdx).X = fliplr(rvec(shp(mdx).X));
		shp(mdx).Y = fliplr(rvec(shp(mdx).Y));
	end
	
	[area sdx] = sort(abs(area),'descend');
	shp = shp(sdx);
end % make_clockwise
	
