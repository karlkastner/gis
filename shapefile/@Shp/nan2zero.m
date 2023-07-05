% 2023-05-13 15:38:03.100662838 +0200
% Di 29. Sep 10:18:04 CEST 2015
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
%% replace not a number values with zeros, for writing to disk
%% NAN values are not allowed according to the spec
function shp = nan2zero(shp)
	f_C = fieldnames(shp);
	for field = rvec(f_C)
		x = [shp.(field{1})];
		if (isnumeric(x))
			x(~isfinite(x)) = 0;
			mydeal = @(x) deal(x{:});
			[shp.(field{1})] = mydeal(num2cell(x));
		end
	end
end

