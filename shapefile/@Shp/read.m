% Wed 25 May 12:16:46 CEST 2016
% Karl Kastner, Berlin
%obj = split_lines(obj)
function shp = read(in)
	switch (class(in))
	case {'char'}
		filename = in;
		shp = shaperead(filename);
	case {'struct'}
		shp = in;
	otherwise
		error('in must be either a file name or a shp struct');
	end
end % read

