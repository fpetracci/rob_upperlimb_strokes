clc; clear all; close all;
fprintf('Choose system for analysis: \n');

fprintf('1: cycle \n');

fprintf('2: bicycle \n');

fprintf('3: overhead crane \n');


choiche = input(' ... ');

switch choiche
	case 1
	%% Analisi proprietà uniciclo
	syms x_p y_p theta real
	x = [x_p; y_p; theta];
	fprintf('lo stato iniziale considerato è \n:')
	x0 = [0; 0; 0]
	fprintf('il sistema è dato da:')
	g1 = [cos(theta); sin(theta); 0]
	g2 = [0;0;1]
	fprintf('STUDIO DELLA CONTROLLABILITA'' \n')

	fprintf('la filtrazione di chow porta a : \n')
	Dfull = chow_filtration([g1 g2],[g1 g2],x);
	D_full_x0 = subs(Dfull,x,x0)
	if rank(D_full_x0) == length(x)
		fprintf('il sistema preso in analisi è STLA \n');
		STLA = 1;
	else
		fprintf('il sistema preso in analisi non è STLA \n');
		STLA = 0;
	end
	
	if exist('f') == 1
		f_x0 = subs(f,x,x0);
	elseif STLA == 1
		fprintf('il sistema preso in analisi è anche STLC in un intorno di x0 \n')
	else
		fprintf('vedere una delle altre proprietà da rispettare \n')
	end
	
	fprintf('Studio OSSERVABILITA'' \n')
	fprintf('In uscita prendiamo la velocità dell''uniciclo: \n ')
	h = (x_p^2+y_p^2)/2
	[cod_full] = chow_filtration_obs([g1 g2],jacobian(h,x),x)
	fprintf('il rango è : \n')
	rank(cod_full)


	case 2
	%% Analisi proprietà Biciclo
	clear all
	syms x_M y_M theta_A theta_P
	x = [x_M y_M theta_A theta_P];
	fprintf('lo stato iniziale considerato è \n:')
	x0 = [0 0 0 0];
	Lm = 0.2;
	L = 3;
	phi = theta_A-theta_P;
	fprintf('il sistema è dato da:')

	g1 = [cos(phi)*cos(theta_P)-(Lm/L)*sin(phi)*sin(theta_P);...
		  cos(phi)*sin(theta_P)+(Lm/L)*sin(phi)*cos(theta_P);...
										0					;...
								(1/L)*sin(phi)					];
	g2 = [ 0;...
		   0;...
		   1;...
		   0];
	%% studio della raggiungibilità
	% Da notare come il sistema del biciclo presenta f(x)=0,
	% è espresso nella forma x_dot = g1(x)u1+g2(x)u2
	% come prima cosa va applicato il teorema di Chow per verificare la
	% s.t.l.a.
	fprintf('STUDIO DELLA CONTROLLABILITA'' \n')

	fprintf('la filtrazione di chow porta a : \n')

	Dfull = chow_filtration([g1 g2],[g1 g2],x);%% sembra avere dimensione 4, il che significa che è accessibile Rivedere
	
	D_full_x0 = subs(Dfull,x,x0)
	fprintf('il rango di D_full_xo è : \n');
	rank(D_full_x0)
	if rank(D_full_x0) == length(x)
		fprintf('il sistema preso in analisi è STLA \n');
		STLA = 1;
	else
		fprintf('il sistema preso in analisi non è STLA \n');
		STLA = 0;
	end
	if exist('f') == 1
		f_x0 = subs(f,x,x0);
	elseif STLA ==1
		fprintf('il sistema preso in analisi è anche STLC in un intorno di x0 dal momento che la f è nulla \n')
	else
		fprintf('vedere una delle altre proprietà da rispettare \n')
	end
	%% studio dell'osservabilità
	fprintf('Studio OSSERVABILITA'' \n')
	fprintf('In uscita prendiamo la velocità dell''uniciclo: \n ')
	h = (x_M^2+y_M^2)/2
	[cod_full] = chow_filtration_obs([g1 g2],jacobian(h,x),x)
	fprintf('il rango è : \n')
	rank(cod_full)

	case 3
	%% analisi Gru
	filename = 'system_model.png';
	filename2 = 'system_state.png';
	y = imread(filename);
	y2 = imread(filename2);
	figure(1)
	imshow(y);
	figure(2)
	imshow(y2);

	syms x1 x2 x3 x4 x5 x6 x7 x8 real
	g = 9.81;
	fprintf('lo stato iniziale considerato è \n:')

	x0 = [0 0 0 0 pi/4 pi/20 pi/4 pi/20];
	x10 = 0;
	x9 = 2;
	x = [x1 x2 x3 x4 x5 x6 x7 x8]; 
	fprintf('il sistema è dato da: \n')

	f = [ x2;...
		  0;...
		  x4;...
		  0;...
		  x6;...
		  -2*(x10/x9)*x6+0.5*x8^2*sin(2*x5)-(g/x9)*sin(x5)*sin(x7);...
		  x8;...
		  -2*(x10/x9)*x8-2*x8*x6*cot(x5)];
	g1 = [0;...
		  1;...
		  0;...
		  0;...
		  0;...
		  -cos(x5)*sin(x7)/x9;...
		  0;...
		  -cos(x7)/(sin(x5)*x9)];
	g2 = [0;...
		  0;...
		  0;...
		  1;...
		  0;...
		  -cos(x5)*cos(x7)/x9;...
		  0;...
		  -sin(x7)/(sin(x5)*x9)];
	% eq1 = f == zeros(8,1)
	% S = solve(eq1);
	fprintf('STUDIO DELLA CONTROLLABILITA'' \n')
	fprintf('la filtrazione di chow porta a : \n')

	Dfull = chow_filtration([f g1 g2],[g1 g2],x);%% sembra avere dimensione 4, il che significa che è accessibile Rivedere
	D_full_x0 = subs(Dfull,x,x0)
	fprintf('il rango di D_full_xo è : \n');
	rank(D_full_x0)
	if rank(D_full_x0) == length(x)
		fprintf('il sistema preso in analisi è STLA \n');
		if exist('f') == 1
			f_x0 = subs(f,x,x0);
			if  f_x0 == 0 
				fprintf('verificare se possibile una delle ipotesi \n');
			else
				fprintf('verificare se possibile l''ultima ipotesi, non so come si faccia, molto probabile non riuscire a \n concludere, ipotesi solo sufficienti \n');
			end
		else
			fprintf('il sistema preso in analisi è anche STLC in un intorno di x0 dal momento che la f è nulla \n')
		end
	else
		fprintf('il sistema preso in analisi,SCRIVERE PAG 136, no STLA per quel x0 \n');
	end
end


