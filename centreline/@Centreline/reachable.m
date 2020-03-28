
function [dmin, node, ppath, spath, npath, S] = distance(obj,xy)
    [sdx, dl, dr, S, pdx] = obj.find_nearest_segment(xy(1),xy(2));
        d = obj.segment.D(obj.segment.node(sdx,1),:);

	fdx = isfinite(d);
	figure(1);
	clf
	plot(obj.X,obj.Y,'.');
	hold on
	n = obj.segment.node;
%	n = n(fdx,:);
	plot(obj.X(n),obj.Y(n),'r.');
	
	
end
