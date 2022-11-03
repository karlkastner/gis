% Mi 2. Dez 12:11:32 CET 2015
% Karl Kastner, Berlin

%% export poly-file understood by SLIM
function export_poly(shp,filename)
	fid = fopen(filename,'w');
	if (-1 == fid)
		error('cannot open file');
	end
	if (length(shp) > 1)
		printf('merging multi-feature shapefile');
		shp=Shp.cat(shp,NaN);
	end

	seg_C = Shp.segment(shp);
	seg_C = seg_C{1};

	% put points
	X = shp.X;
	Y = shp.Y;

	% count points and edges
	np = 0;
	for idx=1:size(seg_C,1)
		seg = seg_C(idx,1):seg_C(idx,2);
		np = np + length(seg)-1;
	end
	fprintf(fid,'%d 2 0 0\n',np);

	% number of edges equals number or points
	ne = np;

	% print points
	np = 0;
	for idx=1:size(seg_C,1)
		seg = seg_C(idx,1):seg_C(idx,2);
		for jdx=1:length(seg)-1
			np = np+1;
			fprintf(fid,'%d %f %f\n',np,X(seg(jdx)),Y(seg(jdx)));
		end
	end

	% print number of edges
	fprintf(fid,'%d\n',ne);

	% print edges
	np = 1;
	for idx=1:size(seg_C,1)
		seg = seg_C(idx,1):seg_C(idx,2);
		np1 = np;
		for jdx=1:length(seg)-2
			fprintf(fid,'%d %d %d\n',np,np,np+1);
			np = np+1;
		end
		% last edge
		fprintf(fid,'%d %d %d\n',np,np,np1);
		np = np+1;
	end

	% number of holes
	nh = size(seg_C,1)-1;
	fprintf(fid,'%d\n',nh);

	% put holes
	for idx=nh
		
	end

	% put centroid as hole
	for idx=1:nh
		seg = seg_C(idx+1,1):seg_C(idx+1,2);
		% get bounding box
		xmin = min(X(seg));
		xmax = max(X(seg));
		ymin = min(Y(seg));
		ymax = max(Y(seg));
		[cx cy] = Geometry.centroid(cvec(shp.X(seg)),cvec(shp.Y(seg)));
		%hile (~inpolygon(X(seg(1:end-1)),Y(seg(1:end-1)),cx,cy))
		while(~Geometry.inPolygon(X(seg),Y(seg),cx,cy))
			% choose a random point within that box
			cx = xmin + (xmax-xmin)*rand()
			cy = ymin + (ymax-ymin)*rand()
			clf
%			Shp.plot(shp);
%			plot(X(seg),Y(seg))
%			hold on
%			plot(cx,cy,'o')
%			pause
		end
%			clf
%			plot(X(seg),Y(seg))
%			hold on
%			plot(cx,cy,'o')
%			pause
		fprintf(fid,'%d %f %f\n',idx,cx,cy);
	end
	fprintf(fid,'\n');
	fclose(fid);
end % export_poly

