% 2015-10-28 21:23:48.384681075 +0100
% Karl Kastner, Berlin
%
%% set resolution for mesh generation
%
% input:
%	shp : polygon, resolution is set for each point of the polygon
%       res_s : struct with default resolution parameter
%	resfile_C  : file names, files contain polygons and parameters to be set within the polygons
% output:
%	shp: polygon, with set geometry
%
% TODO relative values conflict with global scale
function shp = set_resolution(shp,res_s,resfile_C)
	if (nargin() < 3)
		resfile_C = {};
	end

	% for each point, set default res, minres, maxres
	n        = length(shp.X);
	res      = (1/res_s.scale)*res_s.default * ones(n,1);
	nw       = res_s.scale*res_s.nw          * ones(n,1);
	minres   = (1/res_s.scale)*res_s.min     * ones(n,1);
	maxres   = (1/res_s.scale)*res_s.max     * ones(n,1);
	auto     = logical(double(res_s.auto)*true(n,1));

	% read resolution from files and apply
	for idx=1:length(resfile_C)
		region = Shp.read(resfile_C{idx});
		% if resolution is determined from polygon
		for jdx=1:length(region)
		switch (region(jdx).Geometry)
		case {'Polygon'}
			in   = Geometry.inPolygon(region(jdx).X,region(jdx).Y,shp.X,shp.Y);
		case {'Point'}
			% set resolution of nearest neighbour
			in = knnsearch([cvec(shp.X),cvec(shp.Y)],[cvec(region(jdx).X) cvec(region(jdx).Y)]);
		otherwise
			error('here');
		end
		if (isfield(region(jdx),'invert') && region(jdx).invert)
			in = ~in;
		end

			fieldname_C = fieldnames(region(jdx));
			for field = rvec(fieldname_C)
				switch (field{1})
				case {'minres'}
					minres(in) = region(jdx).minres;
				case {'maxres'}
					maxres(in) = region(jdx).maxres;
				case {'res'}
					res(in)    = region(jdx).res;
				case {'relminres'}
					minres(in) = region(jdx).relminres*minres(in);
				case {'relmaxres'}
					maxres(in) = region(jdx).relmaxres*maxres(in);
				case {'relres'}
					res(in)    = region(jdx).relres*res(in);
				case {'auto'}
					auto(in)   = region(jdx).auto;
				case {'X','Y','Geometry'}
					% do not display skip information
				otherwise
					fprintf('Skipping field %s\n',field{1});
				end % switch field
			end % for idx

		if (0)
			res     = Shp.read(resopt);
			res 	= Shp.cat(res,[]);
			interp  = TriScatteredInterp([cvec(res.X),cvec(res.Y)], ...
						log(cvec(res.resolution)),'linear');
			shp.resolution = minres*exp(interp([cvec(shp.X),cvec(shp.Y)]));
			fdx     = isnan(shp.resolution);
			[k dis] = knnsearch([cvec(shp.X(~fdx)), cvec(shp.Y(~fdx))], ...
						[cvec(shp.X(fdx)),cvec(shp.Y(fdx))]);
			shp.resolution(fdx) = min(maxres,minres*exp(dis/lengthscale));
		end
		end % for jdx each feature
	end % for idx each input file

	% apply global scales
	% TODO

	% set values
	shp.resolution = res;
	shp.minres     = minres;
	shp.maxres     = maxres;
	shp.auto       = auto;
end % set_resolution

