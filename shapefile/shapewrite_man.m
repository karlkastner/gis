% 2016-06-02 11:54:04.470574863 +0200

function ret = shapewrite_man(varargin)
        insert(py.sys.path,int32(0),'/home/pia/phd/src/lib/shapefile/');
	py.importlib.import_module('shp');
	%py.shp.shapewrite(filename,geometry,X,Y,'Z',Z);
	ret = py.shp.shapewrite(varargin{:});
end

