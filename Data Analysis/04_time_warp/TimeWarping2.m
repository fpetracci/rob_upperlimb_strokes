function s2_new = TimeWarping2(s1,s2)
% This function bla bla

%% Calcolo parametri di Time Shift e Stretch migliori
%  the function take as input 2 joints angle struct, each struct is
%  composed by 10 joint angle. We chosed the 7th angular joint as the
%  referement forchoose the optimale strech and shift parameters

% s1 movimento di riferimento
% s2 movimento da modificare

%trial = s2;
%creazione parametri per modificare s2 DA GUARDARE PER OTTIMIZZARE
rapp = length(s1(1,:))/length(s2(1,:));
tshtmp = round(length(s2(1,:))/8);
TShift = round(linspace(-tshtmp,tshtmp,20));
NShap  = linspace(0.8*rapp,1.2*rapp,30);

%creazione variabile vuota
ObjVal = zeros(length(TShift),length(NShap));

for i=1:length(TShift(1,:))
    for j=1:length(NShap)
        s1tmp = s1;
        s2tmp = s2;
        
        %%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        time = 1 : length(s2tmp(1,:));
        nel = length(time);
        ts4 = timeseries(s2tmp(4,:),time); % 7 perchè è l'angolo scelto su cui fare il calcolo dei parametri
        ts7 = timeseries(s2tmp(7,:),time); 
%         ts3 = timeseries(s2tmp(3,:),time); 
%         ts4 = timeseries(s2tmp(4,:),time); 
%         ts5 = timeseries(s2tmp(5,:),time); 
%         ts6 = timeseries(s2tmp(6,:),time);
%         
        %Creazione nuovo asse temporale
        timenew = linspace(time(1),time(end),ceil(nel*NShap(j))); % ceil() -> arrotondamento per eccesso
        
        ts4r = resample(ts4,timenew); 
        ts7r = resample(ts7,timenew); 
%         ts3r = resample(ts3,timenew); 
%         ts4r = resample(ts4,timenew); 
%         ts5r = resample(ts5,timenew); 
%         ts6r = resample(ts6,timenew);
        
%         s2tmp = [ts1r.data(:)';...
%                  ts2r.data(:)';...
%                  ts3r.data(:)';...
%                  ts4r.data(:)';...
%                  ts5r.data(:)';...
%                  ts6r.data(:)'];
        s2tmp = [ts4r.data(:)';...
				 ts7r.data(:)'];
        
        %%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if TShift(i) >= 0
            % Con shift positivo aggiunge n=TShift(i) misure uguali al valore
            % del primo frame in testa al vettore delle misure (ritarda il
            % segnale)
            tmpv4 = [ones(1, TShift(i))*s2tmp(1,1) s2tmp(1,:)]; 
            tmpv7 = [ones(1, TShift(i))*s2tmp(2,1) s2tmp(2,:)]; 
%             tmpv3 = [ones(1, TShift(i))*s2tmp(3,1) s2tmp(3,:)]; 
%             tmpv4 = [ones(1, TShift(i))*s2tmp(4,1) s2tmp(4,:)]; 
%             tmpv5 = [ones(1, TShift(i))*s2tmp(5,1) s2tmp(5,:)]; 
%             tmpv6 = [ones(1, TShift(i))*s2tmp(6,1) s2tmp(6,:)];
%             s2tmp = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6];
            s2tmp = [tmpv4; tmpv7];
        elseif TShift(i) < 0
            % Con shift negativo taglia i primi n=TShift(i) campioni dalla
            % misura
%             s2tmp = [s2tmp(1,abs(TShift(i)):end); ...
%                      s2tmp(2,abs(TShift(i)):end); ...
%                      s2tmp(3,abs(TShift(i)):end); ...
%                      s2tmp(4,abs(TShift(i)):end); ...
%                      s2tmp(5,abs(TShift(i)):end); ...
%                      s2tmp(6,abs(TShift(i)):end)];
            s2tmp = [s2tmp(1,abs(TShift(i)):end);...
					 s2tmp(2,abs(TShift(i)):end)];
        end
        
        %%%%%%%%%%%%%%%%%%%%%%% Complete %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ls1 = length(s1tmp(1,:));
        Ls2 = length(s2tmp(1,:));
        
        %Uniforma le lunghezze di s1 e s2
        if Ls1 > Ls2
            %Allunga s2 copiando in coda Ls1-Ls2 volte l'ultimo valore del
            %segnale
            tmpv4 = [s2tmp(1,:) ones(1,Ls1-Ls2)*s2tmp(1,end)]; 
            tmpv7 = [s2tmp(2,:) ones(1,Ls1-Ls2)*s2tmp(2,end)]; 
%             tmpv3 = [s2tmp(3,:) ones(1,Ls1-Ls2)*s2tmp(3,end)]; 
%             tmpv4 = [s2tmp(4,:) ones(1,Ls1-Ls2)*s2tmp(4,end)]; 
%             tmpv5 = [s2tmp(5,:) ones(1,Ls1-Ls2)*s2tmp(5,end)]; 
%             tmpv6 = [s2tmp(6,:) ones(1,Ls1-Ls2)*s2tmp(6,end)];
%             s2tmp = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6];
            s2tmp = [tmpv4;tmpv7];
            
        elseif Ls1 < Ls2
            %Taglia gli ultimi valori di s2 per arrivare alla lunghezza di
            %s1
