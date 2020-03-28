% Wed Jun 25 12:52:28 WIB 2014
% Karl Kastner, Berlin
% loading shp files is extremely slow
% so this function loads the file and stores it as a mat file
% and loads the load file on the next call

function shp = preload_shp(folder,filename,rflag)
	matname = [filename(1:end-4) '.mat'];
	if (2 == exist(matname) && ~rflag)
		mat = load(matname);
		field_C = fieldnames(mat);
		shp = getfield(mat,field_C{1});
	else
		shp = shaperead([folder filesep filename]);
		% structure array to structure of arrays
		field_C = fieldnames(shp);
		mat = struct();
		for idx=1:length(field_C)
			% getfield only returns the first entry, so do not use it
			%data = [getfield(shp,field_C{idx})];
			data = [shp.(field_C{idx})];
			% make a column vector
			data = data(:);
			mat  = setfield(mat,field_C{idx},data); 
		end
		if (rflag >= 0)
			save(matname,'mat');
		end
		% for return
		shp = mat;
	end
end % preload_shp

