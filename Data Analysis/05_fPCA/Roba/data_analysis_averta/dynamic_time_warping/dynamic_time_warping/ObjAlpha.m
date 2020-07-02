function ObjVal = ObjAlpha(alpha, s1, s2)

num = alpha(1)
den = alpha(2)

s2_res = resample(s2,round(num),round(den));

%ObjVal = dtw(s1,s2_res);
ObjVal = sum(s1)-sum(s2_res);

end

