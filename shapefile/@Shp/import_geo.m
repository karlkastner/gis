% Di 22. Dez 11:45:13 CET 2015
% Karl Kastner, Berlin
%
% import geo file
%
% ofile      : ouput file name
% type       : [tri, quad]
% resolution : resampling distance of points on the mesh boundary
% varargin   : Mesh.Remove4Triangles
function shp = import_geo(filename)

	bufsize = 256*65536;
	line_C = textread(filename, '%s', 'delimiter', '\n','bufsize',bufsize);
	id = {};
	ll = 0;
	for idx=1:length(line_C)
		line = line_C{idx};
		% remove spaces
		line =  strrep(line,' ','');

		% get head of line
		n = regexp(line,'(*')-1;

		switch (line(1:n))
		case {'Point'}
			[A c err] = sscanf(line,'Point(%d) = {%f,%f,%f,%f}');
			% put the point
			P(A(1),1:c-2) = A(2:c-1);
		case {'BSpline'}
			% TODO read lines and not only splines
			% TODO at the moment no differentiation between lines and line loops
	
			% remove head and tail
			line   = regexprep(line,'.*{','');
			line   = regexprep(line,'}.*','');
			line   = regexprep(line,'[^0-9,:]','');
			token_C = strsplit(line,',')
			id_    = [];
			for idx=1:length(token_C)
				[range c err]  = sscanf(token_C{idx},'%d:%d');
				if (2 == c)
					id_ = [id_, range(1):range(2)];
				else
					id_(end+1) = str2num(token_C{idx});
				end
			end
			ll = ll+1;
			id{ll} = id_;
			%id{ll} = sscanf(line,'%d,');
		end % switch
	end % put lines
	
	shp = struct('X',{},'Y',{});
	for idx=1:length(id)
		shp(idx).X = P(id{idx},1);
		shp(idx).Y = P(id{idx},2);
	end % idx
end % import_geo

