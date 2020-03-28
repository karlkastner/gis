% Sun Mar 16 11:28:12 WIB 2014
% Karl Kastner, Berlin

% writes a polygone to a shapefile

function write_polygon(filename,X,Y,varargin)
	%mi = min(val);
	%ma = max(val);
	%val = round(99*(val-mi)/(ma-mi));
	n = size(X,1);
	s    = struct('Geometry',[], ...
		      'X',   [], ...
		      'Y',   [], ...
		      'id',  [] ...
			);
	cg   = repmat({'Polygon'},n,1); 
	cx   = num2cell(X);
	cy   = num2cell(Y);
	ci   = num2cell((1:n)');
	[s(1:n).Geometry] = deal(cg{:});
	[s(1:n).id]       = deal(ci{:});
	
	for idx=1:n
		s(idx).X = X(idx,:);
		s(idx).Y = Y(idx,:);
		%[s(1:n).X(:)] = deal(cx{:,:});
		%[s(1:n).Y] = deal(cy{:,:});
	end
	for idx=1:2:length(varargin)
		fieldname = varargin{idx};
		val = varargin{idx+1};
		fdx = find(~isfinite(val) | abs(imag(val))>0);
		% this is a fix, as qgis crashes for nan(null) values
		val(fdx) = 65535;
		cval   = num2cell(val);
		[s(1:n).(fieldname)] = deal(cval{:});
	end
	shapewrite(s, filename);
end % write_polygon

