% Sat Jun 28 17:43:35 WIB 2014
% Karl Kastner, Berlin
%
%% crop input shape file to specified polygon
%	resolution = 1;
% TODO this assumes a single polygon for clip
% function outshp = clip(inshp, clip, invert)
function outshp = clip(inshp, clip, invert)
	if (nargin() < 3)
		invert = false;
	end
	clip = clip(1);	

	outshp = struct('X',[],'Y',[]);
	
	% split elements
	inshp = Shp.split_nan(inshp);

	% for each segment, decide, whether it is inside, outside, or cut by the clip polygon
	jdx = 0;
	tic_    = tic();
	tlast   = 0;
	for idx=1:length(inshp)

		% select points within polygon
		flag = Geometry.inPolygon(clip.X,clip.Y,inshp(idx).X,inshp(idx).Y);
		if (invert)
			flag = ~flag;
		end
	
		% state machine
		state = 'start';
		x1 = [];
		y1 = [];
		for fdx=1:length(flag)
			if (toc(tic_) > tlast+10)
				[idx/length(inshp),double(fdx)/length(flag),tic]
				tlast = toc(tic_);
			end
			switch (state)
			case {'start'} % last state was start
			if (0 == flag(fdx))
				state = 'out';
			else
				state = 'in';
				start = 1;
			end
			case {'out'}
			% test if the polygon has entered the clip region
			if (1 == flag(fdx))
	% TODO, the part of the clip has to be inserted as well
	%			if (fdx > 1)
	%				% find a new connection point to the outer boundary
	%        	                d2 =   (x_ - inshp(idx).X(fdx)).^2 ...      
	%                	             + (y_ - inshp(idx).Y(fdx)).^2;                 
	%                        	[mv mdx] = min(d2);
	%	                        x1=x_(mdx);                        
	%        	                y1=y_(mdx);   
	%			else
					x1 = inshp(idx).X(fdx);
					y1 = inshp(idx).Y(fdx);
	%			end
				% update state
				state = 'in';
				start = fdx;
			end % if 1 == flag
			case {'in'}
			% test if the polygon has left the clip region
			if (0 == flag(fdx))
				% this is a cut, flush the chain
				jdx = jdx+1;
				outshp(jdx).X = [x1; cvec(inshp(idx).X(start:fdx-1))];
				outshp(jdx).Y = [y1; cvec(inshp(idx).Y(start:fdx-1))];
				% find the shortest connection to the outer boundary
	%			d2 =   (x_ - outshp(jdx).X(end)).^2 ...
	%			     + (y_ - outshp(jdx).Y(end)).^2;
	%			[mv mdx] = min(d2);
	%			outshp(jdx).X(end+1)=x_(mdx);
	%			outshp(jdx).Y(end+1)=y_(mdx);
				state = 'out';
			end % if 0 == flag
			end % switch
		end % for fdx
		% flush the tail
		if (strcmp(state,'in'))
			jdx=jdx+1;
			outshp(jdx).X = [x1; cvec(inshp(idx).X(start:end))];
			outshp(jdx).Y = [y1; cvec(inshp(idx).Y(start:end))];
		end % if
	end % for idx

%clf
		in = Shp.cat(inshp,NaN);
		out = Shp.cat(outshp,NaN);
		in = inshp;
%		Shp.plot(clip);
%		hold on
%		Shp.plot(in);
%		Shp.plot(out);
%		plot(inshp(idx).X,inshp(idx).Y);
%		plot(inshp(idx).X(flag),inshp(idx).Y(flag),'g');
%pause


	% add sea boundary
%	jdx=jdx+1;
%	outshp(jdx).X = x_;
%	outshp(jdx).Y = y_;
	% TODO, use shp_create
%	outshp = Shp.cat(outshp,NaN);

	outshp = rmfield_optional(outshp,'id');
	outshp = rmfield_optional(outshp,'jd');
	%outshp = rmfield(outshp,'refinement');
	if (isfield(inshp,'Geometry'))
		outshp = Shp.set_geometry(outshp,inshp(1).Geometry);
	end
end % clip

