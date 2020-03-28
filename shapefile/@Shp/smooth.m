% 2015-10-30 19:54:33.523054273 +0100
% Karl Kastner, Berlin

function shp = smooth(shp,cmax)
	n = 5;
	for idx=1:length(shp)
		X = shp(idx).X;
		Y = shp(idx).Y;

		while(1)
			dx = cdiff(X,n);
			ddx = cdiff(dx,n);
			dy = cdiff(Y,n);
			ddy = cdiff(dy,n);
%		dx = X - circshift(X,5);
%		dy = Y - circshift(X,
			c = curvature(dx,dy,ddx,ddy);
			c = abs(c);
			fdx = find(c>cmax);
			if (isempty(fdx))
				break;
			end
			X(fdx) = [];
			Y(fdx) = [];
		end
		shp(idx).X = X;
		shp(idx).Y = Y;
	end
end

