clc; clear all; close all;
fprintf('Scegli un sistema da analizzare: \n');

fprintf('1: uniciclo \n');

fprintf('2: biciclo \n');

fprintf('3: biciclo a trazione posteriore \n');

fprintf('4: Ponte/gru \n');

choiche = input(' ... ');

switch choiche 
	case 1
	%% Analisi proprietà Uniciclo
	% setting variabili del sistema	
	syms t real	
	syms x_p(t) y_p(t) theta(t) real
	syms x_p0 y_p0 theta0 real
	syms v(t) w(t) real % azioni di controllo

	syms Tinf real
	global t
	global Tinf
	
	x0_num = [0; 0; 0]; % stato iniziale per lo studio di controllabilità e osservabilità
	
	%% Definizione della dinamica del sistema e delle condizioni iniziali
	fprintf('Consideriamo il sistema UNICICLO \n')
	x = [x_p; y_p; theta];
	x_0 = [x_p0; y_p0; theta0];
	
	fprintf('Il sistema non lineare nella forma di stato è dato da:')
	f = [0; 0; 0]
	g1 = [cos(theta); sin(theta); 0]
	g2 = [0;0;1]
	
	fprintf('\nLo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, x0_num)
	lim_inf = x0 - 0.1;
	lim_sup = x0 + 0.1;
	
	% definizione distribuzione di controllo G e di drift+controllo fG
	G = [g1 g2];
	fG = G;
	
	%% Analisi controllabilità e accessibilità
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
	
	%% Analisi osservabilità
	n_trial = 2;
	OSS = zeros(n_trial,1);
	fprintf('\nSTUDIO OSSERVABILITA'' \n')
%%%1	
	OSS(1) = 0;
	fprintf('\n1) Se come uscita prendiamo la posizione dell''uniciclo: \n')
	h = [x_p y_p]
	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(1) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(1) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(1) = 0;
	end
%%%2
	OSS(2) = 0;
	fprintf('\n2) Se come uscita prendiamo la velocità dell''uniciclo: \n')
	
	v_p = (x_p^2+y_p^2)/2;
	h = v_p
	
	% h = [v_p*cos(theta), v_p*sin(theta)]
	
	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(2) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(2) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(2) = 0;
	end
	
	%% Approccio integrale e Gramiano di osservabilità
	ntrial = 2;
	oss = zeros(ntrial,1);
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
	x0 = subs(x_0, x_0, x0_num)
%%%1 
	fprintf('\n1) Se come uscita prendiamo le posizioni x e y dell''uniciclo: \n')
	h = [x_p y_p]
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(1) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(1) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(1) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
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
	
%%%2
	fprintf('\n2) Se come uscita prendiamo la velocità dell''uniciclo: \n')
	
	v_p = (x_p^2+y_p^2)/2;
	h = v_p
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(2) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(2) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(2) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
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
% setting variabili del sistema		
	syms t real
	syms x_M(t) y_M(t) phi(t) theta_P(t) real
	syms x_M0 y_M0 phi0 theta_P0 real
	syms v_M(t) w_M(t) real % azioni di controllo
	syms Tinf real
	global t
	global Tinf
	
	x0_num = [0; 0; 0; 0]; % stato iniziale per lo studio di controllabilità e osservabilità
	
	% parametri
	Lm = 0.2;				% distanza di M dal centro dell'assale posteriore
	L = 3;					% lunghezza interasse
	% phi = theta_A-theta_P;	% angolo di sterzo
	
	%% Definizione della dinamica del sistema e delle condizioni iniziali
	fprintf('Consideriamo il sistema BICICLO \n')
	x = [x_M; y_M; phi; theta_P];
	x_0 = [x_M0; y_M0; phi0; theta_P0];
	
	fprintf('Il sistema non lineare nella forma di stato è dato da:')
	f = [0; 0; 0; 0]
	% velocità avanzamento punto M
	fprintf('in: velocità avanzamento M \n')
	g1 = [cos(phi)*cos(theta_P)-(Lm/L)*sin(phi)*sin(theta_P);...
		  cos(phi)*sin(theta_P)+(Lm/L)*sin(phi)*cos(theta_P);...
										0					;...
								(1/L)*sin(phi)					]
	% velocità di rotazione di theta_A
	fprintf('in: velocità rotazione di theta_A \n')
	g2 = [ 0;...
		   0;...
		   1;...
		   0]
	
	fprintf('\nLo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, x0_num)
	lim_inf = x0 - 0.1;
	lim_sup = x0 + 0.1;
	
	% definizione distribuzione di controllo G e di drift+controllo fG
	G = [g1 g2];
	fG = G;

	%% Analisi raggiungibilità e accessibilità
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
	 
	%% Analisi dell'osservabilità
	n_trial = 2;
	OSS = zeros(n_trial,1);
	fprintf('Studio OSSERVABILITA'' \n')
%%%1
	OSS(1)=0;
	fprintf('\n1) Se in uscita prendiamo la posizione di M nel biciclo: \n')

    h = [x_M, y_M]
	
	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(1) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(1) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(1) = 0;
	end
%%%2
	OSS(2) = 0;
	fprintf('\n2) Se in uscita prendiamo la velocità del punto M nel biciclo: \n')
	
	v_M = (x_M^2+y_M^2)/2;
	h = v_M
	% h = [v_M*cos(theta_P), v_M*sin(theta_P)]

	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(2) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(2) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(2) = 0;
	end
	
	%% Approccio integrale e Gramiano di osservabilità 
	ntrial = 2;
	oss = zeros(ntrial,1);
	fprintf('\nAPPROCCIO INTEGRALE e GRAMIANO di OSSERVABILITA'' \n')
	tinf = 0;
	tsup = 100;
	
	fprintf(['\nintervallo temporale: [' num2str(tinf) ', ' num2str(tsup) ']\n'])
	tstep = 0.33;
	T = (tinf+tstep) : tstep : tsup;
	
	fprintf('Ricordiamo che lo stato è dato da: \n')
	x = [x_M; y_M; phi; theta_P];
	x_0 = [x_M0; y_M0; phi0; theta_P0];
	
	fprintf('L''evoluzione dello stato è quindi data da: \n')
	
	x_t = [	x_M0 + int(v_M*(cos(phi0 + int(w_M, t, 0, t))*cos(theta_P0 + int(v_M*(1/L)*sin((phi0 + int(w_M, t, 0, t))), t, 0, t))-(Lm/L)*sin(phi0 + int(w_M, t, 0, t))*sin(theta_P0 + int(v_M*(1/L)*sin((phi0 + int(w_M, t, 0, t))), t, 0, t))), t, 0, t);...
			y_M0 + int(v_M*(cos(phi0 + int(w_M, t, 0, t))*sin(theta_P0 + int(v_M*(1/L)*sin((phi0 + int(w_M, t, 0, t))), t, 0, t))+(Lm/L)*sin(phi0 + int(w_M, t, 0, t))*cos(theta_P0 + int(v_M*(1/L)*sin((phi0 + int(w_M, t, 0, t))), t, 0, t))), t, 0, t);...
			phi0 + int(w_M, t, 0, t);...
			theta_P0 + int(v_M*(1/L)*sin((phi0 + int(w_M, t, 0, t))), t, 0, t)]
		
	fprintf('Lo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, x0_num)
%%%1
	fprintf('\n1) Se in uscita prendiamo la posizione di M nel biciclo: \n')

    h = [x_M, y_M]
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(1) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(1) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(1) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
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
	fprintf('\n1) Spazio nullo del Gramiano: v_M =0, w_M(t) generica \n')
	%NGo_s = null(Go_s);
	
	thr = (pi/18)*pi/180; % threshold a 10°
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla velocità del veicolo \n')
	
	Go_sv = subs(Go_s, v_M, 0);
	if rank(Go_sv) == size(Go_sv,1)
		NGo_sv = [];
	else
		NGo_sv = null(subs(Go_s, v_M, 0)); %non ho modo di controllare la velocità del punto M del veicolo
	end
	
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
		fprintf('Si ha sottospazio di inosservabilità: se la velocità v_M è nulla, il veicolo può solo ruotare su se stesso, ma in uscita io ho le posizioni sul piano, quindi non riesco a distinguere due stati che differiscono solo per l''orientazione, unica cosa che posso cambiare con il controllo \n')
		noss_v = 1;
	else
		fprintf('Non si ha sottospazio di inosservabilità \n')
		noss_v = 0;
	end
	
	fprintf('\n2) Spazio nullo del Gramiano: w_M=0, v_M(t) generica \n')
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla rotazione del veicolo \n')
	
	Go_sw = subs(Go_s, w_M, 0);
	if rank(Go_sw) == size(Go_sw,1)
		NGo_sw = [];
	else
		NGo_sw = null(subs(Go_s, w_M, 0)); %non ho modo di controllare la rotazione del punto M del veicolo
	end
	
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
		fprintf('	ho spazio di inosservabilità se a variare è solo w_M(t) mentre v_M=0 \n')
	elseif ~noss_v && noss_w
		fprintf('	ho spazio di inosservabilità se a variare è solo v_M(t) mentre w_M=0 \n')
	else
		fprintf('	sistema completamente osservabile a prescindere dai controlli \n')	
	end

%%%2
	fprintf('\n2) Se in uscita prendiamo la velocità del punto M nel biciclo: \n')
	
	v_M = (x_M^2+y_M^2)/2;
	h = v_M
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(2) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(2) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(2) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
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
	fprintf('\n1) Spazio nullo del Gramiano: v_M =0, w_M(t) generica \n')
	%NGo_s = null(Go_s);
	
	thr = (pi/18)*pi/180; % threshold a 10°
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla velocità del veicolo \n')
	
	Go_sv = subs(Go_s, v_M, 0);
	if rank(Go_sv) == size(Go_sv,1)
		NGo_sv = [];
	else
		NGo_sv = null(subs(Go_s, v_M, 0)); %non ho modo di controllare la velocità del punto M del veicolo
	end
	
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
		fprintf('Si ha sottospazio di inosservabilità: se la velocità v_M è nulla, il veicolo può solo ruotare su se stesso, ma in uscita io ho le posizioni sul piano, quindi non riesco a distinguere due stati che differiscono solo per l''orientazione, unica cosa che posso cambiare con il controllo \n')
		noss_v = 1;
	else
		fprintf('Non si ha sottospazio di inosservabilità \n')
		noss_v = 0;
	end
	
	fprintf('\n2) Spazio nullo del Gramiano: w_M=0, v_M(t) generica \n')
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla rotazione del veicolo \n')
	
	Go_sw = subs(Go_s, w_M, 0);
	if rank(Go_sw) == size(Go_sw,1)
		NGo_sw = [];
	else
		NGo_sw = null(subs(Go_s, w_M, 0)); %non ho modo di controllare la rotazione del punto M del veicolo
	end
	
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
		fprintf('	ho spazio di inosservabilità se a variare è solo w_M(t) mentre v_M=0 \n')
	elseif ~noss_v && noss_w
		fprintf('	ho spazio di inosservabilità se a variare è solo v_M(t) mentre w_M=0 \n')
	else
		fprintf('	sistema completamente osservabile a prescindere dai controlli \n')	
	end
	
	case 3
	%% Analisi proprietà Biciclo a trazione posteriore
	clear all
% setting variabili del sistema		
	syms t real
	syms x_M(t) y_M(t) phi(t) theta_P(t) real
	syms x_M0 y_M0 phi0 theta_P0 real
	syms v_M(t) w_M(t) real % azioni di controllo
	syms Tinf real
	global t
	global Tinf
	
	x0_num = [0; 0; 0; 0]; % stato iniziale per lo studio di controllabilità e osservabilità
	
	% parametri
	Lm = 0;					% distanza di M dal centro dell'assale posteriore
	L = 3;					% lunghezza interasse
	% theta_A = phi -theta_P;

	%% Definizione della dinamica del sistema e delle condizioni iniziali
	fprintf('Consideriamo il sistema BICICLO a trazione posteriore \n')
	x = [x_M; y_M; phi; theta_P];
	x_0 = [x_M0; y_M0; phi0; theta_P0];
	
	fprintf('Il sistema non lineare nella forma di stato è dato da:')
	f = [0;...
		 0;...
		 0;...
		 0]
	% velocità avanzamento punto M sull'assale posteriore
	fprintf('in: velocità avanzamento M = punto sull''assale posteriore \n') 
	g1 = [cos(theta_P);...
		  sin(theta_P);...
				0	  ;...
		 (1/L)*tan(phi)]
	% velocità di rotazione di (theta_A-theta_P) = velocità di sterzata
	fprintf('in: velocità rotazione di (theta\_A-theta\_P) = velocità di sterzata \n') 	 
	g2 = [ 0;...
		   0;...
		   1;...
		   0]
	   
	fprintf('\nLo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, x0_num)
	lim_inf = x0 - 0.1;
	lim_sup = x0 + 0.1;
	
	% definizione distribuzione di controllo G e di drift+controllo fG
	G = [g1 g2];
	fG = G;
	
	%% Analisi raggiungibilità e accessibilità
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
	 
	%% Analisi dell'osservabilità
	n_trial = 2;
	OSS = zeros(n_trial,1);
	fprintf('Studio OSSERVABILITA'' \n')
%%%1
	OSS(1) = 0;
	fprintf('\n1) Se in uscita prendiamo la posizione di M nel biciclo a trazione posteriore: \n')

    h = [x_M, y_M]
	
	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(1) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(1) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(1) = 0;
	end
%%%2
	OSS(2) = 0;
	fprintf('\n2) Se in uscita prendiamo la velocità di M nel biciclo a trazione posteriore: \n')

	v_M = (x_M^2+y_M^2)/2;
	h = v_M
	% h = [v_M*cos(theta_P), v_M*sin(theta_P)]
	
	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(2) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(2) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(2) = 0;
	end

	%% Approccio integrale e Gramiano di osservabilità DA FAREEEE
	ntrial = 2;
	oss = zeros(ntrial,1);
	fprintf('\nAPPROCCIO INTEGRALE e GRAMIANO di OSSERVABILITA'' \n')
	tinf = 0;
	tsup = 100;
	
	fprintf(['\nintervallo temporale: [' num2str(tinf) ', ' num2str(tsup) ']\n'])
	tstep = 0.1;
	T = (tinf+tstep) : tstep : tsup;
	
	fprintf('Ricordiamo che lo stato è dato da: \n')
	x = [x_M; y_M; phi; theta_P];
	x_0 = [x_M0; y_M0; phi0; theta_P0];
	
	fprintf('L''evoluzione dello stato è quindi data da: \n')
	
   x_t = [	x_M0 + int(v_M*(cos(theta_P0 + int(v_M*(1/L)*tan((phi0 + int(w_M, t, 0, t))), t, 0, t))), t, 0, t);...
		y_M0 + int(v_M*(sin(theta_P0 + int(v_M*(1/L)*tan((phi0 + int(w_M, t, 0, t))), t, 0, t))), t, 0, t);...
		phi0 + int(w_M, t, 0, t);...
		theta_P0 + int(v_M*(1/L)*tan((phi0 + int(w_M, t, 0, t))), t, 0, t)]

	fprintf('Lo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, x0_num)
%%%1
	fprintf('\n1) Se in uscita prendiamo la posizione dell''assale posteriore nel biciclo: \n')

    h = [x_M, y_M]
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(1) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(1) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(1) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
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
	fprintf('\n1) Spazio nullo del Gramiano: v_M =0, w_M(t) generica \n')
	%NGo_s = null(Go_s);
	
	thr = (pi/18)*pi/180; % threshold a 10°
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla velocità del veicolo \n')
	
	Go_sv = subs(Go_s, v_M, 0);
	if rank(Go_sv) == size(Go_sv,1)
		NGo_sv = [];
	else
		NGo_sv = null(subs(Go_s, v_M, 0)); %non ho modo di controllare la velocità del punto M del veicolo
	end
	
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
		fprintf('Si ha sottospazio di inosservabilità: se la velocità v_M è nulla, il veicolo può solo ruotare su se stesso, ma in uscita io ho le posizioni sul piano, quindi non riesco a distinguere due stati che differiscono solo per l''orientazione, unica cosa che posso cambiare con il controllo \n')
		noss_v = 1;
	else
		fprintf('Non si ha sottospazio di inosservabilità \n')
		noss_v = 0;
	end
	
	fprintf('\n2) Spazio nullo del Gramiano: w_M=0, v_M(t) generica \n')
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla rotazione del veicolo \n')
	
	Go_sw = subs(Go_s, w_M, 0);
	if rank(Go_sw) == size(Go_sw,1)
		NGo_sw = [];
	else
		NGo_sw = null(subs(Go_s, w_M, 0)); %non ho modo di controllare la rotazione del punto M del veicolo
	end
	
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
		fprintf('	ho spazio di inosservabilità se a variare è solo w_M(t) mentre v_M=0 \n')
	elseif ~noss_v && noss_w
		fprintf('	ho spazio di inosservabilità se a variare è solo v_M(t) mentre w_M=0 \n')
	else
		fprintf('	sistema completamente osservabile a prescindere dai controlli \n')	
	end

%%%2
	fprintf('\n2) Se in uscita prendiamo la velocità dell''assale posteriore nel biciclo: \n')
	
	v_M = (x_M^2+y_M^2)/2;
	h = v_M
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(2) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(2) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(2) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
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
	fprintf('\n1) Spazio nullo del Gramiano: v_M =0, w_M(t) generica \n')
	%NGo_s = null(Go_s);
	
	thr = (pi/18)*pi/180; % threshold a 10°
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla velocità del veicolo \n')
	
	Go_sv = subs(Go_s, v_M, 0);
	if rank(Go_sv) == size(Go_sv,1)
		NGo_sv = [];
	else
		NGo_sv = null(subs(Go_s, v_M, 0)); %non ho modo di controllare la velocità del punto M del veicolo
	end
	
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
		fprintf('Si ha sottospazio di inosservabilità: se la velocità v_M è nulla, il veicolo può solo ruotare su se stesso, ma in uscita io ho le posizioni sul piano, quindi non riesco a distinguere due stati che differiscono solo per l''orientazione, unica cosa che posso cambiare con il controllo \n')
		noss_v = 1;
	else
		fprintf('Non si ha sottospazio di inosservabilità \n')
		noss_v = 0;
	end
	
	fprintf('\n2) Spazio nullo del Gramiano: w_M=0, v_M(t) generica \n')
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla rotazione del veicolo \n')
	
	Go_sw = subs(Go_s, w_M, 0);
	if rank(Go_sw) == size(Go_sw,1)
		NGo_sw = [];
	else
		NGo_sw = null(subs(Go_s, w_M, 0)); %non ho modo di controllare la rotazione del punto M del veicolo
	end
	
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
		fprintf('	ho spazio di inosservabilità se a variare è solo w_M(t) mentre v_M=0 \n')
	elseif ~noss_v && noss_w
		fprintf('	ho spazio di inosservabilità se a variare è solo v_M(t) mentre w_M=0 \n')
	else
		fprintf('	sistema completamente osservabile a prescindere dai controlli \n')	
	end
	
	case 4
	%% Analisi proprietà Gru
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
	syms t real
	syms x_t(t) x_t_dot(t) y_t(t) y_t_dot(t) theta(t) theta_dot(t) phi(t) phi_dot(t) L(t) L_dot(t) real
	syms  g b_smorza real % parametri del sistema
	z_t = 0;
	syms x_t_0 x_t_dot_0 y_t_0 y_t_dot_0 theta_0 theta_dot_0 phi_0 phi_dot_0 L_0 L_dot_0 real
	syms x_t_ddot(t) y_t_ddot(t) L_ddot(t) real % azioni di controllo
	syms Tinf real
	global t
	global Tinf
	
	x0_num = [0; 0; 0; 0; 3/180*pi;  1e-2;   30/180*pi;  1e-2; 2; 0]; % stato iniziale per lo studio di controllabilità e osservabilità
	
	%% Definizione della dinamica del sistema e delle condizioni iniziali
	fprintf('Consideriamo il sistema GRU \n')
	x	= [x_t; x_t_dot; y_t; y_t_dot; theta; theta_dot; phi; phi_dot; L ; L_dot]
	x_0	= [x_t_0; x_t_dot_0; y_t_0; y_t_dot_0; theta_0; theta_dot_0; phi_0; phi_dot_0; L_0; L_dot_0];
	
	fprintf('Il sistema non lineare nella forma di stato è dato da:')

	f = [ x_t_dot;...
		  0;...
		  y_t_dot;...
		  0;...
		  theta_dot;...
		  -2*(L_dot/L)*theta_dot+0.5*phi_dot^2*sin(2*theta)-(g/L)*sin(theta)- b_smorza * theta_dot;...
		  phi_dot;...
		  -2*(L_dot/L)*phi_dot-2*phi_dot*theta_dot*cot(theta);...
		  L_dot;...
		  0]
	  
	% accelerazione del carrello lungo l'asse x
	fprintf('in: accelerazione carrello lungo asse x \n')  
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
	% accelerazione del carrello lungo l'asse y
	fprintf('in: accelerazione carrello lungo asse y \n')  	  
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
	% accelerazione dell'allungamento dell'asta
	fprintf('in: accelerazione dell''allungamento dell''asta \n')  	  
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

	fprintf('\nLo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, x0_num)
	lim_inf = x0 - 0.1;
	lim_sup = x0 + 0.1;
	
	% definizione distribuzione di controllo G e di drift+controllo fG
	G = [g1 g2 g3];
	fG = [f G];
	
	fprintf('\nLa posizione del carico dipende da quella del carrello secondo le relazioni: \n')
	x_ball = x_t + L*sin(theta)*sin(phi)
	y_ball = y_t + L*sin(theta)*cos(phi)
	z_ball = z_t + L*cos(theta) 
	
	%% Analisi controllabilità
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
	
	%% Analisi osservabilità
	n_trial = 6;
	OSS = zeros(n_trial,1);
	fprintf('\nSTUDIO OSSERVABILITA'' \n')
	
% Uscite provate
%%%1	h = [x_ball, y_ball,  z_ball];								% osservabile r = 10
%%%2	h = [theta phi L];											% non osservabile r = 6
%%%3 	h = [x_t, y_t, L];											% non osservabile r = 6
%%%4	h = [x_ball-x_t, y_ball-y_t,  z_ball-z_t];					% non osservabile r = 6
%%%5 	h = [x_ball-x_t y_ball-y_t  z_ball-z_t, x_t, y_t];			% osservabile r = 10
%%%6	h = [x_ball-x_t y_ball-y_t  z_ball-z_t, x_t_dot, y_t_dot];	% non osservabile r = 8

%%% 1
	OSS(1) = 0;
	fprintf('\n1) Se come uscita prendiamo la posizione del carico (massa appesa): \n')
	h = [x_ball, y_ball,  z_ball]	% osservabile r = 10

	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n ')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(1) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(1) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(1) = 0;
	end
%%% 2
	OSS(2) = 0;
	fprintf('\n2) Se come uscita prendiamo gli angoli theta e phi e la lunghezza dell''asta L: \n')
	h = [theta, phi, L]

	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(2) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(2) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(2) = 0;
	end
%%% 3
	OSS(3) = 0;
	fprintf('\n3) Se come uscita prendiamo la posizione del carrello e la lunghezza dell''asta L: \n')
	h = [x_t, y_t, L]									% non osservabile r = 6

	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(3) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(3) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(3) = 0;
	end
%%% 4
	OSS(4) = 0;
	fprintf('\n4) Se come uscita prendiamo la posizione relativa della palla rispetto al carrello: \n')
	h = [x_ball-x_t, y_ball-y_t,  z_ball-z_t] 			% non osservabile r = 6

	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(4) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(4) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(4) = 0;
	end	
%%% 5
	OSS(5) = 0;
	fprintf('\n5) Se come uscita prendiamo la posizione relativa della palla rispetto al carrello e la posizione del carrello: \n')
	h = [x_ball-x_t y_ball-y_t  z_ball-z_t, x_t, y_t] 	% osservabile r = 10

	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(5) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(5) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(5) = 0;
	end	
%%% 6
	OSS(6) = 0;
	fprintf('\n6) Se come uscita prendiamo la posizione relativa della palla rispetto al carrello e le velocità del carrello: \n')
	h = [x_ball-x_t y_ball-y_t  z_ball-z_t, x_t_dot, y_t_dot]	% osservabile r = 8

	fprintf('Calcoliamo <∆|𝒅𝒉> per filtrazione: \n')
	[cod_full] = chow_filtration_obs(fG,jacobian(h,x),x)
	fprintf('Valutiamone il rango \n')
	r = rank(cod_full)
	if r == length(x)
		fprintf('Con queste uscite, nel simbolico si ha rango pieno. Vediamo se vale anche nello stato iniziale scelto. \n')
		cod_full_x0 = subs(cod_full, x, x0);
		if rank(cod_full_x0) == length(x)
			fprintf(['Il sistema preso in analisi è osservabile in x_0 scelto, infatti ha rango ' num2str(rank(cod_full_x0)) ', uguale alle dim dello stato \n']);
			OSS(6) = 1;
		else
			fprintf(['Si ha perdita di rango in questo stato iniziale (r = ' num2str(rank(cod_full_x0)) '), provare a cambiare x_0 \n'])
			OSS(6) = 0;
		end
	else
		fprintf('Il rango è sempre minore della dim dello stato: il sistema non è osservabile per nessun x_0, è necessario cambiare la scelta delle uscite \n')	
		OSS(6) = 0;
	end
	
	%% Approccio integrale e Gramiano di osservabilità DA FAREEEE
	ntrial = 6;
	oss = zeros(ntrial,1);
	fprintf('\nAPPROCCIO INTEGRALE e GRAMIANO di OSSERVABILITA'' \n')
	tinf = 0;
	tsup = 100;
	
	fprintf(['\nintervallo temporale: [' num2str(tinf) ', ' num2str(tsup) ']\n'])
	tstep = 0.1;
	T = (tinf+tstep) : tstep : tsup;
	
	fprintf('Ricordiamo che lo stato è dato da: \n')
	x	= [x_t; x_t_dot; y_t; y_t_dot; theta; theta_dot; phi; phi_dot; L ; L_dot]
	x_0	= [x_t_0; x_t_dot_0; y_t_0; y_t_dot_0; theta_0; theta_dot_0; phi_0; phi_dot_0; L_0; L_dot_0];
	
	
	fprintf('L''evoluzione dello stato è quindi data da: \n')
	% x_t =[ x_p0 + int(v*cos(theta), t, 0, t); y_p0 + int(v*sin(theta), t, 0, t); theta0 + int(w, t, 0, t)]; 
	
	x_T = [	x_t0+int(x_t_dot0+int(x_t_ddot,t,0,t) ,t,0,t);...
		x_t_dot0+int(x_t_ddot,t,0,t);...
		y_t0+int(y_t_dot0 + int(y_t_ddot ,t,0,t) ,t,0,t);...
		y_t_dot0+int(y_t_ddot ,t,0,t);...
		theta0+int((exp(-(t*(2*L_dot + L*b_smorza))/L)*(L*theta_dot_0 - int(exp((x*(2*L_dot + L*b_smorza))/L)*(- L*cos(theta(x))*sin(theta(x))*phi_dot^2 + g*sin(theta(x)) + cos(theta(x))*cos(phi)*y_t_ddot(x) + cos(theta(x))*sin(phi)*x_t_ddot(x)), x, 0, t, 'IgnoreSpecialCases', true)))/L,t,0,t);...
		(exp(-(t*(2*L_dot + L*b_smorza))/L)*(L*theta_dot_0 - int(exp((x*(2*L_dot + L*b_smorza))/L)*(- L*cos(theta(x))*sin(theta(x))*phi_dot^2 + g*sin(theta(x)) + cos(theta(x))*cos(phi)*y_t_ddot(x) + cos(theta(x))*sin(phi)*x_t_ddot(x)), x, 0, t, 'IgnoreSpecialCases', true)))/L
		phi0+int((exp(-(2*t*(L_dot + L*theta_dot*cot(theta)))/L)*(L*phi_dot_0*sin(theta) - int(exp((2*x*(L_dot + L*theta_dot*cot(theta)))/L)*(cos(phi(x))*x_t_ddot(x) - sin(phi(x))*y_t_ddot(x)), x, 0, t, 'IgnoreSpecialCases', true)))/(L*sin(theta)),t,0,t);...
		(exp(-(2*t*(L_dot + L*theta_dot*cot(theta)))/L)*(L*phi_dot_0*sin(theta) - int(exp((2*x*(L_dot + L*theta_dot*cot(theta)))/L)*(cos(phi(x))*x_t_ddot(x) - sin(phi(x))*y_t_ddot(x)), x, 0, t, 'IgnoreSpecialCases', true)))/(L*sin(theta));...
		L0 + int(L_dot0 +int(L_ddot,t,0,t) ,t,0,t);...
		L_dot0 +int(L_ddot,t,0,t)];
	
	fprintf('Lo stato iniziale considerato è: \n')
	x0 = subs(x_0, x_0, x0_num)
%%%1 
	fprintf('\n1) Se come uscita prendiamo la posizione del carico (massa appesa): \n')
	h = [x_ball, y_ball,  z_ball]	% osservabile r = 10
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(1) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(1) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(1) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['Un indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
	
	fprintf('\nOsservabilità con la matrice di sensibilità S: \n')
	S = jacobian(x_T, x_0) 
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

%%%2
	fprintf('\n2) Se come uscita prendiamo gli angoli theta e phi e la lunghezza dell''asta L: \n')
	h = [theta, phi, L]
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(2) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(2) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(2) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['Un indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
	
	fprintf('\nOsservabilità con la matrice di sensibilità S: \n')
	S = jacobian(x_T, x_0) 
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
	
%%%3
	fprintf('\n3) Se come uscita prendiamo la posizione del carrello e la lunghezza dell''asta L: \n')
	h = [x_t, y_t, L]									% non osservabile r = 6
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(3) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(3) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(3) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['Un indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
	
	fprintf('\nOsservabilità con la matrice di sensibilità S: \n')
	S = jacobian(x_T, x_0) 
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
	
	%%
%%%4 
	fprintf('\n4) Se come uscita prendiamo la posizione relativa della palla rispetto al carrello: \n')
	h = [x_ball-x_t, y_ball-y_t,  z_ball-z_t] 			% non osservabile r = 6
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(4) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(4) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(4) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['Un indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
	
	fprintf('\nOsservabilità con la matrice di sensibilità S: \n')
	S = jacobian(x_T, x_0) 
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

%%%5
	fprintf('\n5) Se come uscita prendiamo la posizione relativa della palla rispetto al carrello e la posizione del carrello: \n')
	h = [x_ball-x_t y_ball-y_t  z_ball-z_t, x_t, y_t] 	% osservabile r = 10
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(5) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(5) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(5) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['Un indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
	
	fprintf('\nOsservabilità con la matrice di sensibilità S: \n')
	S = jacobian(x_T, x_0) 
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
	
%%%6
	fprintf('\n6) Se come uscita prendiamo la posizione relativa della palla rispetto al carrello e le velocità del carrello: \n')
	h = [x_ball-x_t y_ball-y_t  z_ball-z_t, x_t_dot, y_t_dot]	% osservabile r = 8
	
	fprintf('Scegliendo una funzione di peso W per il Gramiano: \n')
	W = eye(size(h,1), size(h,1))
	
	fprintf('Il corrispondente Gramiano di osservabilità sarà: \n')
	Go = gramian_oss(h, x, W, x0, 'o')
	
	fprintf('\nAnalisi del rango del Gramiano\n')
	oss(6) = 1;
	for i = 1:length(T)-1
		Go_t = subs(Go, t, i*tstep);
		if rank(Go_t) < size(x,1)
			E = (svd(Go_t));
			eig_min = min(E);
			eig_max = max(E);
			num_cond = eig_max/eig_min;
			oss(6) = 0;
			fprintf(['Il sistema perde osservabilità: il minimo valore singolare vale ' num2str(eval(eig_min)) ' e il numero di condizionamento è ' num2str(eval(num_cond)) '\n'])
			break
		end
	end
	if oss(6) ==1
		fprintf('il sistema è localmente osservabile in x_0: il gramiano ha rango pieno righe  \n')
		E = svd(Go_t);
		eig_min = min(E);
		eig_max = max(E);
		num_cond = eig_max/eig_min;
		fprintf(['Un indice quantitativo di osservabilità è il numero di Condizionamento. Qua vale: ' num2str(eval(num_cond)) '\n'])
	end
	
	fprintf('\nOsservabilità con la matrice di sensibilità S: \n')
	S = jacobian(x_T, x_0) 
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
	
	fprintf('\n2) Spazio nullo del Gramiano: x_t_ddot=0, y_t_ddot=0, L_ddot(t) generica \n')
	fprintf('Valutazione dell''intersezione tra i nulli ai vari istanti temporali se non ho controllo sulla rotazione del veicolo \n')
	NGo_sw = null(subs(Go_s, x_t_ddot, 0)); %non ho modo di controllare la rotazione del veicolo
	NGo_sw = null(subs(Go_s, y_t_ddot, 0));
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
	%%
	
	x_T = [	x_t0+int(x_t_dot0+int(x_t_ddot,t,0,t) ,t,0,t);...
		x_t_dot0+int(x_t_ddot,t,0,t);...
		y_t0+int(y_t_dot0 + int(y_t_ddot ,t,0,t) ,t,0,t);...
		y_t_dot0+int(y_t_ddot ,t,0,t);...
		theta0+int((exp(-(t*(2*L_dot + L*b_smorza))/L)*(L*theta_dot_0 - int(exp((x*(2*L_dot + L*b_smorza))/L)*(- L*cos(theta(x))*sin(theta(x))*phi_dot^2 + g*sin(theta(x)) + cos(theta(x))*cos(phi)*y_t_ddot(x) + cos(theta(x))*sin(phi)*x_t_ddot(x)), x, 0, t, 'IgnoreSpecialCases', true)))/L,t,0,t);...
		(exp(-(t*(2*L_dot + L*b_smorza))/L)*(L*theta_dot_0 - int(exp((x*(2*L_dot + L*b_smorza))/L)*(- L*cos(theta(x))*sin(theta(x))*phi_dot^2 + g*sin(theta(x)) + cos(theta(x))*cos(phi)*y_t_ddot(x) + cos(theta(x))*sin(phi)*x_t_ddot(x)), x, 0, t, 'IgnoreSpecialCases', true)))/L
		phi0+int((exp(-(2*t*(L_dot + L*theta_dot*cot(theta)))/L)*(L*phi_dot_0*sin(theta) - int(exp((2*x*(L_dot + L*theta_dot*cot(theta)))/L)*(cos(phi(x))*x_t_ddot(x) - sin(phi(x))*y_t_ddot(x)), x, 0, t, 'IgnoreSpecialCases', true)))/(L*sin(theta)),t,0,t);...
		(exp(-(2*t*(L_dot + L*theta_dot*cot(theta)))/L)*(L*phi_dot_0*sin(theta) - int(exp((2*x*(L_dot + L*theta_dot*cot(theta)))/L)*(cos(phi(x))*x_t_ddot(x) - sin(phi(x))*y_t_ddot(x)), x, 0, t, 'IgnoreSpecialCases', true)))/(L*sin(theta));...
		L0 + int(L_dot0 +int(L_ddot,t,0,t) ,t,0,t);...
		L_dot0 +int(L_ddot,t,0,t)]

end


