function [struttura_FD] = calcolaCurve(t_val, y, base_str)

if size(t_val,1) == 1 %trasformo il tempo in vettore colonna
    t_val = t_val';
end

[n, ncl] = size(t_val);  %  numero di osservazioni

ydim = size(y); 
if length(ydim) == 2 & ydim(1) == 1
    y = y';
end

wtvec  = ones(n,1);


base = base_str;
num_basi   = base.num_basi;
sizew = size(wtvec);
if length(sizew) == 2 & sizew(1) == 1
    wtvec = wtvec';
end
lambda = 0;
dimDati = size(y);
ndim  = length(dimDati);
switch ndim
    case 1
        num_curve = 1;
        nvar    = 1;
    case 2
        num_curve = dimDati(2);
        nvar    = 1;
    case 3
        num_curve = dimDati(2);
        nvar    = dimDati(3);
    otherwise
        error('ERRORE MATRICE INPUT DEI DATI');
end

basismat  = valutaBase(t_val, base); %questa funzione costruisce una base di funzioni. Nell'esempio genera 13 funzioni bspline di 100 campioni
%save basismat basismat

if n >= num_basi | lambda > 0 %n = 100 nell'esempio
    basisw = basismat .* (wtvec * ones(1,num_basi));
    %save basisw basisw
    Bmat   = basisw' * basismat;
    Bmat0  = Bmat;
    if ndim < 3 %vuol dire che ho una sola variabile(e.g. solo x)
        Dmat = basisw' * y;
    else
        Dmat = zeros(num_basi,num_curve,nvar);
        for ivar = 1:nvar
            Dmat(:,:,ivar) = basisw' * y(:,:,ivar);
        end
    end  
    if verificaDiag(Bmat)
        Bmatinv = diag(1./diag(Bmat));
    else
        Bmatinv = inv(Bmat);
    end
    if ndim < 3
        coef = Bmatinv * Dmat;
    else
        coef = zeros(num_basi, num_curve, nvar);
        for ivar = 1:nvar
            coef(:,:,ivar) = Bmatinv * Dmat(:,:,ivar);
        end
    end
else
    error(['NUMERO DI BASI TROPPO ELEVATO']);
end

if ndim < 3
    yhat = basismat * coef;
else
    SSE = zeros(nvar,num_curve);
    for ivar = 1:nvar
        coefi = squeeze(coef(:,:,ivar));
        yhati = basismat * coefi;
        yi    = squeeze(y(:,:,ivar));
        SSE(ivar,:) = sum((yi - yhati).^2);
    end
end

struttura_FD.coef     = coef;
struttura_FD.base = base;
struttura_FD.base.matriceBase = basismat;

c_base=basismat;
c_curve=coef;
dim_data=size(c_curve);
if( numel(dim_data)<=2 )
    dataset=c_base*c_curve;
else
    n_basi=dim_data(1);
    n_esperimenti=dim_data(2);
    n_variabili=dim_data(3);
    dataset=[];
    for i=1:n_variabili
            coef_temp=squeeze(c_curve(:,:,i));
            dataset(:,:,i)=c_base*coef_temp;
    end
end
struttura_FD.curve=dataset;
struttura_FD.t=t_val;




function evalarray = valutaBase(evalarg, base)
if isnumeric(base) && isa_basis(evalarg)
    temp     = base;
    base = evalarg;
    evalarg  = temp;
end
evalarg = evalarg(:);
nderiv=0;
num_basi   = base.num_basi;
param   = base.param;
intervallo = base.intervallo;
rangex   = intervallo;
breaks   = [rangex(1), param, rangex(2)];
ordine   = num_basi - length(breaks) + 2;
basismat = calcolaBaseBSpline(evalarg, breaks, ordine, nderiv);
evalarray=basismat;





function bsplinemat = calcolaBaseBSpline(x, breaks, ordine, nderiv)
x = x(:);
if nargin < 4, nderiv    = 0;  end
if nargin < 3, ordine    = 4;  end
if min(diff(x)) < 0 
    [x,isrt] = sort(x); 
end
k   = ordine;  
km1 = k-1;
nb  = length(breaks);
nx  = length(x);
nd  = nderiv+1;
ns  = nb - 2 + k;
if ns < 1 
   fprintf('Nessuna bspline. \n')
   bsplinemat = []; 
   return
end
onenx = ones(nx,1);
onenb = ones(k, 1);
onens = ones(ns,1);

if size(breaks,1) > 1 breaks = breaks'; end
knots  = [breaks(1)*ones(1,km1), breaks, breaks(nb)*ones(1,km1)]';
num_basi = length(knots) - k;
knotslower      = knots(1:num_basi);
[valore,index] = sort([knotslower', x']);
pointer         = find(index > num_basi) - [1:length(x)];
left            = max([pointer; k*onenx']);  

temp = [1, zeros(1,km1)]; 
b    = temp(ones(nd*nx,1),:);
nxs  = nd*[1:nx];

for j=1:k-nd
   saved = zeros(nx,1);
   for r=1:j
      leftpr   = left + r;
      tr       = knots(leftpr) - x;
      tl       = x - knots(leftpr-j);
      term     = b(nxs,r)./(tr+tl);
      b(nxs,r) = saved + tr.*term;
      saved    = tl.*term;
   end
   b(nxs,j+1)  = saved;
end

for jj=1:nd-1
   j = k - nd + jj; 
   saved = zeros(nx,1); 
   nxn   = nxs - 1;
   for r=1:j
      leftpr   = left + r;
      tr       = knots(leftpr) - x;
      tl       = x - knots(leftpr-j);
      term     = b(nxs,r)./(tr+tl);
      b(nxn,r) = saved + tr.*term;
      saved    = tl.*term;
   end
   b(nxn,j+1)  = saved; 
   nxs = nxn;
end

for jj=nd-1:-1:1
   j = k - jj;
   temp = [jj:nd-1].'*onenx' + ones(nd-jj,1)*nxn; 
   nxs = reshape(temp,(nd-1-jj+1)*nx,1);
   for r=j:-1:1
      leftpr     = left + r;
      temp       = ones(nd-jj,1)*(knots(leftpr) - knots(leftpr-j)).'/j;
      b(nxs,r)   = -b(nxs,r)./temp(:);
      b(nxs,r+1) =  b(nxs,r+1) - b(nxs,r);
   end
end

index = find(x < breaks(1) | x > breaks(nb));
if ~isempty(index)
   temp = [1-nd:0].'*ones(1,length(index))+nd*ones(nd,1)*index(:).';
   b(temp(:),:) = zeros(nd*length(index),k);
end

width = max([ns,num_basi]) + km1 + km1;
cc    = zeros(nx*width,1);
index = [1-nx:0].'*onenb' + nx*(left.'*onenb' + onenx*[-km1:0]);
cc(index) = b(nd*[1:nx],:);
bsplinemat = reshape(cc([1-nx:0].'*onens' + nx*onenx*([1:ns])), nx, ns);