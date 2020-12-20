function gramian = gramian_oss(h, x, W, a, type)
%GRAMIAN_OSS computes gramian matrix of a non linear system.
%Osservability gramian related to non linear systems depends on:
%state x1 from which observability is studied
%input applied on the system
%length of time interval during which observability is studied.

%condizionare se esiste o meno S

if type ~= 'o' && type ~= 's'
	error('invalid input argument, type must be o or s \n')
else
	global t;
	global Tinf;
	syms dh(t)
	dh(t) = jacobian(h, x);
	% in dh deve esserci la dipendenza dal tempo
	if type == 'o'
		x1 = a;
		% dh = subs(dh, x, x1);
		dh = subs(dh, x, x1);
		fun = dh' * W * dh;
		gramian = int(fun, t, 0, t);
	elseif type == 's'
		S = a;
		fun = S' * dh' * W * dh * S;
		gramian = int(fun, t, 0, t);
	end
end