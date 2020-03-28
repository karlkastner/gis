% Mo 11. Jan 15:54:16 CET 2016
% Karl Kastner, Berlin
function [d, pdx, S, sdx] = routing2(obj, xp, yp)
	n = length(xp);
	S = [];
	d = 0;
	pdx = [];
	sdx = [];
	for idx=1:n-1
		[d_i, node, pdx_i, sdx_i, ndx_i, S_i] = obj.distance(xp(idx),yp(idx),xp(idx+1),yp(idx+1));
%		size(pdx_i)
%		plot(obj.X(pdx_i),obj.Y(pdx_i),'.-');
%		hold on
%		plot(xp(idx),yp(idx),'ok');
%		plot(xp(idx+1),yp(idx+1),'ok');
%		di = S_(end);
		S   = [S; S_i+d];
		d   = d+d_i;
		pdx = [pdx; cvec(pdx_i)];
		sdx = [sdx;idx*ones(length(pdx_i),1)];	
	end
	% do not remove duplicates (round trips)
	%[pdx udx] = unique(pdx,'stable');
	%S = S(udx);
	%sdx = sdx(udx);
end

