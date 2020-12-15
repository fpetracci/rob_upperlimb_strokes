function [B]=linrows(A)
% LINROWS linerarly independent rows
%   Extract a linearly independent set of rows of a given matrix X

Ares = A(1,:);

% Add rows and see if rank increases
for i = 2 : size(A,1) % check tra le righe
   if rank([Ares; A(i,:)]) > rank(Ares)
       Ares = [Ares; A(i,:)];
   end
end

B = Ares;

end