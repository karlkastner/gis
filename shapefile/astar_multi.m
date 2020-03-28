% Wed 17 Jul 15:54:39 CEST 2019
function [shp,shp_] = astar_multi(val,X,Y,n,p)
if (nargin()<2)
	X = [];
end
if (nargin()<3)
	Y = [];
end
if (nargin()<4 || isempty(n))
	n = 10;
end
if (nargin()<5||isempty(p))
	p = 0;
end

%xy0   = [60,13];
%[x,y,passed] = astar(S_,xy0(2),xy0(1));
%[shp] = astar_recursive(S_,xy0(2),xy0(1));
%fdx = isfinite(shp.X);
%shp.X(fdx) = lon(shp.X(fdx)); %scale*shp.X;
%shp.Y(fdx) = lat(shp.Y(fdx)); %scale*shp.Y;
%shp.l = scale*shp.l;

% parse n-largest rivers
%shp = struct();
val_ = val;
v0 = zeros(n,1);
for idx=1:n
	[v0(idx),mid] = max(val_(:));
	if (v0(idx) < p*v0(1))
		v0 = v0(1:idx-1);
		break;
	end
	[i0(idx),j0(idx)]  = ind2sub(size(val_),mid);
	shp_i    = astar_recursive(val_,i0(idx),j0(idx));
	fdx      = isfinite(shp_i.ij);
	val_(shp_i.ij(fdx)) = 0;
	fdx = isfinite(shp_i.i);
	shp_i.X = NaN(size(fdx));
	shp_i.Y = NaN(size(fdx));
	shp_i.X(fdx) = X(shp_i.i(fdx));
	shp_i.Y(fdx) = Y(shp_i.j(fdx));
	shp(idx) = shp_i; 
end

	shp_   = struct();
	shp_.Z = v0;
	shp_.i = i0;
	shp_.j = j0;
	shp_.X = X(i0);
	shp_.Y = Y(j0);
end % astar_multi

