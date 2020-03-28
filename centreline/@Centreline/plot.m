% Thu  6 Jun 18:46:47 CEST 2019
function plot(obj,varargin)
	id = obj.segment.id;
	for idx=1:length(id);
		plot(obj.X(id{idx}),obj.Y(id{idx}),varargin{:})
		hold on
	end
end

