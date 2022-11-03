% Do 24. Sep 17:35:39 CEST 2015
% Karl Kastner, Berlin

%% export splines (for D3D?)
% TODO close splines
function export_spline(shp,oname,max_chunk)
	% NOTE: 999.999 does not round to a binary digit!!!
	% take care that error values are not perturbed!!!
	errval = 999.999;
	format = ' %12.10e %12.10e\n';

	% read input file
%	shp = shaperead(shpname);
%	[X Y] = utm2latlon(X, Y, '49M');
	if (nargin() < 3)
		max_chunk = 1e12;
	end

	% open output file
	fid = fopen(oname,'w');
	if (-1 == fid)
		error(['Cannot open file ', splname, ' for writing']);
	end
	% header
	fprintf(fid,'*\n');
	fprintf(fid,'*\n');
	cdx=1;
	% account for overlap
	max_chunk = max_chunk-1;
	for idx=1:length(shp)
		X = shp(idx).X(:);
		Y = shp(idx).Y(:);
		% remove invalid points
		fdx = isnan(X) | isnan(Y);
		X(fdx) = [];
		Y(fdx) = [];
		n = length(X);

		if (n < 2)
			% skip short segments
			continue;
			%error('lines must consist of at least 2 points');
		end

		% if there is an uneven split, the first chunk takes the
		% residual
		n_chunk = max_chunk;
		m_chunk = floor(n/n_chunk);
		n_first = n-m_chunk*n_chunk;
		if (n_first < 2)
			n_first = n_first + n_chunk;
			m_chunk = m_chunk - 1;
		end
%		m_chunk = ceil(n/max_chunk);
%		n_chunk = max(2,max_chunk);	
%		n_chunk = round(n/m_chunk);
		% first chunk
			% spline index
			fprintf(fid,'   S%04d\n',cdx);
			% spline length
			fprintf(fid,' %d %d\n',n_first,2);
			% point coordinates
			fprintf(fid,format, ...
					[X(1:n_first), ...
					 Y(1:n_first)]');
			cdx = cdx+1;

		% remaining chunks
		for jdx=2:m_chunk
			% spline index
			fprintf(fid,'   S%04d\n',cdx);
			% spline length
			fprintf(fid,' %d %d\n',n_chunk+1,2);
			% point coordinates
			fprintf(fid,format, ...
					[X(n_first+(jdx-2)*n_chunk:n_first+(jdx-1)*n_chunk), ...
					 Y(n_first+(jdx-2)*n_chunk:n_first+(jdx-1)*n_chunk)]');
			cdx = cdx+1;
		end

%		% last chunk
%		if (m_chunk > 1)
%			% spline index
%			fprintf(fid,'   S%04d\n',cdx);
%			% spline dimension
%			fprintf(fid,' %d %d\n',n-n_chunk*(m_chunk-1)+1,2);
%			% point coordinates
%			fprintf(fid,format,[X((m_chunk-1)*n_chunk:end) ...
%					    Y((m_chunk-1)*n_chunk:end)]');
%			cdx = cdx+1;
%		end
	end % for idx
	% close output file
	if (-1 == fclose(fid))
		error(['Cannot close file ', splname]);
	end
end % function shp2spl

