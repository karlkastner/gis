% Sat Jun 28 13:56:51 WIB 2014
% Karl Kastner, Berlin
%
%% concatenate line segments (parts) of shp data files into one
%% same as single part to multipart in qgis
%% returns also indices into the original file
%
function s = cat(shp,separator)
	if (nargin() < 2)
		separator = NaN;
	end

	% concatenate line segments
%	s = struct('X',[],'Y',[],'id',[],'jd',[]);
	% TODO resolve id name conflict
	s = struct('Id',[],'jd',[]);
	f = fieldnames(shp)

	% copy first element of input shp to output shp
	for idx=1:length(f)
		% preserve geometry but not bounding box
		if ( ... %~strcmp(f{idx},'Geometry') && ...
                        ~strcmp(f{idx},'BoundingBox'))
			n = length(shp(1).X);
			if (length(shp(1).(f{idx})) == n)
				s.(f{idx}) = rvec(shp(1).(f{idx}));
			else
				warning(['skipping field ', f{idx}]);
			end
		end
	end

	% concatenate remaining elements of input shp to output shp
	for idx=2:length(shp)
		n = length(shp(idx).X);
		for jdx=1:length(f)
			if (~strcmp(f{jdx},'Geometry') ...
			     && ~strcmp(f{jdx},'BoundingBox'))
			if (length(shp(idx).(f{jdx})) == n)
				s.(f{jdx}) = [s.(f{jdx}), separator, rvec(shp(idx).(f{jdx}))];
			end
			end % if
		end % for jdx
		s.Id(end+(1:n),1) = idx;
		s.jd(end+(1:n),1) = (1:n)';
	end % for idx

	% concatenate separator to the end
	if (~isnan(s.X(end)) && ~isempty(separator))
		s.X(end+1) = separator;
		s.Y(end+1) = separator;
	end
end % Shp::cat

