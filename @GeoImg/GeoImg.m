% Mon  3 Jul 15:46:37 CEST 2023
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
%% loading, manipulation and writing of geospacial images with world file
%
classdef GeoImg < handle
	properties
		img
		map
		alpha
		pgw	
	end
	methods
	% A    D  B   -E C F
	% wc ws   hs hc
	function siz = size(obj)
		siz = size(obj.img);
	end
	function dxy = dxy(obj)
		dxy   = [hypot(obj.pgw(1),obj.pgw(2)),hypot(obj.pgw(3),obj.pgw(4))];
	end
	function angle = angle(obj)
		dxy   = obj.dxy;
		angle = -pi/2+atan2(obj.pgw(1)/dxy(1),obj.pgw(2)/dxy(2));
	end
	function xy0 = xy0(obj)
		xy0 = obj.pgw(5:6);
	end
	% TODO rotation
	function x = x(obj)
		xy0 = obj.xy0;
		dxy = obj.dxy();
		n = obj.size();
		x = xy0(1) + (0:n(2)-1)*dxy(1);
	end
	function y = y(obj)
		xy0 = obj.xy0;
		dxy = obj.dxy();
		n = obj.size();
		y = xy0(2) - (0:n(1)-1)*dxy(2);
	end
	%x = pgw.xy0(1) + (0:n(2)-1)*pgw.dxy(1);
	%y = pgw.xy0(2) - (0:n(1)-1)'*pgw.dxy(2);
	end
end

