% 2014-09-09 11:07:29.710047954 +0200
% Karl Kastner, Berlin
%
% move all features into a single feature
%
% TODO merge with cat
function [out, seg_id] = flat(shp,separate)
	if (isfield(shp,'seg'))
		warning('shape file contains already a field named seg, is overwritten');
	end
	if (nargin()<2)
		separate = 0;
	end
	X      = [];
	Y      = [];
	seg    = [];
	seg_id = [];
	for idx=1:length(shp)
		% only take over valid coordinates
		if (~separate)
			fdx = find(isfinite(shp(idx).X.*shp(idx).Y));
		else
			fdx = true(size(shp(idx).X));
		end
		if (~isempty(fdx))
			seg_id(idx,1) = length(X)+fdx(1);
			seg_id(idx,2) = length(X)+fdx(end);
			X = [X; cvec(shp(idx).X(fdx))];
			Y = [Y; cvec(shp(idx).Y(fdx))];
			seg = [seg; idx*ones(length(fdx),1)];
		end
	end
	out.X = X;
	out.Y = Y;
	out.seg = seg;
end % flat_shp

