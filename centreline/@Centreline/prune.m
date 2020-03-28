% Fr 8. Jan 18:05:02 CET 2016
% Karl Kastner, Berlin

function obj = prune(obj,sdx)

	% only keep selected segments
	obj.segment.id = obj.segment.id(sdx);
	%obj.segment.w  = obj.segment.w(sdx);

	% mark remaining points and determinine new position
	flag = false(size(obj.X));
	flag(autocat(obj.segment.id{:})) = true;
	pos = cumsum(flag);

	% remove unconnected points
	obj.X(~flag)      = [];
	obj.Y(~flag)      = [];
	obj.width_(~flag) = [];

	% update seg indices
	for idx=1:length(obj.segment.id)
		obj.segment.id{idx} = pos(obj.segment.id{idx});
	end

	% update the inverse index
%	obj.segment.build_inverse_index();

	% reset qtree, as points have changed
	obj.qtree = [];

	% TODO, only reinitiate the node index
	obj.init();

	% remove 2-segment junctions by concatenating segments
	obj.squeeze();

	obj.init();
end

