clc; clear all; close all;
fprintf('Choose system for analysis: \n');

fprintf('1: cycle \n');

fprintf('2: bicycle \n');

fprintf('3: overhead crane \n');


choiche = input(' ... ');

switch choiche
	case 1
	%% Controllo uniciclo
	syms x_p y_p theta real
	x = [x_p y_p theta];
	fprintf('lo stato iniziale considerato è \n:')
	x0 = [0 0 0]
	fprintf('il sistema è dato da:')
	g1 = [cos(theta); sin(theta); 0]
	g2 = [0;0;1]
	fprintf('dal momento che f è nulla,non viene rispettata la prima \n condizione del teorema 8 pag.165, no linearizzazione per cambiamento di variabili')
	[condizione_1_T8,condizione_2_T8] = Teorema8(zeros(length(x),1),[g1 g2],x)
	[condizione_1_T9,condizione_2_T9] = Teorema9(zeros(length(x),1),[g1 g2],x)

end