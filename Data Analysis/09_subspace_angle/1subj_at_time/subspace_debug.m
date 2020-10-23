%% 
%This script is in italian since it has been useful to authors to 
%understand the differences between subspacea and subspace

% CIAO
pippo = [randn(2), [0; 0]; zeros(1,3)];
pluto = diag([0 0 1]);

% sono ortogonali, angolo = 90
subspace(pippo, pluto) /pi *180

%
paperone = [0 0 0; 0 1 0; 0 0 1];
subspace(pippo, paperone)/pi *180 % sono ortogonali, angolo = 90
(subspace(pippo, paperone) - max(subspacea(pippo, paperone) ))/pi *180 % = 0

% 
paperino = randn(3);
det(paperino) % determinante ha probabilita` zero di essere zero... ma non si sa mai

subspacea(pippo, paperino)
subspace(pippo, paperino)

diff = subspace(pippo, paperino) - max(subspacea(pippo, paperino))
diff_rel = diff/max(subspace(pippo, paperino), max(subspacea(pippo, paperino)))


%% check generale con roba rettangolare alta

angle = [];
anglea = [];
for i = 1:1000
	q1 = randn(10,3);
	q1 = q1/norm(q1);

	q2 = randn(10,3);
	q2 = q2/norm(q2);

	angle = [angle, subspace(q1,q2)*180/pi];
	anglea = [anglea, subspacea(q1,q2)*180/pi];
end
figure(1)
plot(angle')

%corretto, e` molto probabile che due sottospazi di dim 3 in uno spazio di
%dim 10 non abbiano niente a che fare tra di loro, l'angolo viene 

figure(2)
plot(anglea')

figure(3)
plot((angle -  max(anglea))')
