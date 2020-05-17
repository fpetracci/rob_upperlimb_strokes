function  plot_angle(q,i)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

plot(i,q(1,i)','.y')
plot(i,q(2,i)','om')
plot(i,q(3,i)','.c')
plot(i,q(4,i)','.r')
plot(i,q(5,i)','.g')
plot(i,q(6,i)','.b')
plot(i,q(7,i)','.k')
plot(i,q(8,i)','*b')
plot(i,q(9,i)','*g')
plot(i,q(10,i)','*r')
 legend('q1','q2','q3',...
		'q4','q5', 'q6',...
		'q7','q7','q9','q10');


end

