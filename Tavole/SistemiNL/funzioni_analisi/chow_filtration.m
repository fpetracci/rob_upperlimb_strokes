function Dfull = chow_filtration(D,D0,x)
%CHOW_FILTRATION Accessibility Filtration

Dfull = D0;
Dfull_1 = [];

disp('D0 ='); disp(D0);
% iteration of Filtration 
while (rank(Dfull) < length(x)) && (rank(Dfull) ~= rank(Dfull_1))% controllare
    Dfull_1 = Dfull;
    Dfull = [Dfull_1 lie_bracket_dist(Dfull_1, D, x)];
    Dfull = lincols(Dfull);
%     disp('Di ='); disp(Dfull);
end
% disp('Dfull ='); disp(Dfull);
end