%             s2tmp = [s2tmp(1,1:Ls1);...
%                      s2tmp(2,1:Ls1);...
%                      s2tmp(3,1:Ls1);...
%                      s2tmp(4,1:Ls1);...
%                      s2tmp(5,1:Ls1);...
%                      s2tmp(6,1:Ls1)];
        s2tmp = [s2tmp(1,1:Ls1);...
				 s2tmp(2,1:Ls1)];
        end
        
        A4 = [s1tmp(4,:)' s2tmp(1,:)'];
        A7 = [s1tmp(7,:)' s2tmp(2,:)'];
%         A3 = [s1tmp(3,:)' s2tmp(3,:)'];
%         A4 = [s1tmp(4,:)' s2tmp(4,:)'];
%         A5 = [s1tmp(5,:)' s2tmp(5,:)'];
%         A6 = [s1tmp(6,:)' s2tmp(6,:)'];
        
        %Calcolo delle matrici dei coefficienti di correlazione fra s1 e s2
        matrix4 = corrcoef(A4);
        matrix7 = corrcoef(A7);
% 		disp(matrix4(1,2))
% 		disp(matrix7(1,2))
%         matrix3 = corrcoef(A3);
%         matrix4 = corrcoef(A4);
%         matrix5 = corrcoef(A5);
%         matrix6 = corrcoef(A6);
        
        %Si salva il massimo dei coefficienti di correlazione in posto
        %(1,2) [Non so perchè sceglie quel posto]
        %ObjVal(i,j) = max([matrix1(1,2) matrix2(1,2) matrix3(1,2) matrix4(1,2) matrix5(1,2) matrix6(1,2)]);
        ObjVal(i,j) = max([matrix4(1,2) matrix7(1,2)]);
    end
end

%Estrae i valori di stretch e time shift migliori in termini di
%correlazione dei segnali
[~,I] = max(ObjVal(:));
[I_row, I_col] = ind2sub(size(ObjVal),I);

%% Modifica del segnale s2

