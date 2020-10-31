function out = reshape_data(in)
%reshape_data performs a reshape of input by rearranging its dimension as
%1:3:2
	out = reshape(in', size(in', 1), size(in', 3), size(in', 2));
end