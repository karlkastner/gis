% Tue Dec 16 15:16:32 CET 2014
% Karl Kastner, Berlin

% TODO rename into connect segments
% find connection between segments
function obj = init_connect(obj)
	% fetch
	X = obj.X;
	Y = obj.Y;
	seg_id = obj.segment.seg_id;
	% assumption that the segments are not circles
	Xn(1:2,1) = X(seg_id(1,:));
	Yn(1:2,1) = Y(seg_id(1,:));
	seg_node(1,1) = 1;
	seg_node(1,2) = 2;
	nn = 2;
	for idx=2:size(seg_id,1)
		% first node of this segmend
		% look of one of the existing nodes is connected
		d2 = Geometry.distance2([X(seg_id(idx,1)),Y(seg_id(idx,1))],[Xn,Yn]);
		[d2, mindx1] = min(d2);
		if (d2 > obj.thresh)
			% this is a new node
			nn     = nn+1;
			mindx1 = nn;
			Xn(nn,1) = X(seg_id(idx,1));
			Yn(nn,1) = Y(seg_id(idx,1));
			% The relation node->id is not unique
			% node_id(nn) = sm(idx,1);
		end
		d2 = Geometry.distance2([X(seg_id(idx,2)),Y(seg_id(idx,2))],[Xn,Yn]);
		[d2, mindx2] = min(d2);
		if (d2 > obj.thresh)
			% this is a new node
			nn     = nn+1;
			mindx2 = nn;
			Xn(nn,1) = X(seg_id(idx,2));
			Yn(nn,1) = Y(seg_id(idx,2));
			%node_id(nn) = sm(idx,2);
		end
		seg_node(idx,1) = mindx1;
		seg_node(idx,2) = mindx2;
		% connect the two nodes
		%C(mindx1,mindx2) = 1;
		%C(mindx2,mindx1) = 1;
	end
	% inverse node to segment
	nodei = cell(nn,1);
	for idx=1:size(seg_node,1)
		nodei{seg_node(idx,1)} = [nodei{seg_node(idx,1)},idx];
		nodei{seg_node(idx,2)} = [nodei{seg_node(idx,2)},idx];
	end
	% obj.node_id  = node_id;
	obj.segment.node = seg_node;
	obj.segment.n_node = nn;
	obj.segment.nodei = nodei;
end % init_connect 

