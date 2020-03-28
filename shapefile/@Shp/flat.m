% 2014-09-09 11:07:29.710047954 +0200
% Karl Kastner, Berlin
% TODO merge with cat
function [out seg_id] = flat(shp)
	if (isfield(shp,'seg'))
		warning('shape file contains already a field named seg, is overwritten');
	end
	X      = [];
	Y      = [];
	seg    = [];
	seg_id = [];
	for idx=1:length(shp)
		% only take over valid coordinates
		fdx = find(isfinite(shp(idx).X.*shp(idx).Y));
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
%		% one segment only
%		if (~isfield(shp,'seg'))
%			% only take over valid coordinates
%			fdx = find(isfinite(shp.X.*shp.Y));
%			n       = sum(fdx);
%			out.X   = X(fdx);
%			out.Y   = 
%			out.seg = ones(n,1);
%			seg_id = [1 n];
%		else
%			warning('already flatted, inverse index seg_id not build')
%		end
%	end
end % flat_shp

