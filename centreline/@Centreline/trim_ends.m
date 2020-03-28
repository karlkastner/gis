% Sa 28. Nov 16:36:48 CET 2015
% Karl Kastner, Berlin
function obj = trim_ends(obj,level)
	if (nargin() < 2)
		level = inf;
	end
	ldx = 0;
	while (ldx < level)
	obj.seg.n
	E = zeros(obj.seg.n,2);
	ns = zeros(length(obj.X),1);
	for idx=1:obj.seg.n
		% get end points
		id = obj.seg.id{idx};
		E(idx,1) = id(1);
		E(idx,2) = id(end);
		ns(id(1)) = ns(id(1))+1;
		ns(id(end)) = ns(id(end))+1;
	end % for idx
	% search for single endpoints
	fdx = (1 == ns);
	% translate points to elements
	%ddx = false(obj.seg.n,1);
	ddx = fdx(E(:,1)) | fdx(E(:,2));
	ddx = find(ddx);
	if (isempty(ddx))
		break;
	end

	% remove segments pointing to dead end points
	obj.seg.remove(ddx);
	ldx =ldx+1;
	end
end % trim_ends

