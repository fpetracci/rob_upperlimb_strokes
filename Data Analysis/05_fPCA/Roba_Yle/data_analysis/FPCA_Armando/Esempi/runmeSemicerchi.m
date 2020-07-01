clear all
close all
clc
load semicerchi_PS_data;

%misuremark1=dati02(1).values;
misuremark1=dati02(1).values(200:(end-700),:); %toglie alcuni valori all'inizio e alla fine dell'esperimento

%% resampling, uno ogni 20
conta=0;
mark1=[];
for i=1:size(misuremark1,1)
	if( conta==20 )
		mark1=[mark1; misuremark1(i,:)];
		conta=1;
	else
		conta=conta+1;
	end
end
n=size(mark1,1);

misuremark2=dati02(2).values(200:(end-700),:);
conta=0;
mark2=[];
for i=1:size(misuremark2,1)
	if( conta==20 )
		mark2=[mark2; misuremark2(i,:)];
		conta=1;
	else
		conta=conta+1;
	end
end

misuremark3=dati02(3).values(200:(end-700),:);
conta=0;
mark3=[];
for i=1:size(misuremark3,1)
	if( conta==20 )
		mark3=[mark3; misuremark3(i,:)];
		conta=1;
	else
		conta=conta+1;
	end
end


misuremark4=dati04(1).values;
conta=0;
mark4=[];
for i=1:size(misuremark4,1)
	if( conta==floor(size(misuremark4,1)/n) )
		mark4=[mark4; misuremark4(i,:)];
		conta=1;
	else
		conta=conta+1;
	end
 end
 mark4=mark4(1:n,:);
 
misuremark5=dati04(2).values;
conta=0;
mark5=[];
for i=1:size(misuremark5,1)
	if( conta==floor(size(misuremark5,1)/n) )
		mark5=[mark5; misuremark5(i,:)];
		conta=1;
	else
		conta=conta+1;
	end
 end
 mark5=mark5(1:n,:);
 
misuremark6=dati04(3).values;
conta=0;
mark6=[];
for i=1:size(misuremark6,1)
	if( conta==floor(size(misuremark6,1)/n) )
		mark6=[mark6; misuremark6(i,:)];
		conta=1;
	else
		conta=conta+1;
	end
 end
 mark6=mark6(1:n,:);
 
[n,d]=size(mark1);

clearvars -except mark1 mark2 mark3 mark4 mark5 mark6 n
%% visual real marker


figure(1);
hold on;
for i=1:n
	clf
	plot3(mark1(1:i,1), mark1(1:i,2), mark1(1:i,3), 'bo');
    hold on;
    plot3(mark2(1:i,1), mark2(1:i,2), mark2(1:i,3), 'bo');
    plot3(mark3(1:i,1), mark3(1:i,2), mark3(1:i,3), 'bo');
    
	xlim([-500 500]);
	ylim([250 1150]);
	zlim([450 750]);

	xlabel('X')
	ylabel('Y')
	zlabel('Z')

	grid on;
	pause(0.001)	
end
hold on;
for i=1:n
	clf
    plot3(mark1(:,1), mark1(:,2), mark1(:,3), 'bo');
    hold on;
    plot3(mark2(:,1), mark2(:,2), mark2(:,3), 'bo');
    plot3(mark3(:,1), mark3(:,2), mark3(:,3), 'bo');
	plot3(mark4(1:i,1), mark4(1:i,2), mark4(1:i,3), 'bo');
    hold on;
    plot3(mark5(1:i,1), mark5(1:i,2), mark5(1:i,3), 'bo');
    plot3(mark6(1:i,1), mark6(1:i,2), mark6(1:i,3), 'bo');
    
	xlim([-500 500]);
	ylim([250 1150]);
	zlim([450 750]);

	xlabel('X')
	ylabel('Y')
	zlabel('Z')

	grid on;
	pause(0.001)
end

%%

pause

%grid on

matriceDati(:,1,:)=mark1;
matriceDati(:,2,:)=mark2;
matriceDati(:,3,:)=mark3;
matriceDati(:,4,:)=mark4;
matriceDati(:,5,:)=mark5;
matriceDati(:,6,:)=mark6;


% matriceDati(:,:,4) = matriceDati(:,:,1)+0.1*rand(1,1);
% matriceDati(:,:,5) = matriceDati(:,:,1)+0.1*rand(1,1);
% matriceDati(:,:,6) = matriceDati(:,:,1)+0.1*rand(1,1);
% matriceDati(:,:,7) = matriceDati(:,:,1)+0.1*rand(1,1);


%% pca
X=[mark1; mark2; mark3; mark4; mark5; mark6]';

[nrX, numDati]=size(X);
matrice_media=mean(X,2);
B=X-repmat(matrice_media,1,numDati);
C=(1/(numDati-1))*B*B';
[S,L,St]=svd(C); %[COEFF,latent,explained]=pcacov(C) %comando equivalente
synMat=S;
autovalori=diag(L);
somma_autovalori= sum(autovalori);
varianza_coperta=sum(autovalori(1))/somma_autovalori

