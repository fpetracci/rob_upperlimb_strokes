function [ lista_pca_nr_dof1, lista_pca_nr_dof2, lista_pca_nr_dof3, lista_pca_nr_dof4, lista_pca_nr_dof5, lista_pca_nr_dof6, lista_pca_nr_dof7 ] = calculate_fpca_mine( Actual_Dataset)
tmp = Actual_Dataset{1};
numframe = length(tmp(1,:));%length of each vector
numdata = size(Actual_Dataset,1);%how many data i havea
numgdl = 1;
%% case 1

Dataset_fpca = zeros(numframe,numdata,numgdl);
grado = 1;

for i = 1 : numdata
    tmp = Actual_Dataset{i};   
    j = 1;
    vector_j = tmp(j + grado - 1,:);
    if ~isnan(vector_j)
        Dataset_fpca(:,i,j) = vector_j';
    else 
        Dataset_fpca(:,i,j) = zeros(1,numframe);
    end    
end

n = numframe;
frequenza=1;
intervallo=[0, n/frequenza];
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 15, 5);
oggettoFD = calcolaCurve(t, Dataset_fpca, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);


lista_pca_nr_dof1 = calcolaFPCA(oggettoFD,15);%lista_pca_nr = calcolaFPCA(oggettoFD,4);

%% case 2

Dataset_fpca = zeros(numframe,numdata,numgdl);
grado = 2;

for i = 1 : numdata
    tmp = Actual_Dataset{i};   
    j = 1;
    vector_j = tmp(j + grado - 1,:);
    if ~isnan(vector_j)
        Dataset_fpca(:,i,j) = vector_j';
    else 
        Dataset_fpca(:,i,j) = zeros(1,numframe);
    end    
end

n = numframe;
frequenza=1;
intervallo=[0, n/frequenza];
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 15, 5);
oggettoFD = calcolaCurve(t, Dataset_fpca, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);


lista_pca_nr_dof2 = calcolaFPCA(oggettoFD,15);%lista_pca_nr = calcolaFPCA(oggettoFD,4);

%% case 3

Dataset_fpca = zeros(numframe,numdata,numgdl);
grado = 3;

for i = 1 : numdata
    tmp = Actual_Dataset{i};   
    j = 1;
    vector_j = tmp(j + grado - 1,:);
    if ~isnan(vector_j)
        Dataset_fpca(:,i,j) = vector_j';
    else 
        Dataset_fpca(:,i,j) = zeros(1,numframe);
    end    
end

n = numframe;
frequenza=1;
intervallo=[0, n/frequenza];
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 15, 5);
oggettoFD = calcolaCurve(t, Dataset_fpca, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);

lista_pca_nr_dof3 = calcolaFPCA(oggettoFD,15);%lista_pca_nr = calcolaFPCA(oggettoFD,4);
%% case 4

Dataset_fpca = zeros(numframe,numdata,numgdl);
grado = 4;

for i = 1 : numdata
    tmp = Actual_Dataset{i};   
    j = 1;
    vector_j = tmp(j + grado - 1,:);
    if ~isnan(vector_j)
        Dataset_fpca(:,i,j) = vector_j';
    else 
        Dataset_fpca(:,i,j) = zeros(1,numframe);
    end    
end

n = numframe;
frequenza=1;
intervallo=[0, n/frequenza];
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 15, 5);
oggettoFD = calcolaCurve(t, Dataset_fpca, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);

lista_pca_nr_dof4 = calcolaFPCA(oggettoFD,15);%lista_pca_nr = calcolaFPCA(oggettoFD,4);
%% case 5

Dataset_fpca = zeros(numframe,numdata,numgdl);
grado = 5;

for i = 1 : numdata
    tmp = Actual_Dataset{i};   
    j = 1;
    vector_j = tmp(j + grado - 1,:);
    if ~isnan(vector_j)
        Dataset_fpca(:,i,j) = vector_j';
    else 
        Dataset_fpca(:,i,j) = zeros(1,numframe);
    end    
end

n = numframe;
frequenza=1;
intervallo=[0, n/frequenza];
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 15, 5);
oggettoFD = calcolaCurve(t, Dataset_fpca, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);

lista_pca_nr_dof5 = calcolaFPCA(oggettoFD,15);%lista_pca_nr = calcolaFPCA(oggettoFD,4);
%% case 6

Dataset_fpca = zeros(numframe,numdata,numgdl);
grado = 6;

for i = 1 : numdata
    tmp = Actual_Dataset{i};   
    j = 1;
    vector_j = tmp(j + grado - 1,:);
    if ~isnan(vector_j)
        Dataset_fpca(:,i,j) = vector_j';
    else 
        Dataset_fpca(:,i,j) = zeros(1,numframe);
    end    
end

n = numframe;
frequenza=1;
intervallo=[0, n/frequenza];
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 15, 5);
oggettoFD = calcolaCurve(t, Dataset_fpca, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);

lista_pca_nr_dof6 = calcolaFPCA(oggettoFD,15);%lista_pca_nr = calcolaFPCA(oggettoFD,4);

%% case 7

Dataset_fpca = zeros(numframe,numdata,numgdl);
grado = 7;

for i = 1 : numdata
    tmp = Actual_Dataset{i};   
    j = 1;
    vector_j = tmp(j + grado - 1,:);
    if ~isnan(vector_j)
        Dataset_fpca(:,i,j) = vector_j';
    else 
        Dataset_fpca(:,i,j) = zeros(1,numframe);
    end    
end

n = numframe;
frequenza=1;
intervallo=[0, n/frequenza];
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 15, 5);
oggettoFD = calcolaCurve(t, Dataset_fpca, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);

lista_pca_nr_dof7 = calcolaFPCA(oggettoFD,15);%lista_pca_nr = calcolaFPCA(oggettoFD,4);

end

