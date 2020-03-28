% Fr 8. Jan 10:50:48 CET 2016
% Karl Kastner, Berlin
function obj = build_inverse_index(obj)
	% not unique, last is served
	rid = NaN(obj.centre.n,1);
	for idx=1:obj.n
		rid(obj.id{idx}) = idx;
	end % for idx
	obj.rid = rid;
%	% TODO quick fix for end loops
%	fdx = isnan(rid);
%	obj.centre.X(fdx) = NaN;
%	obj.centre.Y(fdx) = NaN;
end

