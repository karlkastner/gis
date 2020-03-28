 % 2014-05-24 21:49:41.188487531 +0700
% Karl Kastner, Berlin

% note: lowrance devices requires small letter colours or no space before colour

% TODO export name (aux fields) if shp is of type points

function export_gpx(in, obase, latlonflag)
	if (ischar(in))
		shp   = shapereadZ(in);
	else
		shp = in;
		iname = datestr(now(),'yyyy-mm-dd-hh-ss');
	end
	if (nargin() < 2 || isempty(obase))
		obase = regexprep(iname,'\..*','');
	end

	% '49M' or 49N?
	if (nargin() < 3 || ~latlonflag)
		[lat lon] = utm2latlon([shp.X]', [shp.Y]', shp.zone);
	else
		lat = [shp.Y]';
		lon = [shp.X]';
	end
	tmpnam = tempname();
	fid    = fopen(tmpnam,'w');
	if (~isfield(shp,'id'))
		for idx=1:length(shp)
			shp(idx).id = idx;
		end
	end
	fprintf(fid,'%f %f %f %d\n',[lat lon zeros(size(lat)) [shp.id]']');
	fclose(fid);

	% get path to class folder
	w = what('Shp');
	p = w.path;
	system(['perl ', p, filesep(), 'generate_waypoint.pl < ',tmpnam,' > ',obase,'.gpx']);
	%system(['perl ',ROOTFOLDER,filesep(),'src/map/generate_waypoint.pl < /tmp/save.txt > ',base,'.gpx']);
end

