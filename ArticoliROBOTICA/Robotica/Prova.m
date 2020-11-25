%Prova
F=rand(10,4); G=randn(10,6); theta = subspacea(F,G);
%  computes 4 angles between F and G, while in addition 
A=hilb(10); 
[thetaA,U,V] = subspacea(F,G,A)