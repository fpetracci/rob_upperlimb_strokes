function out = reshape_data(in)
	out = reshape(in, size(in, 2), size(in, 3), size(in, 1));
end