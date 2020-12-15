function [B]=lincols(A)
% LINCOLS linerarly independent columns
%   Extract a linearly independent set of columns of a given matrix X

Ares = A(:,1);

% Add columns and see if rank increases
for i = 2 : size(A,2)
   if rank([Ares A(:,i)]) > rank(Ares)
       Ares = [Ares A(:,i)];
   end
end

B = Ares;

end