function DL = DL_comp(f, G)
	m = size(G, 2);
	n = size(f,1);
	
	max_iter = 100;
	lie_b = zeros(n, max_iter);
	count = 0;
	
	DL = G; % metto già tutte le gi
	for i = 1:m
		while size(lincols(tmp,2))<n || (count < max_iter)
			count = count + 1;
			if count == 1
				lie_b(:,count) = lie_bracket(f, G(:,count), x);
			else
				lie_b(:,count) = lie_bracket(f, lie_b(:,count-1), x);
			end
		end
		DL = [DL lie_b];
		lie_b = zeros(n, max_iter);
		count = 0;
	end
	DL = lincols(DL);
end