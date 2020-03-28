% assumes that leaves do not connect to mid-points
function [shp,fdx] = remove_leaves(shp,dmax,n)
	if (nargin()<2)
		dmax   = 0;
	end

	% end points
	Cx = arrayfun(@(s) [s.X(1),s.X(end-1),NaN],shp,'uniformoutput',false);
	Cy = arrayfun(@(s) [s.Y(1),s.Y(end-1),NaN],shp,'uniformoutput',false);

	%C = cell2mat(C);
	shp_     = repmat(struct(),length(shp),1);
	[shp_.X] = Cx{:};
	[shp_.Y] = Cy{:};


	X = vertcat(shp_.X);
	X = X(:,1:2);
	X = X(:);
	Y = vertcat(shp_.Y);
	Y = Y(:,1:2);
	Y = Y(:);

	[id,d] = knnsearch([X,Y],[X,Y],'K',2);
	fdx    = all(d<dmax,2);
	fdx    = reshape(fdx,[],2);
	fdx    = all(fdx,2);

	shp = shp(fdx);
	if (nargin()>2 && n>1)
		shp = Shp.remove_leaves(shp,dmax,n-1);
	end
end % remove_leaves
 
