trial = strokes_task(26).subject(1).right_side_trial(1);

arms = create_arms(trial);
arm = arms.left;

close all;
tic; 
data = q_trial2qUKF_rel(trial, 1); 
toc;
figure;
plot(data.q_grad'); 
figure;
plot(data.err');
% figure;
% arm.plot((data.q_grad/180*pi)')
figure;
plot(data.k_iter);

tic; 
data = q_trial2qUKF_rel(trial, 0); 
toc;
figure;
plot(data.q_grad'); 
figure;
plot(data.err');
% figure;
% arm.plot((data.q_grad/180*pi)')
figure;
plot(data.k_iter);