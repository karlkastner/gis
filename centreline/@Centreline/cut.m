% Wed Nov 19 17:55:58 CET 2014
% Karl Kastner, Berlin
%
% TODO this is currently not working properly, as also the indices into the
% segments need to be updated
% function obj = clip(obj,x0,y0,r)
% 
function obj = clip(obj,x0,y0,r)
	dx     = obj.X - x0;
	dy     = obj.Y - y0;
	D2     = dx.*dx + dy.*dy;
	fdx    = D2 < r*r;
	obj.X  = obj.X(fdx);
	obj.Y  = obj.Y(fdx);
end % clip

