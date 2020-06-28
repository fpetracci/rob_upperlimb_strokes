trial = strokes_task(7).subject(2).right_side_trial(2);

arms = create_arms(trial);
arm = arms.left;

close all;
tic; 
data = q_trial2q(trial); 
toc;
figure;
plot(data.q_grad'); 
figure;
plot(data.err.L5',			'DisplayName','L5 err norm');
hold on
plot(data.err.shoulder',	'DisplayName','shoulder err norm');
plot(data.err.elbow',		'DisplayName','elbow err norm');
plot(data.err.wrist',		'DisplayName','wrist err norm');
legend
% figure;
% arm.plot((data.q_grad/180*pi)')
