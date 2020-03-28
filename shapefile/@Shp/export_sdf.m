% Di 22. Mär 17:57:04 CET 2016
% Karl Kastner, Berlin

function river = export_sdf(filename,river,cross,abstol)

DEFAULT.NVALUE = 0.03;
DEFAULT.z_bank = 100;

if (nargin() < 4)
	abstol = 1e2;
end
riverfield = 'River';
reachfield = 'Reach';

% dummy elevation at left and right bank
if (1)
% Mannings coefficient
for idx=1:length(cross)
	cross(idx).X = [cross(idx).X(1); cvec(cross(idx).X); cross(idx).X(end)];
	cross(idx).Y = [cross(idx).Y(1); cvec(cross(idx).Y); cross(idx).Y(end)];
	cross(idx).Z = [DEFAULT.z_bank; cvec(cross(idx).Z); DEFAULT.z_bank];
	if (~isfield(cross(idx),'NVALUE') || isempty(cross(idx).NVALUE) )
		cross(idx).NVALUE = DEFAULT.NVAVLUE;
	end
end
end % if 


river = Shp.remove_nan(river);
cross = Shp.remove_nan(cross);

fid = fopen(filename,'w');
if (fid <=0 )
	error('unable to open file');
end

% determine bounding box
box = NaN(1,4);
for idx=1:length(river)
	box(1) = min(min(river(idx).X),box(1));
	box(2) = min(min(river(idx).Y),box(2));
	box(3) = max(max(river(idx).X),box(3));
	box(4) = max(max(river(idx).Y),box(4));
end

% determine end points
point = struct();
point.X = river(1).X([1 end]);
point.Y = river(1).Y([1 end]);
point.id = [1 2];
for idx=2:length(river)
	X = river(idx).X([1 end]);
	Y = river(idx).Y([1 end]);
	for jdx=1:2
	d = hypot(point.X-X(jdx),point.Y-Y(jdx));
	[dmin idmin] = min(d);
	if (dmin > abstol)
		idmin = length(point.X) + 1';
		point.X(idmin) = X(jdx);
		point.Y(idmin) = Y(jdx);
	end
	point.id(idx,jdx) = idmin;
	end % for jdx		
end % for idx

% header
fprintf(fid,'#Dummy comment\r\n');
fprintf(fid,'\r\n');
fprintf(fid, 'BEGIN HEADER:\r\n');
fprintf(fid, '  UNITS: \r\n'); % METRIC
fprintf(fid, '  DTM TYPE: \r\n');
fprintf(fid, '  DTM: \r\n');
fprintf(fid, '  STREAM LAYER: \r\n');
fprintf(fid, '  CROSS-SECTION LAYER: \r\n');
fprintf(fid, '  MAP PROJECTION: \r\n');
fprintf(fid, '  PROJECTION ZONE: \r\n');
fprintf(fid, '  DATUM: %s\r\n',''); %datestr(now()));
fprintf(fid, '  VERTICAL DATUM: \r\n');
fprintf(fid, '  BEGIN SPATIALEXTENT:\r\n');
fprintf(fid, '    Xmin: %f\r\n',box(1));
fprintf(fid, '    Ymin: %f\r\n',box(2));
fprintf(fid, '    Xmax: %f\r\n',box(3));
fprintf(fid, '    Ymax: %f\r\n',box(4));
fprintf(fid, '  END SPATIALEXTENT:\r\n');
fprintf(fid, '  NUMBER OF PROFILES:  0 \r\n');
fprintf(fid, '  PROFILE NAMES: \r\n');
fprintf(fid, '  NUMBER OF REACHES: %d\r\n',length(river));
fprintf(fid, '  NUMBER OF CROSS-SECTIONS: %d \r\n',length(cross));
fprintf(fid, 'END HEADER:\r\n');
fprintf(fid,'\r\n');

fprintf(fid, 'BEGINSTREAMNETWORK:\r\n');
fprintf(fid,'\r\n');

% end points
for idx=1:length(point.X)
	fprintf(fid,'ENDPOINT: %f, %f,  ,%d\r\n',point.X(idx), point.Y(idx), idx);
