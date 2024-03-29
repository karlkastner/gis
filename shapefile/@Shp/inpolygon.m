% Mon 12 Oct 12:50:33 +08 2020
% Karl Kastner, Berlin
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
%% test if point is in any of the polygons
%
%function in = inpolygon(shp,x0,y0)
function in = inpolygon(shp,x0,y0)
	shp = Shp.remove_nan(shp);
	in = zeros(size(x0));
	for idx=1:length(shp)
		xp = shp.X;
		yp = shp.Y;
		flag = Geometry.inPolygon(shp(idx).X,shp(idx).Y,x0,y0);
		in(flag) = idx;
%		if (flag)
%			in = idx;
%			break;
%		end
	end
end
