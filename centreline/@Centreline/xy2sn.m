% Mo 25. Jan 16:17:03 CET 2016
% Karl Kastner, Berlin
function [S, N, pid, sid, obj] = xy2sn(obj,X,Y)
	% TODO, pass search object
	[S, N, pid] = xy2sn_java(obj.X,obj.Y,obj.seg_S,obj.segment.rid,X,Y);
	if (nargout() > 3)
		sid = cvec(obj.segment.rid(pid));
	end
end 

