trial = strokes_task(26).subject(1).left_side_trial(1);

arms = create_arms(trial);
arm = arms.left;

close;
tic; 
data = q_trial2qUKF(trial); 
toc;
figure;
plot(data.q_grad'); 
figure;
plot(data.err');
% figure;
% arm.plot((data.q_grad/180*pi)')
figure;
plot(data.k_iter);