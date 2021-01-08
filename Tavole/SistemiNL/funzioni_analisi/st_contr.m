function [STLC, prop] = st_contr(G, fG, f, f_x0, x, x0, lim_inf, lim_sup, STLA)
%WEAK_CONTR evaluate if a system match necessary properties in order to be
%classifiable as small time controllable (STLC).
%
%NOTE: controllability may appears only when vector fields in the control
% distribution have the possibility to contribute the same orientation of 
% motion afforded by drift, but in arbitrary sense.
%
%   The following conditions are sufficient to affirm that a system which
%	is s.t.l.a. at x_0q is also s.t.l.c.:
%		i)	f(x)=0 for all x inside B(x_0)
%		ii)	f(x)inside span{gi(x),..., gm(x)}
%		iii)f(x_0)=0 and dim(DL)=dim(span{gi,[f, gi], [f,[f, gi]],...})=n
%				for each i = 1...m
%		iv) f(x_0)=0 and dim(DL(x_0)+DG(x_0))=n with DG=span{[gi, gj]} for
%				each i, j = 1...m
%		v)	f(x_0)=0 and every "bad brackets" is a linear combination of
%				"good brackets"
%		vi)	...

if STLA ~= 0 && STLA~=1
	error('no valid value about STLA: previous accessibility analysis is needed')
elseif STLA == 0
	STLC = 0;
elseif STLA == 1
	num_sample = 100;
	% verify properties
	% i)
	prop = 1;
	x0_neigh = neigh_gen(x0, num_sample, lim_inf, lim_sup);
	STLC = 1;
	if f_x0 == 0
		stlc = 1;
	else
		stlc = 0;
	end
	STLC = STLC * stlc;
	for s = 1:num_sample
		a = f;
		if (subs(a, x, x0_neigh(:, s)) == 0)
			stlc = 1;
		else
			stlc = 0;
		end
		STLC = STLC * stlc;
	end
	if STLC ~= 1
	% ii)
		prop = 2;
		STLC = 1;
		if (size(lincols(subs(G, x, x0)),2)==size(lincols(subs(fG, x, x0)),2))
			stlc = 1;
		else
			stlc = 0;
		end
		STLC = STLC * stlc;
		for k= 1:num_sample
			if (size(lincols(subs(G, x, x0_neigh(:, k))),2)==size(lincols(subs(fG, x, x0_neigh(:, k))),2))
				stlc = 1;
			else
				stlc = 0;
			end
			STLC = STLC * stlc;
		end
		
		if STLC ~= 1
			if f_x0 ~= 0
				STLC = 0;
				prop = 0;
			elseif f_x0 == 0
				DL = DL_comp(f, G);
				DG = DG_comp(G);
				
				% iii)
				prop = 3;
				if size(lincols(subs(DL, x, x0)), 2) == size(f,1)
					STLC = 1;
				% iv)
				elseif size(lincols(subs((DL+DG), x, x0)), 2) == size(f,1)
					prop = 4;
					STLC = 1;
				% v)
				else % DA IMPLEMENTARE LA v) E LA vi)
					% lie bracket date da un numero di f e un numero di g
					% devono essere combinazioni lineari delle relative
					% good brackets
					prop = 5;
					STLC = 0;
					prop = 0;
				end
			end
		end
	end
end
end
	
