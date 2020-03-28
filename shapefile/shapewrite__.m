%% Copyright (C) 2014,2015 Philip Nienhuis
%% 
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*- 
%% @deftypefn {Function File} {@var{status} =} shapewrite (@var{shpstr}, @var{fname})
%% Write contents of map- or geostruct to a GIS shape file.
%%
%% @var{shpstr} must be a valid mapstruct or geostruct, a struct array with an
%% entry for each shape feature, with fields Geometry, BoundingBox, and X and Y
%% (mapstruct) or Lat and Lon (geostruct).  For geostructs, Lat and Lon field
%% data will be written as X and Y data.  Field Geometry can have data values
%% of 'Point', 'MultiPoint', 'Line', or 'Polygon', all case-insensitive.  For
%% each shape feature, field BoundingBox should contain the minimum and maximum
%% (X,Y) coordinates in a 2x2 array [minX, minY; maxX, maxY].  The X and Y
%% fields should contain X (or Latitude) and Y (or Longitude) coordinates for
%% each point or vertex as row vectors; for polylines and polygons vertices of
%% each subfeature (if present) should be separated by NaN entries.
%%
%% @var{fname} should be a valid shape file name, optionally with a '.shp'
%% suffix.
%%
%% shapewrite produces 2 or 3 files, i.e. a .shp file (the actual shape file),
%% a .shx file (index file), and if @var{shpstr} contained additional fields,
%% a .dbf file (dBase type 3) with the contents of those additional fields.
%%
%% @var{status} is 1 if the shape file set was written successfully, 0
%% otherwise.
%%
%% @seealso{shaperead, shapeinfo}
%% @end deftypefn

%% Author: Philip Nienhuis <prnienhuis@users.sf.net>
%% Created: 2014-12-30

function [status] = shapewrite (shp, fname, atts)

  status = 0;

  %% Input validation
  if (nargin < 1)
    print_usage;
  end

  %% Assess shape variable type (oct or ml/geo ml/map)
  if (~isstruct (shp))
    error ('shapewrite: [map-, geo-] struct expected for argument %2');
  else
    %% Yep. Find out what type
    fldn = fieldnames (shp);
    if (ismember ('vals', fldn) && ismember ('shpbox', fldn))
      %% Assume it is an Octave-style struct read by shaperead
      otype = 0;
      warning ('shapewrite: only Matlab-type map/geostructs can be written\n');
      return;
    elseif (ismember ('Geometry', fldn) && ismember ('BoundingBox', fldn) && ...
            ismember ('X', fldn))
      %% Assume it is a Matlab-style mapstruct
      otype = 1;
    elseif (ismember ('Geometry', fldn) && ismember ('BoundingBox', fldn) && ...
            ismember ('Lat', fldn))
      %% Assume it is a Matlab-style geostruct
      otype = 2;
    else
      %% Not a supported struct type
      error ('shapewrite: unsupported struct type.\n')
    end
  end

  %% Check file name
  [pth, fnm, ext] = fileparts (fname);
  if (isempty (ext))
    bname = fname;
    fname = [fname '.shp'];
  else
    %% Later on bname.shx and bname.dbf will be read
    bname = [pth fnm];
  end

  %% Prepare a few things
  numfeat = numel (shp);
  if (otype >= 1)
    stype = find (strcmpi (shp(1).Geometry, ...
                  {'Point', 'MultiPoint', 'Line', 'Polygon'}));
%    stype = [1, 8, 3, 5](stype);
    if (otype == 2)
      %% Change Lat/Lon fields into X/Y
      [shp.X] = deal (shp.Lat);
      [shp.Y] = deal (shp.Lon);
      shp = rmfield (shp, {'Lat', 'Lon'});
    end
  end

  %% Only now (after input checks) open .shp and .shx files & rewind just to be sure
  fids = fopen (fname, 'w');
  if (fids < 0)
    error ('shapewrite: shapefile %s can''t be opened for writing\n', fname);
  end
  fseek (fids, 0, 'bof');
  fidx = fopen ([ bname '.shx' ], 'w');
  if (fidx < 0)
    error ('shapewrite: indexfile %s can''t be opened for writing\n', fname);
  end
  fseek (fidx, 0, 'bof');

  %% Write headers in .shp & .shx (identical). First magic number 9994 + 5 zeros
  fwrite (fids, [9994 0 0 0 0 0 0], 'int32', 0, 'ieee-be');
  fwrite (fidx, [9994 0 0 0 0 0],   'int32', 0, 'ieee-be');
  %% In between here = filelength in 16-bit words (single). For .shx it's known
  fwrite (fidx, ((numfeat * 4) + 50), 'int32', 0, 'ieee-be');
  %% Next, shp file version
  fwrite (fids, 1000, 'int32');
  fwrite (fidx, 1000, 'int32');
  %% Shape feature type
  fwrite (fids, stype, 'int32');
  fwrite (fidx, stype, 'int32');
  %% Bounding box. Can be run later for ML type shape structs. Fill with zeros
  fwrite (fids, [0 0 0 0 0 0 0 0], 'double');
  fwrite (fidx, [0 0 0 0 0 0 0 0], 'double');

  %% Skip to start of first record position
