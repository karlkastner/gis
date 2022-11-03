% Sat Mar 15 13:03:14 WIB 2014
% Karl Kastner, Berlin
%
%% export geometry file undestood by SLIM
%
% ofile      : ouput file name
% type       : [tri, quad]
% resolution : resampling distance of points on the mesh boundary
% varargin   : Mesh.Remove4Triangles
%
% TODO rename opt to gmshopt
function export_geo(shp, oname, resolution, mode, opt)
	attractor = false;

	if (nargin()<4)
		% TODO make field of opt
		mode = 'spline';
	end

	minres = resolution.min;
	maxres = resolution.max;

	% TODO, no magic numbers
	DistMin = minres;
	DistMax = 10*maxres;

	if (nargin() < 2 || isempty(oname))
		error('Output file name required'); 
	end

	if (nargin() < 3)
		resolution = [];
	end
	
	% open output file
	fid = fopen(oname,'w');
	if (-1 == fid)
		error(sprintf('Cannot open file %s for writing',ofile));
	end

	% segment intput elements
	seg_C = Shp.segment(shp);

	% number of points
	np  = 0;
	% number of loops and bsplines
	nl  = 0;
	% number of line loops
	nll = 0;
	% only the first polygon is exported
	seg = seg_C{1};
	X   = cvec(shp(1).X);
	Y   = cvec(shp(1).Y);
	if (isfield(shp,'resolution'))
		R = cvec(shp(1).resolution);
	else
%		if (isempty(resolution))
%			resolution = 0;
%		end
		R = repmat(resolution.default,length(X),1);
	end

	% for each segment
	for idx=1:size(seg,1)
		fdx = cvec(seg(idx,1):seg(idx,2));
		n  = length(fdx);
		% output
		if (n > 2)
		% remove duplicate end point
		if (X(fdx(1)) == X(fdx(end)) && Y(fdx(1)) == Y(fdx(end)))
			fdx = fdx(1:end-1);
			n = n-1;
		end
		
		% points
		if (isempty(R))
			fprintf(fid,'Point(%d) = {%f,%f,%f};\n',[np+(1:n)', X(fdx), Y(fdx), zeros(n,1)]');
		else
			fprintf(fid,'Point(%d) = {%f,%f,%f,%f};\n',[np+(1:n)', X(fdx), Y(fdx), zeros(n,1) R(fdx)]');
		end
		switch (lower(mode))
		case {'bspline','spline'}
			% multi resolution in a BSpline is tricky
			% splines
			put_bspline(fid,nl+1,np+1,np+n);
			% line-loop
			put_line_loop(fid,nll+1,nl+1,[]);
			nl = nl+1;
		otherwise
			% lines
			fprintf(fid,'Line(%d) = {%d, %d};\n',[nl+(1:n-1)', np+(1:n-1)', np+(2:n)']');
			% connect end pieces to form a loop
			fprintf(fid,'Line(%d) = {%d, %d};\n',[nl+n, np+n, np+1]);
			% line-loop
			put_line_loop(fid,nll+1,nl+1,nl+n);
			nl = nl+n;
		end % witch mode
		if (attractor)
			%field = struct();
			%field.id   = nll+1;
			%field.type = 'Attractor';
			%field.NNodesByEdge = nll+1;
			%field.EdgesList = 
			put_Field(fid,nll+1,'Attractor', ...
					'NNodesByEdge', n, ...
					'EdgesList', {np+1, np+n} );
		end
		if (isfield(opt,'bndlayer') && opt.bndlayer)
			h = R(fdx);
			for idx=1:n
				% h(d) = hwall * ratio^(d/hwall)
				id = idx+np;
				hmin = h(idx);
				hmax = maxres; %resolution.max;
				r    = resolution.ratio;
				thickness = hmin*(r*hmax/hmin-r)/(r-1);
				put_Field(fid,id,'BoundaryLayer', ...
					'NodesList', {id}, ...
					'FanNodesList', {id}, ...
					'hwall_n', h(idx), ...
					'hwall_t', h(idx), ...
					'ratio',   resolution.ratio,  ...
					'hfar',    maxres, ... %resolution.max, ...
					'thickness', thickness ...
					);
			end
		end % bndlayer
		np  = np+n;
		nll = nll+1;
		end
	end % for idx

	% surface
	fprintf(fid,'Plane Surface(%d) = {%d:%d};\n',1,1,nll);

	if (attractor)
		put_Field(fid,nll+1,'Threshold' ...
				,'IField',  (1:nll) ...
				,'LcMin',   minres ...
				,'LcMax',   maxres ...
				,'DistMin', DistMin ...
				,'DistMax', DistMax );
		fprintf(fid,'Background Field = %d;\n',nll+1);
	end

	if (isfield(opt,'bndlayer') && opt.bndlayer)
		put_Field(fid,np+1,'Min','FieldsList',1:np);
		fprintf(fid,'Background Field = %d;\n',np+1);
	end

	% optional options
	if (isfield(opt,'Remove4Triangles'))
		fprintf(fid,'Mesh.Remove4Triangles = %d;\n',opt.Remove4Triangles);
	end
	if (isfield(opt,'CharacteristicLengthExtendFromBoundary'))
		fprintf(fid,'Mesh.CharacteristicLengthExtendFromBoundary = %d;\n',opt.CharacteristicLengthExtendFromBoundary);
	end
	if (isfield(opt,'CharacteristicLengthFromPoints'))
		fprintf(fid,'Mesh.CharacteristicLengthFromPoints = %d;\n',opt.CharacteristicLengthFromPoints);
	end
	if (isfield(opt,'Recombine_Surface'))
		fprintf(fid,'Recombine Surface { %d };',opt.Recombine_Surface);
	end
	% del3d, front2d, meshadapt
	if (isfield_deep(opt,'Mesh.Algorithm'))
		fprintf(fid,'Mesh.Algorithm = %s;\n',opt.Mesh.Algorithm);
	end
	fclose(fid);
end % export_geo

function put_bspline(fid,nl,np1,npend)
	fprintf(fid,'BSpline ( %d ) = {%d:%d, %d};\n', nl, np1, npend, np1);
end

function put_line_loop(fid,nll,nl1,nlend)
	if (~isempty(nlend))
		fprintf(fid,'Line Loop(%d) = {%d:%d};\n', nll, nl1, nlend);
	else
		fprintf(fid,'Line Loop(%d) = {%d};\n', nll, nl1);
	end
end

function put_Field(fid,id,type,varargin)
	name = 'Field';
	fprintf(fid,'%s[%d] = %s;\n',name,id,type);
	for idx=1:2:length(varargin)
		fname = varargin{idx};
		fval  = varargin{idx+1};
		if (length(fval) < 2 && ~iscell(fval))
			fprintf(fid,'%s[%d].%s = %g;\n',name,id,fname,fval);
		else
			if (iscell(fval))
				fval = fval{1};
			end
			fprintf(fid,'%s[%d].%s = { %g',name,id,fname,fval(1));
			for jdx=2:length(fval)
				fprintf(fid,', %g',fval(jdx));
				if (1 == mod(jdx,8))
					fprintf(fid,'\n');
				end
			end
			fprintf(fid,'};\n');
		end
	end
end % put_Field


