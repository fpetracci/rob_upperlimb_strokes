function [s2_new] = TimeWarping(s1,s2)
%% Calcolo parametri di Time Shift e Stretch migliori

% s1 movimento di riferimento
% s2 movimento da modificare
s1 = healthy_task_q(1).subject(1).left_side_trial(1).q_grad ;
s2 = healthy_task_q(2).subject(1).left_side_trial(1).q_grad ;
trial = s2;
%creazione parametri per modificare s2 DA GUARDARE PER OTTIMIZZARE
rapp = length(s2(1,:))/length(s1(1,:));
tshtmp = round(length(s2(1,:))/5);
TShift = round(linspace(-tshtmp,tshtmp,10));
NShap  = linspace(0.5,1.1,20);

%creazione variabile vuota
ObjVal = zeros(length(TShift),length(NShap));

for i=1:length(TShift(1,:))
    for j=1:length(NShap)
        s1tmp = s1;
        s2tmp = s2;
        
        %%%%%%%%%%%%%%%%%%%%%%% Stretch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        time = 1 : length(s2tmp(1,:));
        nel = length(time);
        ts1 = timeseries(s2tmp(1,:),time); % 7 perchè è l'angolo scelto su cui fare il calcolo dei parametri
%         ts2 = timeseries(s2tmp(2,:),time); 
%         ts3 = timeseries(s2tmp(3,:),time); 
%         ts4 = timeseries(s2tmp(4,:),time); 
%         ts5 = timeseries(s2tmp(5,:),time); 
%         ts6 = timeseries(s2tmp(6,:),time);
%         
        %Creazione nuovo asse temporale
        timenew = linspace(time(1),time(end),ceil(nel*NShap(j))); % ceil() -> arrotondamento per eccesso
        
        ts1r = resample(ts1,timenew); 
%         ts2r = resample(ts2,timenew); 
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
        s2tmp = ts1r.data(:)';
        
        %%%%%%%%%%%%%%%%%%%%%%% Time Shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if TShift(i) >= 0
            % Con shift positivo aggiunge n=TShift(i) misure uguali al valore
            % del primo frame in testa al vettore delle misure (ritarda il
            % segnale)
            tmpv1 = [ones(1, TShift(i))*s2tmp(1,1) s2tmp(1,:)]; 
%             tmpv2 = [ones(1, TShift(i))*s2tmp(2,1) s2tmp(2,:)]; 
%             tmpv3 = [ones(1, TShift(i))*s2tmp(3,1) s2tmp(3,:)]; 
%             tmpv4 = [ones(1, TShift(i))*s2tmp(4,1) s2tmp(4,:)]; 
%             tmpv5 = [ones(1, TShift(i))*s2tmp(5,1) s2tmp(5,:)]; 
%             tmpv6 = [ones(1, TShift(i))*s2tmp(6,1) s2tmp(6,:)];
%             s2tmp = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6];
            s2tmp = tmpv1;
        elseif TShift(i) < 0
            % Con shift negativo taglia i primi n=TShift(i) campioni dalla
            % misura
%             s2tmp = [s2tmp(1,abs(TShift(i)):end); ...
%                      s2tmp(2,abs(TShift(i)):end); ...
%                      s2tmp(3,abs(TShift(i)):end); ...
%                      s2tmp(4,abs(TShift(i)):end); ...
%                      s2tmp(5,abs(TShift(i)):end); ...
%                      s2tmp(6,abs(TShift(i)):end)];
            s2tmp = s2tmp(1,abs(TShift(i)):end);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%% Complete %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ls1 = length(s1tmp(1,:));
        Ls2 = length(s2tmp(1,:));
        
        %Uniforma le lunghezze di s1 e s2
        if Ls1 > Ls2
            %Allunga s2 copiando in coda Ls1-Ls2 volte l'ultimo valore del
            %segnale
            tmpv1 = [s2tmp(1,:) ones(1,Ls1-Ls2)*s2tmp(1,end)]; 
