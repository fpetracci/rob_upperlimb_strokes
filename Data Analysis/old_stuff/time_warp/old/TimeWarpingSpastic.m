function [s2_new] = TimeWarpingSpastic(s1,s2)
% time warping from stratch
% this time warping has the aim to take as input a signal, it doesn't
% matter the length, we want to take all the sample to 240 samples
	
	%% load signal
	skip = 15;			% time samples skip to avoid errors at end and start of the trial
	s2 = correct2pi_err(s2(:,skip:end-skip));
	s2_dot = diff(s2')';	% derivative of s2 (with unit frequency)
	s2_dot = [s2_dot, s2_dot(:,end)]; % added last time sample to have s2_dot same
	% dimensions as s2
	l_s2 = size(s2,2);	% number of time sample in the chosen trial
	
	%% parameters to cut s2 signal
	
	n_check		= 70;		% number of time sample in which we check abs(s2_dot) < bound
	flag_init	= 0;		% flag to end the search of initial time sample to cut
	flag_end	= 0;		% flag to end the search of final time sample to cut
	skip_init	= 1;		% store initial time sample from which start timewarping
	skip_end	= l_s2;		% store final time sample from which start timewarping
	bound		= 0.05;		% bound of s2_dot inside of which we think the arm is not moving
	
	%% cut indexes
	% from the init find the last input for the significant signal
	for i = 1:n_check
		if   abs(s2_dot(4,i)) < bound && abs(s2_dot(7,i)) < bound && flag_init == 0
			skip_init = i;
		else
			flag_init = 1;
		end
		
		if   abs((s2_dot(4,end - i)) < bound && abs(s2_dot(7,end - i)) < bound) && flag_end == 0
			skip_end = l_s2 - i;
		else
			flag_end = 1;
		end
	end
	
%% cut
%s2_new = s2(:, skip_init:skip_end);

%% Time Warping

% init parameter
tshtmp = round(length(s2(1,:))/8);
TShift = round(linspace(-tshtmp,tshtmp,10));
NShap  = linspace(0.4,1.5,15); % 240*0.4 = 96,240*1.5 = 360
ObjVal = zeros(length(TShift),length(NShap));

%% max correlation indexes
for i=1:length(TShift(1,:))
    for j=1:length(NShap)
        s1tmp = s1;
        s2tmp = s2;
        
        %%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        time = 1 : length(s2tmp(1,:));
        nel = length(time);
        ts4 = timeseries(s2tmp(4,:),time); 
        ts7 = timeseries(s2tmp(7,:),time); 
		
        % new time axis with right subdivisions
        timenew = linspace(time(1),time(end),ceil(nel*NShap(j)));
        
		% resample of signals
        ts4r = resample(ts4,timenew); 
        ts7r = resample(ts7,timenew); 
        
		% reconstruction of s2 (temporary)
        s2tmp = [ts4r.data(:)';...
				 ts7r.data(:)'];
        
        %%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if TShift(i) >= 0
            % Con shift positivo aggiunge n=TShift(i) misure uguali al valore
            % del primo frame in testa al vettore delle misure (ritarda il
            % segnale)
            tmpv4 = [ones(1, TShift(i))*s2tmp(1,1) s2tmp(1,:)]; 
            tmpv7 = [ones(1, TShift(i))*s2tmp(2,1) s2tmp(2,:)]; 
			
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
        
		if 
		
        %Uniforma le lunghezze di s1 e s2
        if Ls1 > Ls2
            %Allunga s2 copiando in coda Ls1-Ls2 volte l'ultimo valore del
            %segnale
            tmpv4 = [s2tmp(1,:) ones(1,Ls1-Ls2)*s2tmp(1,end)]; 
            tmpv7 = [s2tmp(2,:) ones(1,Ls1-Ls2)*s2tmp(2,end)]; 
            s2tmp = [tmpv4;tmpv7];
            
        elseif Ls1 < Ls2
            %Taglia gli ultimi valori di s2 per arrivare alla lunghezza di
            %s1
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

	
	
%% debug	
% figure(1)
% plot(s2([4 7],:)')
% hold on
% %plot(s2_new([4 7],:)')
% plot(skip_init, s2(4,skip_init), 'bo')
% plot(skip_end, s2(4,skip_end), 'ro')
% text(skip_init, s2(4,skip_init)-10, num2str(skip_init))
% text(skip_end, s2(4,skip_end)-10, num2str(skip_end))

% figure(2)
% plot(s2_dot([4 7], :)')
end
