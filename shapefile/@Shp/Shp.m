% Di 29. Sep 10:18:04 CEST 2015
% Karl Kastner, Berlin

classdef Shp
	properties
	end % properties
	methods (Static)	
	    [shp,fdx] = remove_leaves(shp,dmax,n);
	    l = length(shp);
	    shp = generate_four_colour_index(shp,thresh);
	    [out seg_id] = flat(shp);
	    [a, shp] = area(shp);
	    shp = scale(shp,scale);
	    s = connect_network(s);
	    shp   = remove_polygon_closure(shp);
	    [X,Y] = first_point(shp,d);
	    [X,Y] = last_point(shp);
	    [l]   = length2(shp)
	    shp = export_geo(shp, oname, resolution, type, mode, splitflag, varargin);
	    [X,Y,bnd] = edges(shp);
	    shp = export_poly(shp,filename);
	    shp = export_spline(shp,oname,max_chunk);
	    shp = export_gpx_track(shp,gpxname,name);
	    shp = line2point(shp);
	    shp = extract_coastline(shp,lmin);
	    shp = export_gpx(filename, latlonflag);
	    shp = points(shp);
	    plot(shp,varargin);
	    seg = segment(shp);
	    shp = cat(shp,separator);
	    shp = concat(shp,shp2);
	    shp = resample_min(shp,dS_min);
	    shp = padd_nan(shp);
%	    shp = resample_width(shp,resolution,resfile_C,scale);
	    shp = set_resolution(shp,res_s,resfile_C);
	    shp = contour(shp);
	    cp(iname,onmae);
	    shp = import_poly(iname);
	    shp = close_polygon(shp);
	    shp = create(varargin);
	    shp = skip(shp,l);
	    shp = clip(inshp,clipshp,invert);
	    shp = clip_rect(shp,xmin,ymin,xmax,ymax);
	    shp = curvature(shp);
	    shp = cut(shp,x0,y0,r);
	    shp = cut_coast_line(shp, r, x0, y0, ds);
	    shp = diameter(shp);
	    shp = export_ldb(shp,ldbname,twoutm);
	    shp = export_sdf(filename,river,cross,tol);
	    shp = import_geo(filename);
	    shp = link_lines(shp);
	    shp = join_lines(shp,dmax);
	    shp = make_clockwise(shp);
	    shp = merge2(shp1,shp2,dmax);
	    shp = read(in);
	    shp = readZ(in,geometry);
	    shp = remove_duplicate_points(shp);
	    shp = remove_nan(shp);
	    shp = remove_short_elements(shp,n);
	    shp = renumber(shp);
	    shp = resample(shp,resolution,skipflag);
	    shp = resample_2(shp,resolution);
	    shp = resample_quick(shp,resolution);
	    shp = select_for_refinement(shp, Xc, Yc, R, ratio);
	    shp = set_geometry(shp,geometry);
	    shp = smooth(shp,cmax);
	    shp = split_jump(shp,rmax);
	    shp = split_nan(in);
	    shp = swap_hemisphere(shp);
	    shp = translate(shp,x0,y0);
	    write(shp,filename);
	end % methods (STATIC)
	methods
	    function shp = Shp(shp)
		if (isstr(shp))
			shp = Shp.read(shp);
		end
            end % constructor
	end % methods
end % class SHP

