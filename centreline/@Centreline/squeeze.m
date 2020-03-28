% Sa 9. Jan 16:20:36 CET 2016
% Karl Kastner, Berlin

% when segments where removed, segments connecting to each other but
% not to an other third 
function obj = squeeze(obj)
	C = obj.segment.nodei;
%	C = obj.segment.node_C();
%	[A A1 A2] = obj.segment.connectivity_matrix();

	% find nodes that are connected to two segments
	sdx = true(obj.segment.n,1);
	fdx = find(2 == cellfun(@length,C));
	c = 1:obj.segment.n;
	if (~isempty(fdx))
	for idx=rvec(fdx)
		id1 = cvec(obj.segment.id{c(C{idx}(1))});
		id2 = cvec(obj.segment.id{c(C{idx}(2))});
		% concatenate segments
		% there are four possible arrangements
		if (id1(1) == id2(1))
			id = [flipud(id1); id2(2:end)]; 
		elseif (id1(1) == id2(end))
			id = [flipud(id1); flipud(id2(1:end-1))];
		elseif (id1(end) == id2(1))
			id = [id1; id2(2:end)];
		elseif (id1(end) == id2(end))
			id = [id1; flipud(id2(1:end-1))];
		else
				error('no connection');
		end % if
		% do not remove end loops
		if (id(1) == id(end))
			continue;
		end
		% write concatenated points
		obj.segment.id{c(C{idx}(1))} = id;
		% mark for deletion
		sdx(c(C{idx}(2))) = false;
		% this is not necessary
		obj.segment.id{c(C{idx}(2))} = {};
		% let segment 2 point to segment 1 (iterative concatenation)
		fdx_ = (c == c(C{idx}(2)));
		%c(C{idx}(2)) = c(C{idx}(1));
		c(fdx_) = c(C{idx}(1));
	end % for idx
	% remove segments, but not containing points
	obj.segment.id = obj.segment.id(sdx);
	% TODO, in theory, w must be concatenated as well
	%obj.segment.w  = obj.segment.w(sdx);
	end
end % squeeze

