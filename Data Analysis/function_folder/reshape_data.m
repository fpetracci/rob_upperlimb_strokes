function out = reshape_data(in)
	out = reshape(in', size(in', 1), size(in', 3), size(in', 2));
end