function [ curveCentrate ] = centraCurve( struttura_FD )
    % - struttura_FD � una struttura dati (output della funzione
    %   'calcolaCurve')
    %
    % - curveCentrate � il dataset centrato; in particolare avr� dimensione
    %   n x k x d   dove n � il numero di campioni; k � il numero di
    %   ripetizioni dell'esperimento; d � la dimensione delle variabili
    
    curve=struttura_FD.curve;
    dim_data=size(curve);
    n_basi=dim_data(1);
    n_esperimenti=dim_data(2);
    

    mediaCurve=calcolaMediaCurve( struttura_FD );

    curveCentrate=[];
    if( numel(dim_data)<=2 )
        matriceMedie=repmat(mediaCurve,1,n_esperimenti);
        curveCentrate=curve-matriceMedie;
    else
        n_variabili=dim_data(3);
        for i=1:n_variabili
            curve_temp=squeeze(curve(:,:,i));
            mediaCurve_temp=mediaCurve(:,i);
            matriceMedie_temp=repmat(mediaCurve_temp,1,n_esperimenti);
            curveCentrate(:,:,i)=curve_temp-matriceMedie_temp;
        end
    end

end

