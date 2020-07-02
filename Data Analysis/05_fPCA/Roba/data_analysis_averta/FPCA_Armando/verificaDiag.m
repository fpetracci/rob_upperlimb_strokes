function test = verificaDiag(c, EPS)
  if nargin < 2
    EPS = 1e-12;
  end
  cd = size(c);
  if length(cd) ~= 2
    test = 0;
  else
    if cd(1) ~= cd(2)
      test = 0;
    else
      mindg  = min(abs(diag(c)));
      maxodg = max(max(abs(c - diag(diag(c)))));
      if maxodg/mindg < EPS
        test = 1;
      else
        test = 0;
      end
    end
  end

