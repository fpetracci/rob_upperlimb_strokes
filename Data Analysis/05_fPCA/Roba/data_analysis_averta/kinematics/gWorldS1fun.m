function [ gWorldS1 ] = gWorldS1fun( par, angles )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

 DX = par(1);
 DY = par(2);
 DZ = par(3);
 
 DX1 = par(4);
 DY1 = par(5);
 DZ1 = par(6);
 
 DX2 = par(7);
 DY2 = par(8);
 DZ2 = par(9);

 DX3 = par(10);
 DY3 = par(11);
 DZ3 = par(12);
 
 L1 = par(13);
 L2 = par(14);
 Suppx = par(15);
 Suppy = par(16);
 
 q1 = angles(1);
 q2 = angles(2); 
 q3 = angles(3);
 q4 = angles(4); 
 q5 = angles(5); 
 q6 = angles(6);
 q7 = angles(7); 

 
gWorldS1=[cos(q1),(-1).*sin(q1),0,DX.*(1+(-1).*cos(q1))+DX.*cos(q1);sin(q1),cos( ...
  q1),0,DY.*(1+(-1).*cos(q1))+DY.*cos(q1);0,0,1,DZ;0,0,0,1];


end

