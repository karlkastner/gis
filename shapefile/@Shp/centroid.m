% 2023-05-13 12:40:26.360300410 +0200
% Karl Kastner, Berlin
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
% TODO treat holes
function [cx,cy] = centroid(shp)
	n = length(shp);
	cx = NaN(n,1);
	cy = NaN(n,1);
	for idx=1:length(shp)
		if (isnan(shp(idx).X(end)))
			% TODO check identity of first and last point
			[cx(idx),cy(idx)] = Geometry.centroid(shp(idx).X(1:end-1),shp(idx).Y(1:end-1));
		else
			[cx(idx),cy(idx)] = Geometry.centroid(shp(idx).X,shp(idx).Y);
		end
	end
	if (nargout()<2)
		cx = [cx,cy];
	end
end

