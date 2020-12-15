function [Lfw] = derivative_covector(f,w,x)
%LIE_BRACKET Computes lie bracket between vector fields f and covector field g w.r.t. x.
% output Lfw= covector field

%Check if f and g are vectors
if ~iscolumn(f) || isscalar(f)
   error('In lie_bracket, f is not a column vector, note that is a vector field'); 
elseif ~isrow(w) || isscalar(w)
   error('In lie_bracket, w is not a row vector,  note that is a co-vector field'); 
end

% Compute the bracket
Lfw = transpose(f)*(transpose(jacobian(transpose(w),x))) + w*jacobian(f,x);

% output is a covector field
end

