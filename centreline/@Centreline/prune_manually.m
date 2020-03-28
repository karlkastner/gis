% Fr 8. Jan 18:06:33 CET 2016
% Karl Kastner, Berlin

function obj = prune_manually(obj,px,py)
	% create mask for removed segments
	sdx = true(obj.segment.n,1);
	for idx=1:length(px)
		sdxi = obj.find_nearest_segment(px(idx),py(idx));
		sdx(sdxi) = false;
	end
	obj.prune(sdx);
end

