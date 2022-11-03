% 2014-04-10 19:21:52.475930888 +0700
% Karl Kastner, Berlin 
%
%% create a new shapefile with given geometry
%
% function s = create(varargin)
 function s = create(varargin)
	%s = struct('Geometry',[],'X',[],'Y',[]);
	% D.WGS84_lat = -0.38212;
	% D.WGS84_lon = 109.51927;
	%[X Y] = deg2utm(obj.interp.lat(obj.sdx), obj.interp.lon(obj.sdx));
	% correction for southern hemisphere
	%Y = Y + 1e7;
	s = struct();
	%c = repmat({'Point'},n,1);
	%[s(1:n).Geometry] = deal(c{:});
	if (0 == strcmp('geometry',lower(varargin{1})))
		error('first argument must provide geometry');
	end
	geometry = varargin{2};
	switch(lower(geometry))
	case {'point'}
	n = length(varargin{4});
	[s(1:n).Geometry] = deal('Point');
	for idx=3:2:length(varargin)
		fieldname = varargin{idx};
		if (~isstr(fieldname))
			error('field name must be as string');
		end
		fieldval  = varargin{idx+1};
		if (strcmp(class(fieldval),'single'))
			fieldval = double(fieldval);
		end
		if (1==idx)
			n = length(fieldval);
		else
			if (length(fieldval) ~= n)
				error(sprintf('field %s is not of length %d (%d)',fieldname,n,length(fieldval)));
				%disp(fieldname);
				%error('field value vectors must be of equal length');
			end
		end
		c = num2cell(fieldval);
		[s.(fieldname)] = deal(c{:});
	end
	case {'line', 'polygon'}
		val = varargin{4};
		if (iscell(val))
			n = length(varargin{4});
		else
			n = 1;
		end
		for jdx=1:n
			s(jdx).Geometry = geometry;
		end
		for idx=3:2:length(varargin)
			fieldname = varargin{idx};
			fieldval  = varargin{idx+1};
			if (iscell(fieldval))
				for jdx=1:n
					s = set(s,jdx,fieldname,fieldval{jdx});
				end % for jdx
			else
				s = set(s,1,fieldname,fieldval);
			end % if iscell
		end % for idx
	otherwise
		error('unknown geometry');
	end
end % export_shp

function shp = set(shp,jdx,fieldname,fieldval)
	if (~isstr(fieldname))
		error('Field name must be as string');
	end
	if (strcmp(class(fieldval),'single'))
		fieldval = double(fieldval);
	end
	shp(jdx).(fieldname) = fieldval;
end

