function DG = DG_comp(G)
	m = size(G, 2);
	
	DG = zeros((size(G,1)), 1);
	for i=1:m			% [gi, gj]= -[gj,gi] quindi non sono lin indip
		for j=i+1:m		% [gi, gi]= 0 non occorre calcolarla	
			DG = [DG lie_bracket(G(:,i), G(:,j), x)];
		end
	end
	DG = lincols(DG);
end
