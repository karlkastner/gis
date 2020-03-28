% Mo 11. Jan 15:54:16 CET 2016
% Karl Kastner, Berlin
%
% function [d, pdx, S] = routing(obj, xp, yp)
%
function [d, pdx, S] = routing(obj, xp, yp)
	n = length(xp);
	D = sparse(n,n,n);
	for idx=1:n
		D(idx,idx) = inf;
		for jdx=idx+1:n
			D(idx,jdx) = obj.distance(xp(idx),yp(idx),xp(jdx),yp(jdx));
			D(jdx,idx) = D(idx,jdx);
		end
	end
	%D = graphallshortestpaths(D);
	%tree = graphminspantree(D);
	% this should now be a degenerated tree
	%for idx=2:n
	%for jdx=1:n
	%end
	%end

	% choose last point as initial point (order is swapped by tracing)
%	p    = n;
%	open = 1:n-1;
	p = 1;
	open = 2:n;
	% connect end point to closest
	while (~isempty(open))
		[md1, mdx1] = min(D(open,p(1)));
		[md2, mdx2] = min(D(open,p(end)));
		if (md1 < md2)
			p = [open(mdx1),p];
			open(mdx1) = [];
		else
			p = [p; open(mdx2)];
			open(mdx2) = [];
		end
	end
	
	
	% choose point furthest away as the start point
%	[mv mdx] = max(max(D));
%	p = mdx;
%	for idx=1:n-1
%		D(:,mdx) = inf;
%		% find closest connecting point
%		[mv mdx] = min(D(mdx,:));
%		p(end+1) = mdx;
%	end
	
	% now, that order is clear, determine route
	S  = [];
	d  = 0;
	pdx = [];
	for idx=1:n-1
		[d_, node, pdx_, sdx_, ndx_, S_] = obj.distance(xp(p(idx)),yp(p(idx)),xp(p(idx+1)),yp(p(idx+1))); %,scaleflag);
		S_ = abs(S_);
		d_ = S_(end);
		S = [S; d+S_];
		d = d+d_;
		pdx = [pdx; cvec(pdx_)];
%		figure(1000)
%subplot(2,2,1)
%		plot(obj.X(pdx_),obj.Y(pdx_))
%		hold on
%		plot(obj.X(pdx_(1)),obj.Y(pdx_(1)),'.')
%		figure(1001)
%		subplot(2,2,idx)
%		plot(S_)
	end
	[pdx udx] = unique(pdx,'stable');
	S = S(udx);
%subplot(2,2,2)
%		plot(obj.X(pdx),obj.Y(pdx))
%subplot(2,2,3)
%		plot(S)
%pause
end

