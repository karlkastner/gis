% Thu 26 May 18:00:47 CEST 2016
% Karl Kastner, Berlin
%
%% close polygon, i.e. make the first point identical to the last
%
function out = close_polygon(shp)
	seg_C = Shp.segment(shp);
	out   = struct();
	for idx=1:length(shp)
		seg = seg_C{idx};
		out(idx).X = [];
		out(idx).Y = [];
		for jdx=1:size(seg,1)
			X = cvec(shp(idx).X(seg(jdx,1):seg(jdx,2)));
			Y = cvec(shp(idx).Y(seg(jdx,1):seg(jdx,2)));
			if ( (X(1) ~= X(end)) || (Y(1) ~= Y(end)) )
				X(end+1) = X(1);
				Y(end+1) = Y(1);
			end
			out(idx).X = [out(idx).X;X; NaN];
			out(idx).Y = [out(idx).Y;Y; NaN];
		end
		
	end
end

