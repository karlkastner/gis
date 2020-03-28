% 2016-09-29 16:50:54.884079700 +0200
% Karl Kastner, Berlin
function [p eid gapid] = edge_chain(edge)
	p   = edge(end,:);
	eid = (1:length(edge));

	% TODO make faster by using bucket sort
	% give vertices a local index
	% construct vertex to edge index
	% march continuosuly
	% check if closed

	% chain the edges (bucket sort)
	

	% chain the edges (insertion sort)
	gapid = 0;
	for idx=size(edge,1)-1:-1:1
		open = true;
		for jdx=idx:-1:1
			if (edge(jdx,1) == p(end))
				p(end+1)    = edge(jdx,2);
				edge(jdx,:) = edge(idx,:);
				open = false;
				break;
			end
			if (edge(jdx,2) == p(end))
				p(end+1) = edge(jdx,1);

				edge(jdx,:) = edge(idx,:);
				open = false;
				break;
			end
		end % for jdx
		% mark gap in chain
		if (open)
			gapid = [gapid, idx];
		else
			% swap
			help     = eid(idx);
			eid(idx) = eid(jdx);
			eid(jdx) = help;
		end
	end % for idx
end

