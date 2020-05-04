function yk = MeasurementNonAdditiveNoise(xk,vk)
%multiplicative error
yk = Fkine(xk)*(1+vk);% come dimensione dovrebbe avere 10 credo,Posizione ed orientazione di:
					 % mano, gomito, spalla,collo,busto 
end

