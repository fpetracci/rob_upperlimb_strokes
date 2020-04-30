function sol = lsq_order0_norm(diff)
% This function finds the constant value that minimizes the square error
% of the given vector's norm of each row.
%	
%	

	norm_diff = zeros(size(diff, 1), 1);
	for i = 1:size(diff, 1)
		norm_diff(i) = norm(diff(i,:), 2);
	end

	sol = polyfit(1:size(norm_diff, 1), norm_diff', 0); 

end