%  fseek (fids, 100, 'bof');
%  fseek (fidx, 100, 'bof');

  %% Write shape features one by one
  if (otype >= 1)
    for ishp=1:numfeat
      %% Write record start pos to .shx file
      fwrite (fidx, ftell (fids), 'int32', 0, 'ieee-be');

      %% Write record contents
      switch (stype)
        case 1                                                %% Point
          %% Record index number
          fwrite (fids, ishp, 'int32', 0, 'ieee-be');
          %% Record length (fixed)
          reclen = 20;
          fwrite (fids, reclen, 'int32', 0, 'ieee-be');
          fwrite (fidx, reclen, 'int32', 0, 'ieee-be');
          %% Shape type
          fwrite (fids, stype, 'int32');
          %% Simply write XY cordinates
          fwrite (fids, [shp(ishp).X shp(ishp).Y], 'double');
          
        case 8                                                %% MultiPoint
          %% Record index number
          fwrite (fids, ishp, 'int32', 0, 'ieee-be');
          %% Record length
          reclen = (48 + 16 * numel (shp(ishp).X)) / 2;
          fwrite (fids, reclen, 'int32', 0, 'ieee-be');
          fwrite (fidx, reclen, 'int32', 0, 'ieee-be');
          %% Shape type
          fwrite (fids, stype, 'int32');
          %% Bounding box
          fwrite (fids, [shp(ishp).BoundingBox(:)']', 'double');
          %% Nr of points
          fwrite (fids, numel (shp(ishp).X), 'int32');
          fwrite (fids, [shp(ishp).X shp(ishp).Y]', 'double');
          reclen = (44 + 16 * numel (shp(ishp).X)) / 2;
          
        case {3, 5}                                           %% Polyline/-gon
          %% Record index number
          fwrite (fids, ishp, 'int32', 0, 'ieee-be');
          %% Prepare multipart polygons
          idx = [ 0 find(isnan (shp(ishp).X)) ];
          npt = numel (shp(ishp).X) - numel (idx) + 1;
          %% Augment idx for later on, & this trick eliminates trailing NaN rows
          idx = unique ([ idx npt ]);
          %% Record length
          reclen = (52 + (numel(idx)-1)*4 + 2*8*npt) / 2;
          fwrite (fids, reclen, 'int32', 0, 'ieee-be');
          fwrite (fidx, reclen, 'int32', 0, 'ieee-be');
          %% Shape type
          fwrite (fids, stype, 'int32');
          %% Bounding box
          fwrite (fids, [shp(ishp).BoundingBox(:)']', 'double');
          %% Number of parts, number of points, part pointers
          fwrite (fids, [(numel(idx)-1) npt idx(1:end-1) ], 'int32');
          for ii=1:numel(idx)-1
            fwrite (fids, [shp(ishp).X(idx(ii)+1:idx(ii+1)) ...
                           shp(ishp).Y(idx(ii)+1:idx(ii+1))]', 'double');
          end
          
        otherwise

      end
    end
  end

  %% Write file length into .shp header
  flen = ftell (fids);
  fseek (fids, 24, 'bof');
  fwrite (fids, flen/2, 'int32', 0, 'ieee-be');

  %% Close files
  fclose (fids);
  fclose (fidx);

  %% Check for dbfwrite function
  if (isempty (which ('dbfwrite')))
    printf ('shaperead.m: dbfwrite function not found. No attributes written.\n');
    printf ('             (io package 2.2.6+ installed and loaded?)\n');
    return;
  end

  %% Write rest of attributes
  if (nargin == 3)
    shp = atts;
  else
    if (otype == 1)
      %% Attributes + shp data in mapstruct
      shp = rmfield (shp, {'Geometry', 'BoundingBox', 'X', 'Y'});
    elseif (otype == 2)
      %% Attributes + shp data in geostruct
      shp = rmfield (shp, {'Geometry', 'BoundingBox', 'Lat', 'Lon'});
    end
  end
  attribs = cell (numfeat + 1, numel (fieldnames (shp)));
  attribs(1, :) = fieldnames (shp);
  attribs(2:end, :) = squeeze (struct2cell (shp));

  if (~isempty (attribs))
    try
      status = dbfwrite ([ bname '.dbf'], attribs);
    catch
      warning ('shapewrite: writing attributes to file %s failed\n', [bname '.dbf']);
    end
  else
    status = 1;
  end

endfunction
