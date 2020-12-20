function gramian = gramian_oss(h, x, W, t_sym, Tinf, Tsup, a, type)
%GRAMIAN_OSS computes gramian matrix of a non linear system.
%Osservability gramian related to non linear systems depends on:
%state x1 from which observability is studied
%input applied on the system
%length of time interval during which observability is studied.

%condizionare se esiste o meno S

if type ~= 'o' && type ~= 's'
	error('invalid input argument, type must be o or s \n')
else
	t = t_sym;
	syms dh(x, t)
	dh(x, t) =jacobian(h, x);
	% in dh deve esserci la dipendenza dal tempo
	if type == 'o'
		x1 = a;
		% dh = subs(dh, x, x1);
		dh = dh(x1, t);
		fun = @(t) dh(x1, t)' * W * dh(x1, t);
		gramian = integral(@(t)fun, Tinf, Tsup);
	elseif type == 's'
		S = a;
		fun = @(t) S' * dh' * W * dh * S;
		gramian = integral(@(t)fun, Tinf, Tsup);
	end
end