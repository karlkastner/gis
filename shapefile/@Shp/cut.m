% Thu Mar 26 21:06:42 CET 2015
% Karl Kastner, Berlin
%
%%
%
function shp = cut(shp,x0,y0,r)
	fn     = fieldnames(shp);
	for idx=1:length(shp)
	n      = length(shp(idx).X);
	dx     = shp(idx).X - x0;
	dy     = shp(idx).Y - y0;
	D2     = dx.*dx + dy.*dy;
	fdx    = D2 < r*r;
	for jdx=1:length(fn)
		switch (fn{jdx})
		case {'Geometry'}
		case {'BoundingBox'}
		case {'Id'}
		otherwise
			if (length(shp(idx).(fn{jdx})) == n)
				shp(idx).(fn{jdx}) = shp(idx).(fn{jdx})(fdx);
			end
		end % switch fn
%		obj.X  = obj.X(fdx);
%		obj.Y  = obj.Y(fdx);
	end % for idx
end % Shp::cut

