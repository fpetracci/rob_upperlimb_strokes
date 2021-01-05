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
	syms x_p0 y_p0 theta0 real
	syms v(t) w(t) real % azioni di controllo
	syms t real
	syms Tinf real
	global t
	global Tinf
	x = [x_p; y_p; theta];
	x_0 = [x_p0; y_p0; theta0];
	fprintf('lo stato iniziale considerato è \n:')
	x0 = subs(x_0, x_0, [0; 0; 0]);
	
	lim_inf = x0 - 0.1;
	lim_sup = x0 + 0.1;
	fprintf('il sistema è dato da:')
	f = [0; 0; 0];
	g1 = [cos(theta); sin(theta); 0]
	g2 = [0;0;1]
	G = [g1 g2];
	fG = G;
	
	% check controllabilità
	fprintf('STUDIO DELLA CONTROLLABILITA'' \n')
	fprintf('la filtrazione di chow porta a : \n')
	Dfull = chow_filtration(G, G, x);
	D_full_x0 = subs(Dfull,x,x0)
	if rank(D_full_x0) == length(x)
		fprintf('il sistema preso in analisi è STLA \n');
		STLA = 1;
	else
		fprintf('il sistema preso in analisi non è STLA \n');
		STLA = 0;
	end
	
	% check weak controllability 
	 if exist('f')
		f_x0 = subs(f,x,x0);
		% properties check
		[STLC, prop] = weak_contr(G, fG, f, f_x0, x, x0, lim_inf, lim_sup, STLA);
		if STLA
			if STLC
				fprintf('il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
				fprintf(['la proprietà verificata è la numero ' num2str(prop) '\n']);
			else
				fprintf('il sistema preso in analisi è STLA ma non STLC \n')
			end
		else
			fprintf('il sistema preso in analisi non è STLA né STLC \n')
		end	
	elseif STLA == 1
		fprintf('il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
	else
		fprintf('il sistema non è STLA quindi non può essere STLC \n')
	 end
	
	 % check osservabilità
	fprintf('Studio OSSERVABILITA'' \n')
	fprintf('Se in uscita prendiamo la posizione dell''uniciclo: \n ')
	h = [x_p y_p]
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('il rango è : \n')
	rank(cod_full)
	if rank(cod_full) == length(x)
		fprintf('il sistema per questi ingressi e uscite è osservabile \n')
	else
		fprintf('il sistema per questi ingressi e uscite non è osservabile \n')	
	end
	
	fprintf('In uscita prendiamo la velocità dell''uniciclo: \n ')
	h = (x_p^2+y_p^2)/2
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('il rango è : \n')
	rank(cod_full)
	if rank(cod_full) == length(x)
		fprintf('il sistema per questi ingressi e uscite è osservabile \n')
	else
		fprintf('il sistema per questi ingressi e uscite non è osservabile \n')	
	end
	
	%% approccio integrale e gramiano di osservabilità
	fprintf('Approccio integrale e Gramiano di Osservabilità \n')
	fprintf('intervallo temporale: \n')
	tinf = 0
	tsup = 100
	tstep = 0.1;
	T = (tinf+tstep) : tstep : tsup;
	fprintf('lo stato è dato da: \n')
	x = [x_p; y_p; theta]
	x_0 = [x_p0; y_p0; theta0];
	fprintf('evoluzione dello stato è data da: \n')
	% x_t =[ x_p0 + int(v*cos(theta), t, 0, t); y_p0 + int(v*sin(theta), t, 0, t); theta0 + int(w, t, 0, t)]; 
	x_t =[ x_p0 + int(v*cos(theta0 + int(w, t, 0, t)), t, 0, t); y_p0 + int(v*sin(theta0 + int(w, t, 0, t)), t, 0, t); theta0 + int(w, t, 0, t)] 	
	fprintf('lo stato iniziale è: \n')
	x1 = [0; 0; 0]
	%fprintf('il secondo stato è: \n')
	%x2 = [1; 3; 2]
	%dx = x2-x1;
	fprintf('si sceglie come uscite le posizioni x e y dell''uniciclo: \n ')
	h = [x_p y_p]
	fprintf('la funzione di peso W è: \n ')
	W = eye(size(h,1), size(h,1))
	fprintf('il corrispondente Gramiano di osservabilità è: \n')
	Go = gramian_oss(h, x, W, x1, 'o')
	fprintf('analisi del rango del Gramiano: \n ')
	oss = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss = 0;
			fprintf(['il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss ==1
		fprintf('Gramiano ha rango pieno righe: il sistema è localmente osservabile in x1 \n ')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
			
	fprintf('Con la matrice di sensibilità: \n')
	S = jacobian(x_t, x_0) 
	fprintf('Gramiano calcolato con S: \n')
	Go_s = gramian_oss(h, x, W, S, 's')
	fprintf('Valutazione del nullo del gramiano: se si ha intersezione non nulla tra i gramiani ad ogni t, perde di invertibilità. \n')
	% trova modo di calcolare il nullo del gramiano per ogni intervallo di
	% tempo e vedere se tutti gli spazi nulli intersecati insieme danno un
	% sottospazio non nullo. Se sì, lì giacciono gli stati non osservabili.
	fprintf('si cerca lo spazio nullo del gramiano \n')
	%NGo_s = null(Go_s);
	
	thr = (pi/18)*pi/180; % threshold a 10°
	fprintf('valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho modo di controllare la velocità del veicolo \n')
	NGo_sv = null(subs(Go_s, v, 0)); %non ho modo di controllare la velocità del veicolo
	if rank(NGo_sv)>0
		for i = 1:length(T)-1 %va rivisto qua
			if i == 1
				ssp = subspace(subs(NGo_sv,t,(i*tstep)), (subs(NGo_sv, t,(i+1)*tstep)));
			else
				ssp = ssp + subspace(subs(NGo_sv,t,(i*tstep)), (subs(NGo_sv, t,(i+1)*tstep)));
			end
		end
	else
		ssp = 100*thr;
	end
	if ssp < thr %angoli molto piccoli dicono che sono lin dipendenti i due sottospazi
		fprintf('si ha sottospazio di inosservabilità \n')
		noss_v = 1;
	else
		fprintf('non si ha sottospazio di inosservabilità \n')
		noss_v = 0;
	end
	
	fprintf('valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho modo di controllare la rotazione del veicolo \n')
	NGo_sw = null(subs(Go_s, w, 0)); %non ho modo di controllare la rotazione del veicolo
	if rank(NGo_sw)>0
		for i = 1:length(T)-1 %va rivisto qua
			if i == 1
				ssp = subspace(subs(NGo_sw,t,(i*tstep)), (subs(NGo_sw, t,(i+1)*tstep)));
			else
				ssp = ssp + subspace(subs(NGo_sw,t,(i*tstep)), (subs(NGo_sw, t,(i+1)*tstep)));
			end
		end
	else
		ssp = 100*thr;
	end
	
	if ssp < thr %angoli molto piccoli dicono che sono lin dipendenti i due sottospazi
		fprintf('si ha sottospazio di inosservabilità \n')
		noss_w = 1;
	else
		fprintf('non si ha sottospazio di inosservabilità \n')
		noss_w = 0;
	end	
	
	if noss_v && noss_w
		fprintf('sistema non completamente osservabile a prescindere dai controlli \n')
	elseif noss_v && ~noss_w
		fprintf('ho spazio di inosservabilità se posso variare solo w(t) \n')
	elseif ~noss_v && noss_w
		fprintf('ho spazio di inosservabilità se posso variare solo v(t) \n')
	else
		fprintf('sistema completamente osservabile a prescindere dai controlli \n')	
	end
	case 2
	%% Analisi proprietà Biciclo
	clear all
	syms x_M y_M theta_A theta_P
	x = [x_M; y_M; theta_A; theta_P];
	fprintf('lo stato iniziale considerato è \n:')
	x0 = [0; 0; 0; 0];
	lim_inf = x0 - 0.1;
	lim_sup = x0 + 0.1;
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
	   
	   G = [g1 g2];
	   fG = G;
	%% studio della raggiungibilità
	% Da notare come il sistema del biciclo presenta f(x)=0,
	% è espresso nella forma x_dot = g1(x)u1+g2(x)u2
	% come prima cosa va applicato il teorema di Chow per verificare la
	% s.t.l.a.
	fprintf('STUDIO DELLA CONTROLLABILITA'' \n')

	fprintf('la filtrazione di chow porta a : \n')

	Dfull = chow_filtration(G, G, x);%% sembra avere dimensione 4, il che significa che è accessibile Rivedere
	
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
	
	% weak controllability check
	if exist('f')
		f_x0 = subs(f,x,x0);
		% check delle proprietà
		[STLC, prop] = weak_contr(G, fG, f, f_x0, x, x0, lim_inf, lim_sup, STLA);
		if STLA
			if STLC
				fprintf('il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
				fprintf(['la proprietà verificata è la numero ' num2str(prop) '\n']);
			else
				fprintf('il sistema preso in analisi è STLA ma non STLC \n')
			end
		else
			fprintf('il sistema preso in analisi non è STLA né STLC \n')
		end	
	elseif STLA == 1
		fprintf('il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
	else
		fprintf('il sistema non è STLA quindi non può essere STLC \n')
	end
	%% studio dell'osservabilità
	fprintf('Studio OSSERVABILITA'' \n')
	fprintf('In uscita prendiamo la velocità dell''uniciclo: \n ')
	h = (x_M^2+y_M^2)/2
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('il rango è : \n')
	rank(cod_full)
	if rank(cod_full) == length(x)
		fprintf('il sistema per questi ingressi e uscite è osservabile \n')
	else
		fprintf('il sistema per questi ingressi e uscite non è osservabile \n')	
	end
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

	x0 = [0; 0; 0; 0; pi/4; pi/20; pi/4; pi/20];
	lim_inf = x0 - 0.1*x0;
	lim_sup = x0 + 0.1*x0;
	x10 = 0;
	x9 = 2;
	x = [x1; x2; x3; x4; x5; x6; x7; x8]; 
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
	  
	  G = [g1 g2];
	  fG = [f g1 g2];
	% eq1 = f == zeros(8,1)
	% S = solve(eq1);
	fprintf('STUDIO DELLA CONTROLLABILITA'' \n')
	fprintf('la filtrazione di chow porta a : \n')

	Dfull = chow_filtration(fG, G, x);%% sembra avere dimensione 4, il che significa che è accessibile Rivedere
	D_full_x0 = subs(Dfull, x, x0)
	fprintf('il rango di D_full_xo è : \n');
	rank(D_full_x0)
	if rank(D_full_x0) == length(x)
		fprintf('il sistema preso in analisi è STLA \n');
		STLA = 1;
	else
		fprintf('il sistema preso in analisi,SCRIVERE PAG 136, no STLA per quel x0 \n');
		STLA = 0;
	end
	
	% weak controllability check
	if exist('f')
		f_x0 = subs(f,x,x0);
		% check delle proprietà
		[STLC, prop] = weak_contr(G, fG, f, f_x0, x, x0, lim_inf, lim_sup, STLA);
		if STLA
			if STLC
				fprintf('il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
				fprintf(['la proprietà verificata è la numero ' num2str(prop) '\n']);
			else
				fprintf('il sistema preso in analisi è STLA ma non STLC \n')
			end
		else
			fprintf('il sistema preso in analisi non è STLA né STLC \n')
		end	
	elseif STLA == 1
		fprintf('il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
	else
		fprintf('il sistema non è STLA quindi non può essere STLC \n')
	end
end


