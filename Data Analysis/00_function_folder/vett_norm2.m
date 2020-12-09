function out = vett_norm2(a, direction)
%ROW_NORM calculates the 2-norm of each row or column at time


%% computation

if direction == 1
	nrow = size(a,1);
	out = zeros(nrow,1);
	for i = 1:nrow
		out(i) = norm(a(i,:), 2);
	end
elseif direction == 2
	ncolumn = size(a,2);
	out = zeros(ncolumn,1);
	for i = 1:ncolumn
		out(i) = norm(a(:,i), 2);
	end
end

end

