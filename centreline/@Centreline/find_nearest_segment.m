% Tue Dec 16 15:41:47 CET 2014
% Karl Kastner, Berlin

function [sdx dl dr S pdx obj] = find_nearest_segment(obj, X0, Y0)
	seg_id   = obj.segment.seg_id;
	seg_S    = obj.seg_S;
	seg_id_  = obj.segment.seg_id_;

	if (isempty(obj.qtree) || isempty(obj.qtree.qtree))
%		obj.qtree = Qtree_(obj.X,obj.Y);
	end

	timer = tic();
	% pdx   = obj.qtree.nearest_neighbour(X0, Y0, 1);
	% TODO, there is a bug in qtree, that makes the index 0 when it is 1
	pdx   = knnsearch([obj.X,obj.Y],[X0(:),Y0(:)]);

	t     = toc(timer);
	if (t > 10)
		printf('Nearest neighbour search took %t seconds',t);
	end
	sdx = obj.segment.rid(pdx);
	%seg_id = obj.segment.seg_id;
	if (nargout() > 1)
		% quick fix for missing first element
		%id1 = @cellfun(@(x) x(1),obj.segment.id{sdx});
		%ide = @cellfun(@(x) x(1:2),obj.segment.id{sdx});
		fdx      = (pdx == seg_id(sdx,1));
		pdx(fdx) = seg_id_(sdx(fdx),1);
		fdx      = (pdx == seg_id(sdx,2));
		pdx(fdx) = seg_id_(sdx(fdx),2);
%		if (pdx == id(1))
%			pdx = id(2);
%		end
%		if (pdx == id(end))
%			pdx = id(end-1);
%		end
		% dl by definition, same as S
		S     = obj.seg_S(pdx);
		dl    = abs(S - obj.seg_S(seg_id_(sdx,1)));
		dr    = abs(S - obj.seg_S(seg_id_(sdx,2)));
	end
end

