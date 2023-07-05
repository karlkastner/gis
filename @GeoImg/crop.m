% Mon  3 Jul 15:33:04 CEST 2023
% Karl Kästner, Berlin
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
%% cropt the image and modify the pgw accordingly
function obj2 = geoimg_crop(obj,i0,j0,h,w)    
	obj2 = GeoImg();
	pgw = obj.pgw;
	obj2.img = obj.img(i0+(0:h-1),j0+(0:w-1),:);

	obj2.pgw = pgw;
	x0 = pgw(5) + (j0-1)*pgw(1) + (i0-1)*pgw(3);
	y0 = pgw(6) + (j0-1)*pgw(2) + (i0-1)*pgw(4);
	obj2.pgw(5) = x0;
	obj2.pgw(6) = y0;
end