end
fprintf(fid,'\r\n');

% Reaches
for idx=1:length(river)
	fprintf(fid, 'REACH:\r\n');
	stream_str = river(idx).(riverfield);
%	stream_str = regexprep(river(idx).(riverfield),'\s','');
	fprintf(fid, ' STREAM ID: %s\r\n',stream_str);
	reach_str = river(idx).(reachfield);
%	reach_str = regexprep(river(idx).(reachfield),'\s','');
 	fprintf(fid, ' REACH ID: %s\r\n',reach_str);
 	fprintf(fid, ' FROM POINT:  %d\r\n', point.id(idx,1));
	fprintf(fid, ' TO POINT: %d\r\n', point.id(idx,2) );
	fprintf(fid, ' CENTERLINE:\r\n');
	X = river(idx).X;
	Y = river(idx).Y;
	fprintf(fid, '%f, %f, ,\r\n',[rvec(X); rvec(Y)]);
 	fprintf(fid, ' END:\r\n');
	fprintf(fid, '\r\n');
end % for idx

fprintf(fid, 'ENDSTREAMNETWORK:\r\n');
fprintf(fid, '\r\n');

fprintf(fid, 'BEGIN CROSS-SECTIONS:\r\n');
fprintf(fid, '\r\n');

% cross sections
for idx=1:length(cross)

fprintf(fid,'CROSS-SECTION:\r\n');
fprintf(fid,'STREAM ID: %s\r\n', cross(idx).(riverfield));
fprintf(fid,'REACH ID: %s\r\n',     cross(idx).(reachfield));
	 S = cross(idx).S(1);
fprintf(fid,'STATION: %f\r\n',      S); % S-coordinate
fprintf(fid,'NODE NAME:\r\n');
fprintf(fid,'BANK POSITIONS: %f, %f\r\n', 0.0, 1.0); 	% only relevant for flood plains
	dS = cross(idx).dS(1);		
fprintf(fid,'REACH LENGTHS: %f, %f, %f\r\n',dS,dS,dS);	% dS, flow distance to next section (left overbank, channel, right overbank)
fprintf(fid,'NVALUES:\r\n');
	N = cross(idx).NVALUE(1);
%	l = length(rvec(cross(idx).X));
	fprintf(fid,'%f, %f\r\n',[0,0,1,1; N*[1 1 1 1]]);
%	fprintf(fid,'0, %f\r\n 0.5, %f\r\n 1.0, %f\r\n',N,N,N); 	% n-coordinate (0..1), mannings n (lob,channel,rob)
fprintf(fid,'LEVEE POSITIONS:\r\n');
fprintf(fid,'INEFFECTIVE POSITIONS:\r\n');		% areas without flow (islands)
fprintf(fid,'BLOCKED POSITIONS:\r\n');			% what is the difference to ineffective positions - storage?
fprintf(fid,'CUT LINE:\r\n');				% x and y coordinate of cross section points
	fprintf(fid,'%f, %f,\r\n',[rvec(cross(idx).X);rvec(cross(idx).Y)]);
fprintf(fid,'SURFACE LINE:\r\n');			% x,y,z : bed elevation ?
	fprintf(fid,'%f, %f, %f, \r\n',[rvec(cross(idx).X); rvec(cross(idx).Y); rvec(cross(idx).Z)]);

fprintf(fid,'END:\r\n');
fprintf(fid, '\r\n');

end % for idx

fprintf(fid, 'BEGIN STORAGE AREAS:\r\n');
fprintf(fid, '\r\n');
fprintf(fid, 'END STORAGE AREAS:\r\n');
fprintf(fid, '\r\n');

fclose(fid);

% eport g01
version='4.10';
name = filename(1:end-4);
filename = [name,'.g01'];
fid = fopen(filename,'w');
if (fid <=0 )                                                                   
        error('unable to open file');                                           
