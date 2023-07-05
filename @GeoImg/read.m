% Wed 18 May 13:49:09 CEST 2022
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
%% read geospatial image and pgw from disk and
function obj = read(obj,filename)
	[obj.img, obj.map, obj.alpha] = imread(filename);
	pgwname = [filename(1:end-4),'.pgw'];
	% Try to load pgw from file
	try 
	obj.pgw = csvread(pgwname);
	catch e
		disp('Unable to read pgw file, assuming pixel size of 1 m x 1 m')
		obj.pgw = [1,0,1,0,0,0]';
	end
end
	
