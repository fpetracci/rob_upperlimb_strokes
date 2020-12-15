function [output] = derivative_covector_dist(D,D0,x)
%LIE_BRACKET_DIST computes lie bracket between a distribution D and a
%co-distribution D0
%   The distribution should be composed by column cell arrays
%	The codistribution should be composed by row cell arrays

Dout = [];

% Lie brack et for each pair
for i = 1 : size(D,2)		% number of distribution elements
   for j = 1 : size(D0,1)	% number of codistribution elements
       Dnow =  derivative_covector(D(:,i), D0(j,:), x);
       Dout = [Dout ;Dnow];
   end
end
output = linrows([Dout;D0]);
end

