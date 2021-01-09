clc; clear all; close all;
fprintf('Scegli un sistema da analizzare: \n');

fprintf('1: uniciclo \n');

fprintf('2: biciclo \n');

fprintf('3: Ponte/gru \n');

choiche = input(' ... ');

switch choiche 
	case 1
	%% Analisi proprietà uniciclo
	% setting variabili del sistema	
	syms x_p y_p theta real
	syms x_p0 y_p0 theta0 real
	syms v(t) w(t) real % azioni di controllo
	syms t real
	syms Tinf real
	global t
	global Tinf
	
	% definizione della dinamica del sistema e delle condizioni iniziali
	fprintf('Consideriamo il sistema UNICICLO \n')
	x = [x_p; y_p; theta];
	x_0 = [x_p0; y_p0; theta0];
	
	fprintf('Il sistema non lineare nella forma di stato è dato da:')
	f = [0; 0; 0]
	g1 = [cos(theta); sin(theta); 0]
	g2 = [0;0;1]
	
	fprintf('\nLo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, [0; 0; 0])
	lim_inf = x0 - 0.1;
	lim_sup = x0 + 0.1;
	
	% definizione distribuzione di controllo G e di drift+controllo fG
	G = [g1 g2];
	fG = G;
	
	% analisi controllabilità
	fprintf('\nSTUDIO DELLA CONTROLLABILITA'' \n')
	
	% check accessibilità small time
	fprintf('\nSTLA: ACCESSIBILITA'' small time \n')
	fprintf('La filtrazione di Chow porta a <∆|∆_𝟎>: \n')
	Dfull = chow_filtration(fG, G, x);
	fprintf('Valutandolo in x_0: \n')
	D_full_x0 = subs(Dfull,x,x0)
	if rank(D_full_x0) == length(x)
		fprintf(['Il sistema preso in analisi è STLA: <∆|∆_𝟎> in x_0 ha rango ' num2str(rank(D_full_x0)) ', uguale alle dim dello stato \n']);
		STLA = 1;
	else
		fprintf(['Il sistema preso in analisi non è STLA: <∆|∆_𝟎> in x_0 ha rango ' num2str(rank(D_full_x0)) ', minore delle dim dello stato \n'] \n');
		STLA = 0;
	end
	
	% check accessibilità weak
	fprintf('\nWA: ACCESSIBILITA'' weak \n')
	if STLA
		fprintf('Il sistema preso in analisi è STLA: allora è sicuramente anche WA \n');
		WA = 1;
	else
		fprintf('Il sistema preso in analisi non è STLA, ma potrebbe essere WA \n');
		
		fprintf('La simil-filtrazione di Chow porta a <∆|∆>: \n')
		Dfull_w = chow_filtration(fG, fG, x);
		fprintf('Valutandolo in x_0: \n')
		D_full_w_x0 = subs(Dfull_w,x,x0)
		if rank(D_full_w_x0) == length(x)
			fprintf(['Il sistema preso in analisi è WA: <∆|∆> in x_0 ha rango ' num2str(rank(D_full_w_x0)) ', uguale alle dim dello stato \n']);
			WA = 1;
		else
			fprintf(['Il sistema preso in analisi non è WA: <∆|∆> in x_0 ha rango ' num2str(rank(D_full_w_x0)) ', minore delle dim dello stato\n'] \n');
			WA = 0;
		end
	end
	
	% check controllabilità small time 
	fprintf('\nSTLC: CONTROLLABILITA'' small time \n')
	 if exist('f')
		f_x0 = subs(f,x,x0);
		% properties check
		[STLC, prop] = st_contr(G, fG, f, f_x0, x, x0, lim_inf, lim_sup, STLA);
		if STLA
			if STLC
				fprintf('Il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
				fprintf(['La proprietà verificata è la numero ' num2str(prop) '\n']);
			else
				fprintf('Il sistema preso in analisi è STLA ma non STLC \n')
			end
		else
			fprintf('Il sistema preso in analisi non è STLA quindi nemmeno STLC \n')
		end	
	elseif STLA == 1
		fprintf('Il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
	else
		fprintf('Il sistema non è STLA quindi non può essere STLC \n')
	 end
	
	 % check osservabilità
	fprintf('\nSTUDIO OSSERVABILITA'' \n')
	fprintf('\nSe come uscita prendiamo la posizione dell''uniciclo: \n ')
	h = [x_p y_p]
	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n ')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Rango pari alla dim dello stato: il sistema per questi ingressi e uscite è osservabile \n')
	else
		fprintf('Rango minore della dim dello stato: il sistema per questi ingressi e uscite non è osservabile \n')	
	end
	
	fprintf('\nSe come uscita prendiamo la velocità dell''uniciclo: \n ')
	h = (x_p^2+y_p^2)/2
	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n ')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Rango pari alla dim dello stato: il sistema per questi ingressi e uscite è osservabile \n')
	else
		fprintf('Rango minore della dim dello stato: il sistema per questi ingressi e uscite non è osservabile \n')	
	end	
	
	% approccio integrale e gramiano di osservabilità
	fprintf('\nAPPROCCIO INTEGRALE e GRAMIANO di OSSERVABILITA'' \n')
	tinf = 0;
	tsup = 100;
	fprintf(['\nintervallo temporale: [' num2str(tinf) ', ' num2str(tsup) ']\n'])
	tstep = 0.1;
	T = (tinf+tstep) : tstep : tsup;
	fprintf('Ricordiamo che lo stato è dato da: \n')
	x = [x_p; y_p; theta]
	x_0 = [x_p0; y_p0; theta0];
	fprintf('L''evoluzione dello stato è quindi data da: \n')
	% x_t =[ x_p0 + int(v*cos(theta), t, 0, t); y_p0 + int(v*sin(theta), t, 0, t); theta0 + int(w, t, 0, t)]; 
	x_t =[ x_p0 + int(v*cos(theta0 + int(w, t, 0, t)), t, 0, t); y_p0 + int(v*sin(theta0 + int(w, t, 0, t)), t, 0, t); theta0 + int(w, t, 0, t)] 	
	fprintf('Lo stato iniziale considerato è: \n')
	x1 = [0; 0; 0]
	%fprintf('il secondo stato è: \n')
	%x2 = [1; 3; 2]
	%dx = x2-x1;
	fprintf('\nSe come uscita prendiamo le posizioni x e y dell''uniciclo: \n ')
	h = [x_p y_p]
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n ')
	W = eye(size(h,1), size(h,1))
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x1, 'o')
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss ==1
		fprintf('il sistema è localmente osservabile in x_1: il gramiano ha rango pieno righe  \n')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['Un indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
			
	fprintf('\nOsservabilità con la matrice di sensibilità S: \n')
	S = jacobian(x_t, x_0) 
	fprintf('Il Gramiano calcolato con S sarà: \n')
	Go_s = gramian_oss(h, x, W, S, 's')
	fprintf('\nValutazione del nullo del Gramiano: se si ha intersezione non nulla tra i Gramiani ad ogni t, esso perde di invertibilità \n')
	% trova modo di calcolare il nullo del gramiano per ogni intervallo di
	% tempo e vedere se tutti gli spazi nulli intersecati insieme danno un
	% sottospazio non nullo. Se sì, lì giacciono gli stati non osservabili.
	fprintf('\n1) Spazio nullo del Gramiano: v=0, w(t) generica \n')
	%NGo_s = null(Go_s);
	
	thr = (pi/18)*pi/180; % threshold a 10°
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla velocità del veicolo \n')
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
		fprintf('Si ha sottospazio di inosservabilità: se la velocità v è nulla, il veicolo può solo ruotare su se stesso, ma in uscita io ho le posizioni sul piano, quindi non riesco a distinguere due stati che differiscono solo per l''orientazione, unica cosa che posso cambiare con il controllo \n')
		noss_v = 1;
	else
		fprintf('Non si ha sottospazio di inosservabilità \n')
		noss_v = 0;
	end
	
	fprintf('\n2) Spazio nullo del Gramiano: w=0, v(t) generica \n')
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla rotazione del veicolo \n')
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
		fprintf('Si ha sottospazio di inosservabilità \n')
		noss_w = 1;
	else
		fprintf('Non si ha sottospazio di inosservabilità, tutti gli stati sono osservabili \n')
		noss_w = 0;
	end	
	
	fprintf('\nConsiderazioni finali sull''osservabilità: \n')
	if noss_v && noss_w
		fprintf('	sistema non completamente osservabile a prescindere dai controlli \n')
	elseif noss_v && ~noss_w
		fprintf('	ho spazio di inosservabilità se a variare è solo w(t) mentre v=0 \n')
	elseif ~noss_v && noss_w
		fprintf('	ho spazio di inosservabilità se a variare è solo v(t) mentre w=0 \n')
	else
		fprintf('	sistema completamente osservabile a prescindere dai controlli \n')	
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
	
	% Immagini sistema
% 	filename = 'system_model.png';
% 	filename2 = 'system_state.png';
% 	y = imread(filename);
% 	y2 = imread(filename2);
% 	figure(1)
% 	imshow(y);
% 	figure(2)
% 	imshow(y2);
	
	% setting variabili del sistema	
	syms x_t x_t_dot y_t y_t_dot theta theta_dot phi phi_dot L L_dot real
	g = 9.81;
	z_t = 0;
	syms x_t_0 x_t_dot_0 y_t_0 y_t_dot_0 theta_0 theta_dot_0 phi_0 phi_dot_0 L_0 L_dot_0 real
	syms t real
	syms x_t_ddot(t) y_t_ddot(t) L_ddot(t) real % azioni di controllo
	syms Tinf real
	global t
	global Tinf
	
	%% funzioni dinamica
	x	= [x_t; x_t_dot; y_t; y_t_dot; theta; theta_dot; phi; phi_dot; L ; L_dot]
	x_0	= [x_t_0; x_t_dot_0; y_t_0; y_t_dot_0; theta_0; theta_dot_0; phi_0; phi_dot_0; L_0; L_dot_0];
	fprintf('il sistema è dato da: \n')

	f = [ x_t_dot;...
		  0;...
		  y_t_dot;...
		  0;...
		  theta_dot;...
		  -2*(L_dot/L)*theta_dot+0.5*phi_dot^2*sin(2*theta)-(g/L)*sin(theta);...
		  phi_dot;...
		  -2*(L_dot/L)*phi_dot-2*phi_dot*theta_dot*cot(theta);...
		  L_dot;...
		  0]
	g1 = [0;...
		  1;...
		  0;...
		  0;...
		  0;...
		  -cos(theta)*sin(phi)/L;...
		  0;...
		  -cos(phi)/(sin(theta)*L);...
		  0;...
		  0]
	g2 = [0;...
		  0;...
		  0;...
		  1;...
		  0;...
		  -cos(theta)*cos(phi)/L;...
		  0;...
		  sin(phi)/(sin(theta)*L);...
		  0;...
		  0]
	g3 = [0;...
		  0;...
		  0;...
		  0;...
		  0;...
		  0;...
		  0;...
		  0;...
		  0;...
		  1]

	%% Stato iniziale
	x_0_numerico = [0; 0; 0; 0; 3/180*pi;  1e-2;   30/180*pi;  1e-2; 2; 0];
% 	x_0_numerico = randn(10,1);

	fprintf('\nLo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, x_0_numerico)
	lim_inf = x0 - 0.1;
	lim_sup = x0 + 0.1;
	
	% definizione distribuzione di controllo G e di drift+controllo fG
	G = [g1 g2 g3];
	fG = [f G];
	
	% analisi controllabilità
	fprintf('\nSTUDIO DELLA CONTROLLABILITA'' \n')
	
	% check accessibilità small time
	fprintf('\nSTLA: ACCESSIBILITA'' small time \n')
	fprintf('La filtrazione di Chow porta a <∆|∆_𝟎>: \n')
	Dfull = chow_filtration(fG, G, x);
	fprintf('Valutandolo in x_0: \n')
	D_full_x0 = subs(Dfull,x,x0)
	if rank(D_full_x0) == length(x)
		fprintf(['Il sistema preso in analisi è STLA: <∆|∆_𝟎> in x_0 ha rango ' num2str(rank(D_full_x0)) ', uguale alle dim dello stato \n']);
		STLA = 1;
	else
		fprintf(['Il sistema preso in analisi non è STLA: <∆|∆_𝟎> in x_0 ha rango ' num2str(rank(D_full_x0)) ', minore delle dim dello stato \n']);
		STLA = 0;
	end
	
	% check accessibilità weak
	fprintf('\nWA: ACCESSIBILITA'' weak \n')
	if STLA
		fprintf('Il sistema preso in analisi è STLA: allora è sicuramente anche WA \n');
		WA = 1;
	else
		fprintf('Il sistema preso in analisi non è STLA, ma potrebbe essere WA \n');
		
		fprintf('La simil-filtrazione di Chow porta a <∆|∆>: \n')
		Dfull_w = chow_filtration(fG, fG, x);
		fprintf('Valutandolo in x_0: \n')
		D_full_w_x0 = subs(Dfull_w,x,x0)
		if rank(D_full_w_x0) == length(x)
			fprintf(['Il sistema preso in analisi è WA: <∆|∆> in x_0 ha rango ' num2str(rank(D_full_w_x0)) ', uguale alle dim dello stato \n']);
			WA = 1;
		else
			fprintf(['Il sistema preso in analisi non è WA: <∆|∆> in x_0 ha rango ' num2str(rank(D_full_w_x0)) ', minore delle dim dello stato\n']);
			WA = 0;
		end
	end
	
	% check controllabilità small time  	
	fprintf('\nSTLC: CONTROLLABILITA'' small time \n')
	 if exist('f')
		f_x0 = subs(f,x,x0);
		% properties check
		[STLC, prop] = st_contr(G, fG, f, f_x0, x, x0, lim_inf, lim_sup, STLA);
		if STLA
			if STLC
				fprintf('Il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
				fprintf(['La proprietà verificata è la numero ' num2str(prop) '\n']);
			else
				fprintf('Il sistema preso in analisi è STLA ma non STLC \n')
			end
		else
			fprintf('Il sistema preso in analisi non è STLA quindi nemmeno STLC \n')
		end	
	elseif STLA == 1
		fprintf('Il sistema preso in analisi è STLA e anche STLC in un intorno di x0 \n')
	else
		fprintf('Il sistema non è STLA quindi non può essere STLC \n')
	 end
	
	%% check osservabilità
	fprintf('\nSTUDIO OSSERVABILITA'' \n')
	fprintf('\nSe come uscita prendiamo la posizione del carico (massa appesa): \n ')
	
	% Uscite
	x_ball = x_t + L*sin(theta)*sin(phi)
	y_ball = y_t + L*sin(theta)*cos(phi)
	z_ball = L*cos(theta) + z_t
	h = [x_ball y_ball  z_ball];
	
	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n ')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x);
	cod_full = simplify(cod_full)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Rango pari alla dim dello stato: il sistema per questi ingressi e uscite è osservabile \n')
	else
		fprintf('Rango minore della dim dello stato: il sistema per questi ingressi e uscite non è osservabile \n')	
	end
	
% 	fprintf('\nSe come uscita prendiamo la velocità dell''uniciclo: \n ')
% 	h = (x_p^2+y_p^2)/2
% 	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n ')
% 	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
% 	fprintf('Valutiamone il rango \n')
% 	r = rank(cod_full)
% 	if r == length(x)
% 		fprintf('Rango pari alla dim dello stato: il sistema per questi ingressi e uscite è osservabile \n')
% 	else
% 		fprintf('Rango minore della dim dello stato: il sistema per questi ingressi e uscite non è osservabile \n')	
% 	end	
	
	%% approccio integrale e gramiano di osservabilità
	fprintf('\nAPPROCCIO INTEGRALE e GRAMIANO di OSSERVABILITA'' \n')
	tinf = 0;
	tsup = 100;
	fprintf(['\nintervallo temporale: [' num2str(tinf) ', ' num2str(tsup) ']\n'])
	tstep = 0.1;
	T = (tinf+tstep) : tstep : tsup;
	fprintf('Ricordiamo che lo stato è dato da: \n')
	x 
% 	x_0 = [x_p0; y_p0; theta0];
	fprintf('L''evoluzione dello stato è quindi data da: \n')
	% x_t =[ x_p0 + int(v*cos(theta), t, 0, t); y_p0 + int(v*sin(theta), t, 0, t); theta0 + int(w, t, 0, t)]; 
	%%DA RIFARE
	%%DA RIFARE
	%%DA RIFARE
	%%DA RIFARE
	x_t =[ x_p0 + int(v*cos(theta0 + int(w, t, 0, t)), t, 0, t); y_p0 + int(v*sin(theta0 + int(w, t, 0, t)), t, 0, t); theta0 + int(w, t, 0, t)] 	
	
	fprintf('Lo stato iniziale considerato è: \n')
	x_0_numerico
	%fprintf('il secondo stato è: \n')
	%x2 = [1; 3; 2]
	%dx = x2-x1;
	fprintf('\nSe come uscita prendiamo la posizione del carico (massa appesa): \n ')
% 	h = [x_p y_p]
	h
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n ')
	W = eye(size(h,1), size(h,1))
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x_0_numerico, 'o')
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss ==1
		fprintf('il sistema è localmente osservabile in x_1: il gramiano ha rango pieno righe  \n')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['Un indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
			
	fprintf('\nOsservabilità con la matrice di sensibilità S: \n')
	S = jacobian(x_t, x_0) 
	fprintf('Il Gramiano calcolato con S sarà: \n')
	Go_s = gramian_oss(h, x, W, S, 's')
	fprintf('\nValutazione del nullo del Gramiano: se si ha intersezione non nulla tra i Gramiani ad ogni t, esso perde di invertibilità \n')
	% trova modo di calcolare il nullo del gramiano per ogni intervallo di
	% tempo e vedere se tutti gli spazi nulli intersecati insieme danno un
	% sottospazio non nullo. Se sì, lì giacciono gli stati non osservabili.
	fprintf('\n1) Spazio nullo del Gramiano: v=0, w(t) generica \n')
	%NGo_s = null(Go_s);
	
	%% DA TRADURRE PER LA GRU
	thr = (pi/18)*pi/180; % threshold a 10°
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla velocità del veicolo \n')
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
		fprintf('Si ha sottospazio di inosservabilità: se la velocità v è nulla, il veicolo può solo ruotare su se stesso, ma in uscita io ho le posizioni sul piano, quindi non riesco a distinguere due stati che differiscono solo per l''orientazione, unica cosa che posso cambiare con il controllo \n')
		noss_v = 1;
	else
		fprintf('Non si ha sottospazio di inosservabilità \n')
		noss_v = 0;
	end
	
	fprintf('\n2) Spazio nullo del Gramiano: w=0, v(t) generica \n')
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla rotazione del veicolo \n')
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
		fprintf('Si ha sottospazio di inosservabilità \n')
		noss_w = 1;
	else
		fprintf('Non si ha sottospazio di inosservabilità, tutti gli stati sono osservabili \n')
		noss_w = 0;
	end	
	
	fprintf('\nConsiderazioni finali sull''osservabilità: \n')
	if noss_v && noss_w
		fprintf('	sistema non completamente osservabile a prescindere dai controlli \n')
	elseif noss_v && ~noss_w
		fprintf('	ho spazio di inosservabilità se a variare è solo w(t) mentre v=0 \n')
	elseif ~noss_v && noss_w
		fprintf('	ho spazio di inosservabilità se a variare è solo v(t) mentre w=0 \n')
	else
		fprintf('	sistema completamente osservabile a prescindere dai controlli \n')	
	end
	
end


