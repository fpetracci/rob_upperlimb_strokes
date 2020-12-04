function pos = hgmat2pos(T)

if size(T,3) > 1
	% multiple matrixes
	pos = zeros(3, size(T,3));
	
	for i = 1:size(T,3)
		pos(:,i) = transpose(T(1:3,4, i));
	end
else
	% only one matrix
	pos = transpose(T(1:3,4));
end

% each row is a time sample

end
