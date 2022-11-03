% Wed 30 May 08:56:42 CEST 2018
% TODO convert removed triangles to 1D reaches
function [shp,mesh] = extract_coastline(shp,lmin)

	[X,Y,bnd] = Shp.edges(shp);
	P         = [X,Y];
	
	% constrained delaunay triangulation
	% TODO use mmesh
	dT = delaunayTriangulation(P,bnd);
	% select only triangles in the inerior of the domain
	inside = dT.isInterior();
	elem   = dT.ConnectivityList();
	elem   = elem(inside,:);

	% only keep elements that have at least one edge longer than the threshold
	l = Geometry.tri_edge_length(X(elem),Y(elem));
	fdx  = any(l>lmin,2);
	elem = elem(fdx,:);
%	trimesh_fast(elem,P(:,1),P(:,2),'g');

	mesh = UnstructuredMesh(P,elem);
	mesh.edges_from_elements();
	bnd = mesh.edge(mesh.bnd,:);
	% TODO hack
if (0)
	X_ = X(bnd);
	Y_ = Y(bnd);
	l = hypot(diff(X_,[],2),diff(Y_,[],2));
	fdx = l < 2*lmin;
	bnd = bnd(fdx,:);
end
	nb = size(bnd,1);

%	plot(flat([X(bnd),NaN(nb,1)]'),flat([Y(bnd),NaN(nb,1)]'),'g','color',[0,0.8,0]);
	%mesh.plot();

	% extract boundary edges of the coastline
	[bnde_C, bnd_C] = mesh.boundary_chain2();
	shp = struct();
	%figure(3);
	%clf();
	for idx=1:length(bnd_C)
		shp(idx).Geometry = 'Polygon';
		shp(idx).X = P(bnde_C{idx},1);
		shp(idx).Y = P(bnde_C{idx},2);
		%plot(shp(idx).X,shp(idx).Y)
		%hold on
	end
	shp = Shp.cat(shp);
	shp = rmfield(shp,'Id');
	shp = rmfield(shp,'jd');
	
end % Shp::extract_coast_line


