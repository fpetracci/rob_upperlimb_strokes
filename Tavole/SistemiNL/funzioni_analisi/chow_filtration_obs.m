function [Dfull, Dfull_1] = chow_filtration_obs(D,D0,x)
%CHOW_FILTRATION observability Filtration

Dfull = D0;		% dh, a lui appartengono i differenziali delle funzioni di uscita
				% Al suo annichilatore invece appartengono le CI tra loro
				% indistinguibili.
Dfull_1 = [];

disp('D0 ='); disp(D0);
while (rank(Dfull) < length(x)) && (rank(Dfull) ~= rank(Dfull_1))% controllare
    Dfull_1 = Dfull;
    Dfull = [Dfull_1 ; derivative_covector_dist(D, Dfull_1, x)];
    Dfull = linrows(Dfull);
end
disp('Dfull ='); disp(Dfull);
end