if (max(ObjVal(:))) > 0.8

		%%%%%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		time = 1 : length(s2(1,:));
		nel = length(time);
		ts1 = timeseries(s2(1,:),time);
		ts2 = timeseries(s2(2,:),time);
		ts3 = timeseries(s2(3,:),time);
		ts4 = timeseries(s2(4,:),time);
		ts5 = timeseries(s2(5,:),time);
		ts6 = timeseries(s2(6,:),time);
		ts7 = timeseries(s2(7,:),time);
		ts8 = timeseries(s2(8,:),time);
		ts9 = timeseries(s2(9,:),time);
		ts10 = timeseries(s2(10,:),time);

		%Nuovo asse temporale "stretchato"
		timenew = linspace(time(1),time(end),ceil(nel*NShap(I_col)));

		ts1r = resample(ts1,timenew);
		ts2r = resample(ts2,timenew);
		ts3r = resample(ts3,timenew);
		ts4r = resample(ts4,timenew);
		ts5r = resample(ts5,timenew);
		ts6r = resample(ts6,timenew);
		ts7r = resample(ts7,timenew);
		ts8r = resample(ts8,timenew);
		ts9r = resample(ts9,timenew);
		ts10r = resample(ts10,timenew);

		s2 = [ts1r.data(:)';...
			ts2r.data(:)';...
			ts3r.data(:)';...
			ts4r.data(:)';...
			ts5r.data(:)';...
			ts6r.data(:)';...
			ts7r.data(:)';...
			ts8r.data(:)';...
			ts9r.data(:)';...
			ts10r.data(:)'];
		%%%%%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		if TShift(I_row) >= 0
			% Con shift positivo aggiunge n=TShift(i) misure uguali al valore
			% del primo frame in testa al vettore delle misure (ritarda il
			% segnale)
			%YLE
			tmpv1 =  [ones(1, TShift(I_row))*s2(1,1) s2(1,:)];
			tmpv2 =  [ones(1, TShift(I_row))*s2(2,1) s2(2,:)];
			tmpv3 =  [ones(1, TShift(I_row))*s2(3,1) s2(3,:)];
			tmpv4 =  [ones(1, TShift(I_row))*s2(4,1) s2(4,:)];
			tmpv5 =  [ones(1, TShift(I_row))*s2(5,1) s2(5,:)];
			tmpv6 =  [ones(1, TShift(I_row))*s2(6,1) s2(6,:)];
			tmpv7 =  [ones(1, TShift(I_row))*s2(7,1) s2(7,:)];
			tmpv8 =  [ones(1, TShift(I_row))*s2(8,1) s2(8,:)];
			tmpv9 =  [ones(1, TShift(I_row))*s2(9,1) s2(9,:)];
			tmpv10 = [ones(1, TShift(I_row))*s2(10,1) s2(10,:)];


			s2 = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6;...
				tmpv7; tmpv8; tmpv9; tmpv10];

		elseif TShift(I_row) < 0
			% Con shift negativo taglia i primi n=TShift(i) campioni dalla
			% misura
			s2 = [s2(1,abs(TShift(I_row)):end);...
				s2(2,abs(TShift(I_row)):end);...
				s2(3,abs(TShift(I_row)):end);...
				s2(4,abs(TShift(I_row)):end);...
				s2(5,abs(TShift(I_row)):end);...
				s2(6,abs(TShift(I_row)):end);...
				s2(7,abs(TShift(I_row)):end);...
				s2(8,abs(TShift(I_row)):end);...
				s2(9,abs(TShift(I_row)):end);...
				s2(10,abs(TShift(I_row)):end)];
		end

		%%%%%%%%%%%%%%%%%%%%%%%%%% Complete %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		Ls1 = length(s1(1,:));
		Ls2 = length(s2(1,:));
		
		[skip_init, skip_end] = find_skip(s2);
		
		%
		
		if Ls1 < skip_end
			s2_tmp = s2(:, skip_init:skip_end);
			s2_tmp = resample(s2',250,length(s2_tmp))';
			s2_tmp = s2_tmp(:,6:end-5);
			s2 = s2_tmp;
		elseif Ls1 >= skip_end
			%Allunga s2 copiando in coda Ls1-skip_end volte l'ultimo valore del
			%segnale
			tmpv1 = [s2(1,1:skip_end) ones(1,Ls1-skip_end)*s2(1,skip_end)];
			tmpv2 = [s2(2,1:skip_end) ones(1,Ls1-skip_end)*s2(2,skip_end)];
			tmpv3 = [s2(3,1:skip_end) ones(1,Ls1-skip_end)*s2(3,skip_end)];
			tmpv4 = [s2(4,1:skip_end) ones(1,Ls1-skip_end)*s2(4,skip_end)];
			tmpv5 = [s2(5,1:skip_end) ones(1,Ls1-skip_end)*s2(5,skip_end)];
			tmpv6 = [s2(6,1:skip_end) ones(1,Ls1-skip_end)*s2(6,skip_end)];
			tmpv7 = [s2(7,1:skip_end) ones(1,Ls1-skip_end)*s2(7,skip_end)];
			tmpv8 = [s2(8,1:skip_end) ones(1,Ls1-skip_end)*s2(8,skip_end)];
			tmpv9 = [s2(9,1:skip_end) ones(1,Ls1-skip_end)*s2(9,skip_end)];
			tmpv10 = [s2(10,1:skip_end) ones(1,Ls1-skip_end)*s2(10,skip_end)];

			s2 = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6;...
				tmpv7; tmpv8; tmpv9; tmpv10];
			
		end
else
	%Nuovo asse temporale "stretchato"
		%tsin = timeseries(s1);
		tsout = resample(s2',250,length(s2))';
		tsout = tsout(:,6:end-5);
		s2 = tsout;
		disp([ 'solo reshape, max corr = ' num2str(max(ObjVal(:)))])
end

s2_new = s2;
end


function [skip_init, skip_end] = find_skip(s)
%% load signal
% 	skip = 15;			% time samples skip to avoid errors at end and start of the trial
% 	s = correct2pi_err(s(:,skip:end-skip));
	s_dot = diff(s')';	% derivative of s (with unit frequency)
	s_dot = [s_dot, s_dot(:,end)]; % added last time sample to have s2_dot same
	% dimensions as s
	l_s = size(s,2);	% number of time sample in the chosen trial
	
	%% parameters to cut signal
	
	n_check		= 70;		% number of time sample in which we check abs(s2_dot) < bound
	flag_init	= 0;		% flag to end the search of initial time sample to cut
	flag_end	= 0;		% flag to end the search of final time sample to cut
	skip_init	= 1;		% store initial time sample from which start timewarping
	skip_end	= l_s;		% store final time sample from which start timewarping
	bound		= 0.05;		% bound of s_dot inside of which we consider the arm is not moving
	
	%% cut indexes
	% from the init find the last input for the significant signal
	for i = 1:n_check
		if   (abs(s_dot(4,i)) < bound && abs(s_dot(7,i)) < bound) && flag_init == 0
			skip_init = i;
		else
			flag_init = 1;
		end
		
		if  ( abs((s_dot(4,end - i)) < bound && abs(s_dot(7,end - i)) < bound) ) && flag_end == 0
			skip_end = l_s - i;
		else
			flag_end = 1;
		end
	end
	
end
