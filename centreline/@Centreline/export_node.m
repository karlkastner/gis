% Mo 25. Jan 00:55:23 CET 2016
function [shp obj] = export_node(obj)
	% TODO this is hardcoded for testing
	id0=min(208,obj.segment.n_node);
	for idx=1:obj.segment.n
		id = obj.segment.id{idx};
		node = obj.segment.node(idx,:);
		X(node(1)) = obj.X(id(1));
		X(node(2)) = obj.X(id(end));
		Y(node(1)) = obj.Y(id(1));
		Y(node(2)) = obj.Y(id(end));
		S(node(1)) = obj.segment.D(id0,node(1));
		S(node(2)) = obj.segment.D(id0,node(2));
	end
	index = (1:obj.segment.n_node)';
	S     = max(min(S,1e7),-1e7);
	shp   = Shp.create('Geometry','Point','X',X,'Y',Y,'S',S,'index',index);
end

