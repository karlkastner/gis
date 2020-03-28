% Thu Nov 20 12:38:53 CET 2014
% Karl Kastner, Berlin

function [varargout] = get(obj,S0,varargin)
	for idx=1:length(varargin)
		%varargout{idx} = interp1_smooth(obj.S, getfield(obj, varargin{idx}), S0);
		field = getfield(obj, varargin{idx});
		if (~isempty(field))
			varargout(idx) = {interp1(obj.S, field, S0)};
		else
			varargout(idx) = {NaN(size(S0))};
		end
	end
	varargout{end+1} = obj;
end

