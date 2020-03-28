% 2014-07-23 09:59:09.778624994 +0200

Talweg
- width extraction
- every 500m
- get closest boundary point with distance r
- get second point closest to (2*x0-x1) and (2*y0-y1)
thalweg extraction
- every 500m estimate width
- take 5 points
- approximate depth as quadratic between the three points on the lower side
- or as minimum of the quartic (not unique)
- maximum x between 
%- calculate minimum
%- improvement :
% between the two smallest points, compute a third

- connect river parts
- within a radius of river width
	check that cs is sufficiently sampled
	find deepest location or find deepest point as minimum of quadratic in sn coordinates
- interpolate