end
fprintf(fid,'Geom Title=%s\r\n',name);
fprintf(fid,'Program Version=%s\r\n',version);
% TODO
fprintf(fid,'Viewing Rectangle= 286034.5332157 , 458138.1264043 , 13917.67637668 ,-44828.99052068\r\n');
fprintf(fid,'\r\n');
for idx=1:length(river)
	fprintf(fid,'River Reach=%s,%s\r\n',river(idx).(riverfield),river(idx).(reachfield));
	X = river(idx).X;
	Y = river(idx).Y;
	n = length(X);
n
	fprintf(fid,'Reach XY= %d\r\n',n);
	for jdx=1:2:n
		fprintf(fid,' %16.6f%16.6f',X(jdx),Y(jdx));
		if (jdx+1 <= n)
			fprintf(fid,'%16.6f%16.6f\r\n',X(jdx+1),Y(jdx+1));
		end
	end % for jdx
end % for idx
fprintf(fid,'\r\n');

% cross sections
% TODO
fprintf(fid,'Rch Text X Y=413800.207835,5390.1290368\r\n');
fprintf(fid,'Reverse River Text= 0\r\n');
                
for idx=1:length(cross)
	S = cross(idx).S;
	dS = cross(idx).dS;
	fprintf(fid,'Type RM Length L Ch R = 1 ,%f,%f,%f,%f\r\n',cross(idx).S,dS(1),dS(1),dS(1));
	% cross section points
	X = cross(idx).X;
	Y = cross(idx).Y;
	Z = cross(idx).Z;
	L = cumsum([0;cvec(hypot(diff(X),diff(Y)))]);
	n = length(X);
	fprintf(fid,'XS GIS Cut Line=%d\r\n',n);
	for jdx=1:2:n
		fprintf(fid,' %16.6f%16.6f',X(jdx),Y(jdx));
		if (jdx+1 <= n)
			fprintf(fid,'%16.6f%16.6f\r\n',X(jdx+1),Y(jdx+1));
		end
	end % for jdx
	fprintf(fid,'\r\n');
	% TODO
	fprintf(fid,'Node Last Edited Time=Apr/10/2016 14:12:30\n\r');
	% elevation
	fprintf(fid,'#Sta/Elev= %d\r\n',length(Z));
	for jdx=1:length(Z)
		fprintf(fid,'%16.6f %16.6f',L(jdx),Z(jdx));
	end
	fprintf(fid,'r\n');
	% Manning's coefficient
	% TODO what does 2,-1,0 stand for?
	fprintf(fid,'#Mann= 2 ,-1 , 0\r\n');
	fprintf(fid,'       0   .0325       0   513.3   .0325       0\r\n');
	% cross section width
	fprintf(fid,'Bank Sta=%f,%f\r\n',0,L(end));
	% rating curve
	fprintf(fid,'XS Rating Curve= 0 ,0\r\n');
	% expansion and contraction coefficient
	fprintf(fid,'Exp/Cntr=0.3,0.1\r\n');
	fprintf(fid,'\r\n');
end % for idx		
	fprintf(fid,'Chan Stop Cuts=-1\r\n');
	fprintf(fid,'\r\n');
	fprintf(fid,'\r\n');
	fprintf(fid,'\r\n');

	fprintf(fid,'Use User Specified Reach Order=0\r\n');
	fprintf(fid,'GIS Units=\r\n');
	fprintf(fid,'GIS DTM Type=\r\n');
	fprintf(fid,'GIS DTM=\r\n');
	fprintf(fid,'GIS Stream Layer=\r\n');
	fprintf(fid,'GIS Cross Section Layer=\r\n');
	fprintf(fid,'GIS Map Projection=\r\n');
	fprintf(fid,'GIS Projection Zone=\r\n');
	fprintf(fid,'GIS Datum=\r\n');
	fprintf(fid,'GIS Vertical Datum=\r\n');
	% TODO
	fprintf(fid,'GIS Data Extents=287724.046775,-44140.761681,456236.824472,13087.37458\r\n');
	fprintf(fid,'\r\n');
	fprintf(fid,'GIS Ratio Cuts To Invert=-1\r\n');
	fprintf(fid,'GIS Limit At Bridges=0\r\n');
	fprintf(fid,'Composite Channel Slope=5\r\n');

fclose(fid);

end % export_sdf

