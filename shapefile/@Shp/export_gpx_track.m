% Sun Jul 20 21:10:31 WIB 2014
% Karl Kastner, Berlin

%% export a data into a gpx track file

function export_gpx_track(shp,gpxname,name)
header = [
'<?xml version="1.0" encoding="UTF-8"?>\n' ...
'<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1" creator="Karl">\n' ...
'    <metadata>\n' ...
'        <time>2014-04-23T10:53:54Z</time>\n' ...
'    </metadata>\n' ];

%	shp = shaperead(shpname);

	if (nargin < 2)
		fid = 1;
	else
		fid = fopen([gpxname(1:end-4), '.gpx'],'w');
	end

	fprintf(fid,header);

        fprintf(fid,'    <trk>\n');
	tdx=1;
	if (nargin > 2)
       		fprintf(fid,'      <name>%s</name>\n',name);    
	else
       		fprintf(fid,'      <name>Track %d</name>\n',tdx);    
	end                                  
	%tdx=1;
	% TODO for some reasons shaperead reads old segments
	% 1
	for idx=1:length(shp)
        	fprintf(fid,'        <trkseg>\n');
		lon = shp(idx).X;
		lat = shp(idx).Y;
		for jdx=1:length(lat)
			if (isnan(lon(jdx)*lat(jdx)))
        			fprintf(fid,'        </trkseg>\n');
			        fprintf(fid,'    </trk>\n');
			        fprintf(fid,'    <trk>\n');
			        %tdx = tdx+1;
				%fprintf(fid,'      <name>Track %d</name>\n',tdx);                                      
        			fprintf(fid,'        <trkseg>\n');
			else
	            		fprintf(fid,'            <trkpt lon="%f" lat="%f" >\n',lon(jdx),lat(jdx));
        	        	%fprintf(fid,'                <time>2014-04-23T08:48:12Z</time>\n');
                		%fprintf(fid,'                <time>%sT00:00:00Z</time>\n',datestr(tdx,'yyyy-mm-dd'));
            			fprintf(fid,'            </trkpt>\n');
				%tdx=tdx+1;
			end
		end
        	fprintf(fid,'        </trkseg>\n');
	end
        fprintf(fid,'    </trk>\n');
	fprintf(fid,'</gpx>\n');
	if (1 ~= fid)
		fclose(fid);
	end
end % shp2gpx_track

