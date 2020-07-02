function pcastr = calcolaFPCA(fdobj, n_fPC)

if nargin < 2
    n_fPC = 2;
end

fdbasis  = fdobj.base;
intervallo = fdbasis.intervallo;
harmbasis = fdbasis;
lambda = 0;

val_media = calcolaMediaCurve(fdobj);
curveCentrate = centraCurve(fdobj);
fdobj=calcolaCurve(fdobj.t,curveCentrate,fdobj.base);

coef   = fdobj.coef;
coefd  = size(coef);
num_basi = coefd(1);
nrep   = coefd(2);
ndim   = length(coefd);

if ndim == 3
    nvar  = coefd(3);
    ctemp = zeros(nvar*num_basi,nrep);
    for j = 1:nvar
        index = (1:num_basi) + (j-1)*num_basi;
        ctemp(index,:) = coef(:,:,j);
    end
else
    nvar = 1;
    ctemp = coef;
end

Cmat = ctemp*ctemp'./nrep;
Jmat = calcolaBSplinePen(harmbasis);
Wmat = Jmat;

Lmat    = chol(Wmat);
Lmatinv = inv(Lmat);

if nvar == 1
    if lambda > 0
        Cmat = Lmatinv' * Jmat * Cmat * Jmat * Lmatinv;
    else
        Cmat = Lmat * Cmat * Lmat';
    end
else
    for i = 1:nvar
        indexi =   (1:num_basi) + (i-1)*num_basi;
        for j = 1:nvar
            indexj = (1:num_basi) + (j-1)*num_basi;
            if lambda > 0
                Cmat(indexi,indexj) = ...
                    Lmatinv' * Jmat * Cmat(indexi,indexj) * Jmat * Lmatinv;
            else
                Cmat(indexi,indexj) = Lmat * Cmat(indexi,indexj) * Lmat';
            end
        end
    end
end

% Eigenanalysis
Cmat = (Cmat + Cmat')./2;
[eigvecs, eigvals] = eig(Cmat);
[eigvals, indsrt ] = sort(diag(eigvals));
eigvecs = eigvecs(:,indsrt);
neig    = nvar*num_basi;
indx    = neig + 1 - (1:n_fPC);
eigvals = eigvals(neig + 1 - (1:neig));
eigvecs = eigvecs(:,indx);
sumvecs = sum(eigvecs);
eigvecs(:,sumvecs < 0) = -eigvecs(:,sumvecs < 0);

varprop = eigvals(1:n_fPC)./sum(eigvals);

if nvar == 1
    harmcoef = Lmatinv * eigvecs;
    val_comp  = ctemp' * Lmat' * eigvecs;
else
    harmcoef = zeros(num_basi,n_fPC,nvar);
    val_comp  = zeros(nrep,n_fPC);
    for j = 1:nvar
        index = (1:num_basi) + (j-1)*num_basi;
        temp  = eigvecs(index,:);
        harmcoef(:,:,j) = Lmatinv * temp;
        val_comp = val_comp + ctemp(index,:)' * Lmat' * temp;
    end
end

fPC.coef=harmcoef;
fPC.base=fdbasis;

fPCA={};
for i=1:n_fPC
    h_coef=harmcoef;
    b_coef=fdbasis.matriceBase;
    if( ndim <=2 )
        fPCA{i}=b_coef*h_coef(:,i);
    else
        fPCA_temp=[];
        for i2=1:nvar
            h_coef_temp=squeeze(h_coef(:,i,i2));
            fPCA_temp=[fPCA_temp, b_coef*h_coef_temp ];
        end
        fPCA{i}=fPCA_temp;
    end
end
fPC.fPCA=fPCA;

pcastr.fd = fPC;
pcastr.componenti = val_comp;
pcastr.perc_varianza = varprop;
pcastr.media = val_media;
pcastr.aval = eigvals;
pcastr.avet = eigvecs;










function [penaltymat, iter] = calcolaBSplinePen(basisobj, rng)

if nargin < 2, rng = basisobj.intervallo;  end

    sparsewrd = 1;
    range = basisobj.intervallo;
    num_basi = basisobj.num_basi;
    param = basisobj.param;
    breaks    = [range(1),param,range(2)]; 
    nbreaks   = length(breaks);
    ninterval = nbreaks - 1;    
    nderiv = 0;
    ordine = num_basi - length(param);
    iter = 0;
    if nderiv == ordine - 1
        halfseq    = (breaks(2:nbreaks) + breaks(1:(nbreaks-1)))./2;
        halfmat    = bsplineM(halfseq, breaks, ordine, nderiv);
        brwidth    = diff(breaks);
        penaltymat = sparse(halfmat' * diag(brwidth) * halfmat);
        return;
    end
    intbreaks    = basisobj.param;
    index        = intbreaks >= rng(1) & intbreaks <= rng(2);
    intbreaks    = intbreaks(index);
    nintbreaks   = length(intbreaks);
    uniquebreaks = min(diff(intbreaks)) > 0;
    knots = [range(1)*ones(1,ordine), breaks(2:(nbreaks-1)), range(2)*ones(1,ordine)];
    polyorder = ordine - nderiv;
    ndegree   = polyorder - 1;
    prodorder = 2*ndegree + 1; 
    polycoef  = zeros(ninterval, polyorder, ordine); 
    indxdown  = ordine:-1:nderiv+1;
    for i = 1:num_basi 
        [Coeff,index] = coefBSpline(knots(i:i+ordine));
        nrowcoef = size(Coeff,1);
        onescoef = ones(nrowcoef,1);
        index = index + i - ordine;
        CoeffD = Coeff(:,1:polyorder);
        if nderiv > 0
            for ideriv=1:nderiv
                fac = indxdown - ideriv;
                CoeffD = (onescoef*fac).*CoeffD;
            end
        end
        if i >= ordine, k = ordine;  else k = i;       end
        if i <= ordine, m = i;       else m = ordine;  end
        for j=1:nrowcoef
            polycoef(i-k+j,:,m-j+1) = CoeffD(j,:);
        end
    end
    prodmat = zeros(num_basi);
    convmat = zeros(ordine, ordine, prodorder);
    for in = 1:ninterval
        Coeff = squeeze(polycoef(in,:,:));
        for i=0:ndegree-1
            ind = (0:i) + 1;
            convmat(:,:,i+1        ) = ...
                Coeff(ind,          :)'*Coeff(i-ind+2,      :);
            convmat(:,:,prodorder-i) = ...
                Coeff(ndegree-ind+2,:)'*Coeff(ndegree-i+ind,:);
        end
        ind = (0:ndegree)+1;
        convmat(:,:,ndegree+1) = Coeff(ind,:)'*Coeff(ndegree-ind+2,:);
        delta    = breaks(in+1) - breaks(in);
        power    = delta;
        prodmati = zeros(ordine);
        for i=1:prodorder
            prodmati = prodmati + power.*squeeze(convmat(:,:,prodorder-i+1))./i;
            power = power*delta;
        end
        index = in:in+ordine-1;
        prodmat(index,index) = prodmat(index,index) + prodmati; 
    end
    
    if sparsewrd
        penaltymat = sparse(prodmat);
    else
        penaltymat = prodmat;
    end

penaltymat = (penaltymat + penaltymat')./2;