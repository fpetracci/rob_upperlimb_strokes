function [Dfull, Dfull_1] = chow_filtration_obs(D,D0,x)

%CHOW_FILTRATION observability Filtration

Dfull = D0;
Dfull_1 = [];

disp('D0 ='); disp(D0);
while (rank(Dfull) < size(x,2)) && (rank(Dfull) ~= rank(Dfull_1))% controllare
    Dfull_1 = Dfull;
    Dfull = [Dfull ; derivative_covector_dist(D, Dfull, x)];
    Dfull = linrows(Dfull);
end
disp('Dfull ='); disp(Dfull);
end
