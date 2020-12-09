function [Dfull, Dfull_1] = chow_filtration(D,D0,x)

%CHOW_FILTRATION Accessibility Filtration

Dfull = D0;
Dfull_1 = [];

disp('D0 ='); disp(D0);
while (rank(Dfull) < size(x,1)) && (rank(Dfull) ~= rank(Dfull_1))
    Dfull_1 = Dfull;
    Dfull = [Dfull lie_bracket_dist(Dfull, D, x)];
    Dfull = lincols(Dfull);
    disp('Di ='); disp(Dfull);
end

end

