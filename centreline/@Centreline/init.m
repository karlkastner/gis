% Mo 8. Sep 15:34:24 CEST 2014
% Karl Kastner, Berlin

% create S-N reference coordinate system from centreline
% TODO : branches need to be concatenated in the right order and side stream ignored
% TODO : squeezing to reduce input resolution was removed, do this externally

function obj = init(obj)
	obj.segment.init();

	seg_id = obj.segment.seg_id();

	seg_S = zeros(length(obj.X),1);

	% TODO use higher order accurate path length
	ds = zeros(obj.n,1);

	% integrate length of each segment individually
	for idx=1:obj.segment.n
		id = obj.segment.id{idx};
		dx = [0; diff(obj.X(id))];
		dy = [0; diff(obj.Y(id))];
		ds(id) = hypot(dx,dy);
		% integrate
		S          = cumsum(ds(id));
		seg_S(id)  = S;

		% TODO quick fix
		obj.seg_S0(idx,1:2) = [0, S(end)];
	end
	obj.seg_S = seg_S;
%	obj.S = [];
	obj.thresh = 2*quantile(ds,0.9);

	% TODO segments should be stored differently, segment length for segments
	% invalidate first and last values
	for idx=1:obj.segment.n
		%id = obj.segment.id{idx};
		%obj.seg_S(id(1))   = NaN;
		%%obj.seg_S(id(end)) = NaN;
		obj.seg_S(seg_id(idx,1)) = NaN;
		obj.seg_S(seg_id(idx,2)) = NaN;
		
	end
if (0)
	% set up S coordinate "axis" backbone
	dx         = [0; diff(obj.X)];
	dy         = [0; diff(obj.Y)];
	ds         = sqrt(dx.*dx + dy.*dy);
	obj.thresh = 2*quantile(ds,0.9);
	% TODO if S is more accurately integrated when it follows an arc,
	% however, this gives problems during the later projection
	obj.S     = cumsum(ds);
	% integrate segment internally only
	seg_S = zeros(size(obj.seg_S));
	for idx=1:size(seg_id,1)
		seg_S(seg_id(idx,1):seg_id(idx,2)) = ...
			[0; cvec(cumsum(ds(seg_id(idx,1)+1:seg_id(idx,2))))];
	end
	obj.seg_S = seg_S;
end
	% TODO, make these function compute on first call
	obj.segment.build_inverse_index();

	obj.init_connect();
	obj.init_node_D();

	% build quad tree
	obj.qtree = Qtree2_java(obj.X,obj.Y);
end % create_sn

