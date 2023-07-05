% Mon  3 Jul 15:28:53 CEST 2023
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
%% write geospatial image and pgw to disk
function out = write(obj,filename)
	pgwname = [filename(1:end-4),'.pgw'];
	imwrite(obj.img,filename);

	fid = fopen(pgwname,'w');
	for idx=1:length(obj.pgw) % 6 fields
		fprintf(fid,'%f\n',obj.pgw(idx));
	end
	fclose(fid);
end
	
