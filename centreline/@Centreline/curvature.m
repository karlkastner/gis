% Mo 11. Jan 10:34:57 CET 2016
% Karl Kastner, Berlin

function [c obj] = curvature(obj, fdx)
	% compute curvature on demand at the first time this function is called
	if (isempty(obj.curvature_))
		% for each segment
		obj.curvature_ = zeros(obj.n,1);
		for idx=1:obj.segment.n
			id = obj.segment.id{idx};
			obj.curvature_(id) = curvature(obj.X(id),obj.Y(id));
		end % for idx
	end % if isempty(obj.curvature)
	if (nargin < 2)
		c = obj.curvature_;
	else
		c = obj.curvature_(fdx);
	end
end % calc_curvature

