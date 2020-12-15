function Dfull = lie_bracket_n(D,D0,x,n)

%simile alla filtrazione di chow, ripete la lie bracket solo per n volte,
%selezionate dall'utente, utile per il teorema 8, dove va ripetuta per n-1
%volte e per il teorema 9, n-2 volte. Da notare che ripetere n-1 volte la
%lie bracket equivale alla chow_filtration.

Dfull = D0;
Dfull_1 = [];
counter = 0;% variabile che serve per vedere quante lie bracket vengono calcolate, utile per i teoremi sul controllo NL
% disp('D0 ='); disp(D0);
while (rank(Dfull) < size(x,2)) && (rank(Dfull) ~= rank(Dfull_1) && counter < n)% controllare
    Dfull_1 = Dfull;
    Dfull = [Dfull lie_bracket_dist(Dfull, D, x)];
    Dfull = lincols(Dfull);
	counter = counter + 1;
%     disp('Di ='); disp(Dfull);
end
% disp('Dfull ='); disp(Dfull);
end