vbls = {'X*','Y*','Z*'};
figure(2)
axis equal
biplot(S,'scores',zscore(X'),'varlabels',vbls);

pause

%% fpca


matriceDati



frequenza=10;
intervallo=[0, n/frequenza];
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 13,5)
oggettoFD = calcolaCurve(t, matriceDati, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);


lista_pca_nr = calcolaFPCA(oggettoFD,3);
FD = lista_pca_nr.fd
pc1 = FD.fPCA{1};
pc2 = FD.fPCA{2};
pc3 = FD.fPCA{3};




close all
%plot3(X(1,:),X(2,:),X(3,:),'r.'); grid on; hold on
%figure(1)
%plot_pca(lista_pca_nr);



figure(2)
plot3(pc2(:,1),pc2(:,2),pc2(:,3), 'r');
grid on;
title('Seconda Componente Princ');

figure(3)
plot3(pc3(:,1),pc3(:,2),pc3(:,3), 'g');
title('Terza Componente Princ');
grid on;

figure(1)
plot3(pc1(:,1),pc1(:,2),pc1(:,3), 'b');
grid on;
title('Prima Componente Princ');

disp(' ');
disp(['VARIANZA COPERTA PC1 ', num2str(lista_pca_nr.perc_varianza(1)) ]);

pause

%% Approssimazione Curve utilizzando FPCA
close all
scores=lista_pca_nr.componenti;
media=lista_pca_nr.media;


sc11=scores(1,1);
sc12=scores(1,2);
sc13=scores(1,3);

PC1=[sc11.*pc1(:,1)+media(:,1), sc11.*pc1(:,2)+media(:,2), sc11.*pc1(:,3)+media(:,3)];
plot3(PC1(:,1), PC1(:,2), PC1(:,3), 'b');
hold on;
plot3(mark1(:,1), mark1(:,2), mark1(:,3), 'r');
legend('1 Componente Principale','Curva Originale');
grid on;

pause
clf

PC12=[sc11.*pc1(:,1)+sc12.*pc2(:,1)+ media(:,1), sc11.*pc1(:,2)+sc12.*pc2(:,2)+media(:,2), sc11.*pc1(:,3)+sc12.*pc2(:,3)+media(:,3)];
plot3(PC12(:,1), PC12(:,2), PC12(:,3), 'b');
hold on;
plot3(mark1(:,1), mark1(:,2), mark1(:,3), 'r');
legend('2 Componenti Principali','Curva Originale');
grid on;

pause
clf
PC123=[sc11.*pc1(:,1)+sc12.*pc2(:,1)+sc13.*pc3(:,1)+ media(:,1), sc11.*pc1(:,2)+sc12.*pc2(:,2)+sc13.*pc3(:,2)+media(:,2), sc11.*pc1(:,3)+sc12.*pc2(:,3)+sc13.*pc3(:,3)+media(:,3)];
plot3(PC123(:,1), PC123(:,2), PC123(:,3), 'b');
hold on;
plot3(mark1(:,1), mark1(:,2), mark1(:,3), 'r');
legend('3 Componenti Principali','Curva Originale');
grid on;



pause

%% Approssimazione curve utilizzando PCA
close all
Srid=S(:,1);
Os=[]; 
for i=1:size(mark1,1)
	Os_temp=Srid'*(transp(mark1(i,:))-matrice_media);
	Os=[Os; Os_temp'];
end
stimaCurva=[];
for i=1:size(Os,1)
	stima_temp=Srid*transp(Os(i,:))+matrice_media;
	stimaCurva=[stimaCurva; transp(stima_temp)];
end
plot3(stimaCurva(:,1),stimaCurva(:,2),stimaCurva(:,3), 'b.'); grid on;
hold on;
plot3(mark1(:,1), mark1(:,2), mark1(:,3), 'r');
legend('1 Componente Principale','Curva Originale');

pause
clf
Srid=S(:,1:2);
Os=[];
for i=1:size(mark1,1)
	Os_temp=Srid'*(transp(mark1(i,:))-matrice_media);
	Os=[Os; Os_temp'];
end

stimaCurva=[];
for i=1:size(Os,1)
	stima_temp=Srid*transp(Os(i,:))+matrice_media;
	stimaCurva=[stimaCurva; transp(stima_temp)];
end
plot3(stimaCurva(:,1),stimaCurva(:,2),stimaCurva(:,3), 'b.'); grid on;
hold on;
plot3(mark1(:,1), mark1(:,2), mark1(:,3), 'r');
legend('2 Componenti Principali','Curva Originale');

pause
clf

Srid=S(:,1:3);
Os=[];
for i=1:size(mark1,1)
	Os_temp=Srid'*(transp(mark1(i,:))-matrice_media);
	Os=[Os; Os_temp'];
end

stimaCurva=[];
for i=1:size(Os,1)
	stima_temp=Srid*transp(Os(i,:))+matrice_media;
	stimaCurva=[stimaCurva; transp(stima_temp)];
end
plot3(stimaCurva(:,1),stimaCurva(:,2),stimaCurva(:,3), 'b.'); grid on;
hold on;
plot3(mark1(:,1), mark1(:,2), mark1(:,3), 'r');
legend('3 Componenti Principali','Curva Originale');
