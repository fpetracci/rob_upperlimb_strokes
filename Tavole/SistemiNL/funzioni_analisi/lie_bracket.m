function [Lfg] = lie_bracket(f,g,x)

%LIE_BRACKET Computes lie bracket between vector fields f and g w.r.t. x.

% Check if f and g are vectors
if ~iscolumn(f) || isscalar(f)
   error('In lie_bracket, f is not a column vector'); 
elseif ~iscolumn(g) || isscalar(g)
   error('In lie_bracket, g is not a column vector'); 
end

% Compute the bracket
Lfg = jacobian(g,x)*f - jacobian(f,x)*g;

end

