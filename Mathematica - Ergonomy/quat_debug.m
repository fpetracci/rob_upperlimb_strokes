%script quaternioni
quatprima = hand_quat_L(73,:);

quatdopo = hand_quat_L(74,:);

vettqprima = quatprima(2:end);
vettqdopo = quatdopo(2:end);

%%
figure(1)
clf
plot3(vettqprima(1),vettqprima(2),vettqprima(3),'go')
hold on
plot3(vettqdopo(1),vettqdopo(2),vettqdopo(3),'ro')
plot3(0,0,0,'ko')
quiver3(0,0,0,vettqprima(1),vettqprima(2),vettqprima(3),'g')
quiver3(0,0,0,vettqdopo(1),vettqdopo(2),vettqdopo(3), 'r')
axis equal
grid on
xlabel('q_1')
ylabel('q_2')
zlabel('q_3')
xlim([-1,1])
ylim([-1,1])
zlim([-1,1])


%%
f = gcf;
exportgraphics(f,'prova.pdf', 'ContentType','vector')