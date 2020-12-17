function samples = neigh_gen(x0, num_sample, lim_inf, lim_sup)
	n = size(x0, 1);
	samples = x0 + lim_inf + (lim_sup-lim_inf).*rand(n,num_sample);
end
