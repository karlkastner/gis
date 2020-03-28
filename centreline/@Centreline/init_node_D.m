% Tue Dec 16 14:39:20 CET 2014
% Karl Kastner, Berlin

function obj = init_node_D(obj)
	% distance matrix for direct connections (sparse)
	D = obj.weighed_connection_matrix();
	% distance matrix for shortest path (full)
	D = graphallshortestpaths(D);
%	D = inf(nn,nn);
%	for idx=1:nn
%		D(idx,idx) = 0;
%	end
% TODO this is a slow algorihtm (runtime n^4)
%	% direct connections
%	for idx=1:size(seg_id,1)
%		d = abs(seg_S(seg_id(idx,1)) - seg_S(seg_id(idx,2)));
%		D(seg_node(idx,1),seg_node(idx,2)) = d;
%		D(seg_node(idx,2),seg_node(idx,1)) = d;
%	end
%	% complete and find shorter indirect connections
%	change = true;
%	n = 0;
%	while (change)
%		change = false;
%		n = n+1;
%		n/nn	
%		for idx=1:nn
%		 for jdx=idx+1:nn
%		  for kdx=1:nn
%			d = D(idx,kdx) + D(jdx,kdx);
%			if (d < D(idx,jdx))
%				D(idx,jdx) = d;
%				D(jdx,idx) = d;
%				change = true;
%			end
%		  end
%		 end
%		end
%	end
	obj.segment.D = D;
end % init_node_D

