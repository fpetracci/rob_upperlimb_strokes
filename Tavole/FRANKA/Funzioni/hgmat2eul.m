function eul = hgmat2eul(T)

if size(T,3) > 1
	% multiple matrixes
	eul = zeros(3, size(T,3));
	
	for i = 1:size(T,3)
		eul(:,i) = rotm2eul((T(1:3,1:3, i)));
	end
else
	% only one matrix
	eul = rotm2eul((T(1:3,1:3)));
end

% each row is a time sample

end