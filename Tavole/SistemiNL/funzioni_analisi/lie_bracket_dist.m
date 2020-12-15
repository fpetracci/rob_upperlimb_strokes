function [output] = lie_bracket_dist(D,D0,x)
%LIE_BRACKET_DIST computes lie bracket between two distributions
%   The two distributions should be row cell arrays

Dout = [];

% Lie bracket for each pair
for i = 1 : size(D,2)		% number of column, number of vector fields inside distribution D
   for j = 1 : size(D0,2)	% number of column, number of vector fields inside distribution D0
       Dnow = lie_bracket(D(:,i), D0(:,j), x); % Lie Bracket results is a field vector itself
       Dout = [Dout Dnow]; % add new vector field obtained from Lie Bracket between distr elements
   end
end

output = Dout;

end

