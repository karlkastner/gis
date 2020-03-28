function shp  = export_cross_section(obj)
	left  = obj.left;
	right = obj.right;
	n     = size(left,1);
	X     = [left(:,1),right(:,1),NaN(n,1)];
	Y     = [left(:,2),right(:,2),NaN(n,1)];
	shp   = Shp.create('Geometry','Line','X',{flat(X')},'Y',{flat(Y')});
end

