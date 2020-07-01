function [ curvaMedia ] = calcolaMediaCurve( struttura_FD )

    c_base=struttura_FD.base.matriceBase;
    c_curve=struttura_FD.coef;

    dim_data=size(c_curve);
    if( numel(dim_data)<=2 )
        dataset=c_base*c_curve;
        curvaMedia=mean(dataset,2);
    else
        n_basi=dim_data(1);
        n_esperimenti=dim_data(2);
        n_variabili=dim_data(3);
        curvaMedia=[];
        for i=1:n_variabili
            coef_temp=squeeze(c_curve(:,:,i));
            dataset_temp=c_base*coef_temp;
            curvaMedia=[curvaMedia, mean(dataset_temp,2)];
        end
    end
end