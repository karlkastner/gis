% Sat Mar  8 00:04:28 WIB 2014
% Karl Kastner, Berlin

function gps = read_gpx(filename,UTM_ZONE)
	eflag = 0;
	gps = [];
	n=0;
	try
		xml = xmlread(filename);
	catch	err
		disp(err);
		disp(['error reading file ' filename]);
		return;
	end
	wpt = xml.getElementsByTagName('wpt');
	
	for idx=0:wpt.getLength()-1
		n = n+1;
		%wpt lat="-0.456718" lon="109.368340
		gps.lat(n)  = str2num(char(wpt.item(idx).getAttribute('lat')));
		gps.lon(n)  = str2num(char(wpt.item(idx).getAttribute('lon')));
		[gps.utm.X(n) gps.utm.Y(n)] = latlon2utm(gps.lat(n),gps.lon(n),UTM_ZONE);
		try
			gps.timestr{n} = strtrim(char(wpt.item(idx).getElementsByTagName('time').item(0).item(0).getData));
			gps.time(n)   = datenum(gps.timestr{n},'yyyy-mm-ddTHH:MM:SS');
		catch
			gps.timestr{n} = NaN;
			gps.time(n) = 0; % datestr fails for NaN
		end
		try
		gps.ele(n) = str2num(char(wpt.item(idx).getElementsByTagName('ele').item(0).item(0).getData));
		catch
		gps.ele(n) = NaN;
		end
		try
		gps.name{n} = strtrim(char(wpt.item(idx).getElementsByTagName('name').item(0).item(0).getData));
		catch
		gps.name{n} = NaN;
		end
		try
		gps.cmt{n} = strtrim(char(wpt.item(idx).getElementsByTagName('cmt').item(0).item(0).getData));
		catch e
		if (eflag)
			e
			pause
		end
		gps.cmt{n} = NaN;
		end
	end % for idx (each waypoint)
end % read_gpx()

