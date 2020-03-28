% Sun Jul 27 21:33:25 WIB 2014
% Karl Kastner, Berlin
classdef GPX < handle
	properties
		fh
		footer = ['</gpx>'];
	end
	methods
		function obj = open(obj,filename)
			obj.fh  = fopen(filename,'w');
			if (-1 == obj.fh)
				error();
			end

			header = fileread('header.gpx');

			fprintf(obj.fh,'%s\n',header);
		end % open

		function obj = close(obj)
			fprintf(obj.fh,'%s\n\n',obj.footer);
			fclose(obj.fh);
		end

		function write_wpt(obj,lat,lon,ele,timestr,name,cmt)
			fprintf(obj.fh,'<wpt lat="%f" lon="%f">\n',lat,lon);
			if (~strcmp(ele,'NaN'))
				fprintf(obj.fh,'\t<ele>%f</ele>\n',ele);
			end
			if (~strcmp(timestr,'NaN'))
				fprintf(obj.fh,'\t<time>%s</time>\n',timestr);
			end
			fprintf(obj.fh,'\t<name>%s</name>\n',name);
			if (~strcmp(cmt,'NaN'))
				fprintf(obj.fh,'\t<cmt>%s</cmt>\n',cmt);
			end
			fprintf(obj.fh,'\t<sym>Flag, Blue</sym>\n');
			fprintf(obj.fh,'</wpt>\n');
		end % write_wpt
		
	end % methods
end % classdef GPS