%             tmpv2 = [s2tmp(2,:) ones(1,Ls1-Ls2)*s2tmp(2,end)]; 
%             tmpv3 = [s2tmp(3,:) ones(1,Ls1-Ls2)*s2tmp(3,end)]; 
%             tmpv4 = [s2tmp(4,:) ones(1,Ls1-Ls2)*s2tmp(4,end)]; 
%             tmpv5 = [s2tmp(5,:) ones(1,Ls1-Ls2)*s2tmp(5,end)]; 
%             tmpv6 = [s2tmp(6,:) ones(1,Ls1-Ls2)*s2tmp(6,end)];
%             s2tmp = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6];
            s2tmp = tmpv1;
            
        elseif Ls1 < Ls2
            %Taglia gli ultimi valori di s2 per arrivare alla lunghezza di
            %s1
%             s2tmp = [s2tmp(1,1:Ls1);...
%                      s2tmp(2,1:Ls1);...
%                      s2tmp(3,1:Ls1);...
%                      s2tmp(4,1:Ls1);...
%                      s2tmp(5,1:Ls1);...
%                      s2tmp(6,1:Ls1)];
        s2tmp = s2tmp(1,1:Ls1);
        end
        
        A1 = [s1tmp(1,:)' s2tmp(1,:)'];
%         A2 = [s1tmp(2,:)' s2tmp(2,:)'];
%         A3 = [s1tmp(3,:)' s2tmp(3,:)'];
%         A4 = [s1tmp(4,:)' s2tmp(4,:)'];
%         A5 = [s1tmp(5,:)' s2tmp(5,:)'];
%         A6 = [s1tmp(6,:)' s2tmp(6,:)'];
        
        %Calcolo delle matrici dei coefficienti di correlazione fra s1 e s2
        matrix1 = corrcoef(A1);
%         matrix2 = corrcoef(A2);
%         matrix3 = corrcoef(A3);
%         matrix4 = corrcoef(A4);
%         matrix5 = corrcoef(A5);
%         matrix6 = corrcoef(A6);
        
        %Si salva il massimo dei coefficienti di correlazione in posto
        %(1,2) [Non so perchè sceglie quel posto]
        %ObjVal(i,j) = max([matrix1(1,2) matrix2(1,2) matrix3(1,2) matrix4(1,2) matrix5(1,2) matrix6(1,2)]);
        ObjVal(i,j) = matrix1(1,2);
    end
end

%Estrae i valori di stretch e time shift migliori in termini di
%correlazione dei segnali
[~,I] = max(ObjVal(:));
[I_row, I_col] = ind2sub(size(ObjVal),I);

%% Modifica del segnale s2

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

%Uniforma le lunghezze di s1 e s2
if Ls1 > Ls2
    %Allunga s2 copiando in coda Ls1-Ls2 volte l'ultimo valore del
    %segnale
    tmpv1 = [s2(1,:) ones(1,Ls1-Ls2)*s2(1,end)]; 
    tmpv2 = [s2(2,:) ones(1,Ls1-Ls2)*s2(2,end)]; 
    tmpv3 = [s2(3,:) ones(1,Ls1-Ls2)*s2(3,end)]; 
    tmpv4 = [s2(4,:) ones(1,Ls1-Ls2)*s2(4,end)]; 
    tmpv5 = [s2(5,:) ones(1,Ls1-Ls2)*s2(5,end)]; 
    tmpv6 = [s2(6,:) ones(1,Ls1-Ls2)*s2(6,end)];
	tmpv7 = [s2(7,:) ones(1,Ls1-Ls2)*s2(7,end)]; 
    tmpv8 = [s2(8,:) ones(1,Ls1-Ls2)*s2(8,end)]; 
    tmpv9 = [s2(9,:) ones(1,Ls1-Ls2)*s2(9,end)];
	tmpv10 = [s2(10,:) ones(1,Ls1-Ls2)*s2(10,end)];

   s2 = [tmpv1; tmpv2; tmpv3; tmpv4; tmpv5; tmpv6;...
		 tmpv7; tmpv8; tmpv9; tmpv10];
elseif Ls1 <Ls2
    %Taglia gli ultimi valori di s2 per arrivare alla lunghezza di s1
    s2 = [s2(1,1:Ls1);...
          s2(2,1:Ls1);...
          s2(3,1:Ls1);...
          s2(4,1:Ls1);...
          s2(5,1:Ls1);...
		  s2(6,1:Ls1);...
          s2(7,1:Ls1);...
          s2(8,1:Ls1);...
          s2(9,1:Ls1);...
          s2(10,1:Ls1)];
end

%Salva s2 modificato nell'output
s2_new = s2;
figure(1)
plot(s1')
figure(2)
plot(s2_new')
figure(3)
plot(trial')
end