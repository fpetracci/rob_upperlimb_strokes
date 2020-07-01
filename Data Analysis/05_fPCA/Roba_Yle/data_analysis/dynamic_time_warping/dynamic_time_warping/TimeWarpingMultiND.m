close all
clear all
clc

EstimatedQTask4 = load('EstimatedAngles/EstimatedQArmGiuseppe4.mat');
EstimatedQTask9 = load('EstimatedAngles/EstimatedQArmGiuseppe9.mat');
EstimatedQTask4 = EstimatedQTask4.EstimatedQ;
EstimatedQTask9 = EstimatedQTask9.EstimatedQ;

SIGN1 = EstimatedQTask9(:,1:end);
SIGN2 = EstimatedQTask4(:,1:end);

%SIGN1 = SIGN1(:,300:end);
%SIGN2 = SIGN2(:,300:end);

%Remove outliers
SIGN1(1,260:390) = SIGN1(1,259);SIGN1(2,260:390) = SIGN1(2,259);SIGN1(3,260:390) = SIGN1(3,259);SIGN1(4,260:390) = SIGN1(4,259);SIGN1(5,260:390) = SIGN1(5,259);SIGN1(6,260:390) = SIGN1(6,259);SIGN1(7,260:390) = SIGN1(7,259);


figure;
subplot(3,3,1);plot(SIGN1(1,:),'rd');hold on;plot(SIGN2(1,:),'g*');legend('s1ORIG g1','s2ORIG g1')
subplot(3,3,2);plot(SIGN1(2,:),'rd');hold on;plot(SIGN2(2,:),'g*');legend('s1ORIG g2','s2ORIG g2')
subplot(3,3,3);plot(SIGN1(3,:),'rd');hold on;plot(SIGN2(3,:),'g*');legend('s1ORIG g3','s2ORIG g3')
subplot(3,3,4);plot(SIGN1(4,:),'rd');hold on;plot(SIGN2(4,:),'g*');legend('s1ORIG g4','s2ORIG g4')
subplot(3,3,5);plot(SIGN1(5,:),'rd');hold on;plot(SIGN2(5,:),'g*');legend('s1ORIG g5','s2ORIG g5')
subplot(3,3,6);plot(SIGN1(6,:),'rd');hold on;plot(SIGN2(6,:),'g*');legend('s1ORIG g6','s2ORIG g6')
subplot(3,3,7);plot(SIGN1(7,:),'rd');hold on;plot(SIGN2(7,:),'g*');legend('s1ORIG g7','s2ORIG g7')

%smooth
SIGN1(1,:) = smooth(SIGN1(1,:),100)'; SIGN1(2,:) = smooth(SIGN1(2,:),100)'; SIGN1(3,:) = smooth(SIGN1(3,:),100)'; SIGN1(4,:) = smooth(SIGN1(4,:),100)'; SIGN1(5,:) = smooth(SIGN1(5,:),100)'; SIGN1(6,:) = smooth(SIGN1(6,:),100)'; SIGN1(7,:) = smooth(SIGN1(7,:),100)';
SIGN2(1,:) = smooth(SIGN2(1,:),100)'; SIGN2(2,:) = smooth(SIGN2(2,:),100)'; SIGN2(3,:) = smooth(SIGN2(3,:),100)'; SIGN2(4,:) = smooth(SIGN2(4,:),100)'; SIGN2(5,:) = smooth(SIGN2(5,:),100)'; SIGN2(6,:) = smooth(SIGN2(6,:),100)'; SIGN2(7,:) = smooth(SIGN2(7,:),100)';

figure;
subplot(3,3,1);plot(SIGN1(1,:),'rd');hold on;plot(SIGN2(1,:),'g*');legend('s1FILTERED g1','s2FILTERED g1')
subplot(3,3,2);plot(SIGN1(2,:),'rd');hold on;plot(SIGN2(2,:),'g*');legend('s1FILTERED g2','s2FILTERED g2')
subplot(3,3,3);plot(SIGN1(3,:),'rd');hold on;plot(SIGN2(3,:),'g*');legend('s1FILTERED g3','s2FILTERED g3')
subplot(3,3,4);plot(SIGN1(4,:),'rd');hold on;plot(SIGN2(4,:),'g*');legend('s1FILTERED g4','s2FILTERED g4')
subplot(3,3,5);plot(SIGN1(5,:),'rd');hold on;plot(SIGN2(5,:),'g*');legend('s1FILTERED g5','s2FILTERED g5')
subplot(3,3,6);plot(SIGN1(6,:),'rd');hold on;plot(SIGN2(6,:),'g*');legend('s1FILTERED g6','s2FILTERED g6')
subplot(3,3,7);plot(SIGN1(7,:),'rd');hold on;plot(SIGN2(7,:),'g*');legend('s1FILTERED g7','s2FILTERED g7')


[SIGN1_1, SIGN1_2, SIGN1_3] = segmentationND(SIGN1); % SIGN1 SIGN1_1 SIGN1_2 SIGN1_3 are matrices 
[SIGN2_1, SIGN2_2, SIGN2_3] = segmentationND(SIGN2);

%normalize
% SIGN1_1(1,:) = SIGN1_1(1,:)/max(abs(SIGN1_1(1,:))); SIGN1_1(2,:) = SIGN1_1(2,:)/max(abs(SIGN1_1(2,:))); SIGN1_1(3,:) = SIGN1_1(3,:)/max(abs(SIGN1_1(3,:))); SIGN1_1(4,:) = SIGN1_1(4,:)/max(abs(SIGN1_1(4,:))); SIGN1_1(5,:) = SIGN1_1(5,:)/max(abs(SIGN1_1(5,:))); SIGN1_1(6,:) = SIGN1_1(6,:)/max(abs(SIGN1_1(6,:))); SIGN1_1(7,:) = SIGN1_1(7,:)/max(abs(SIGN1_1(7,:))); 
% SIGN1_2(1,:) = SIGN1_2(1,:)/max(abs(SIGN1_2(1,:))); SIGN1_2(2,:) = SIGN1_2(2,:)/max(abs(SIGN1_2(2,:))); SIGN1_2(3,:) = SIGN1_2(3,:)/max(abs(SIGN1_2(3,:))); SIGN1_2(4,:) = SIGN1_2(4,:)/max(abs(SIGN1_2(4,:))); SIGN1_2(5,:) = SIGN1_2(5,:)/max(abs(SIGN1_2(5,:))); SIGN1_2(6,:) = SIGN1_2(6,:)/max(abs(SIGN1_2(6,:))); SIGN1_2(7,:) = SIGN1_2(7,:)/max(abs(SIGN1_2(7,:))); 
% SIGN1_3(1,:) = SIGN1_3(1,:)/max(abs(SIGN1_3(1,:))); SIGN1_3(2,:) = SIGN1_3(2,:)/max(abs(SIGN1_3(2,:))); SIGN1_3(3,:) = SIGN1_3(3,:)/max(abs(SIGN1_3(3,:))); SIGN1_3(4,:) = SIGN1_3(4,:)/max(abs(SIGN1_3(4,:))); SIGN1_3(5,:) = SIGN1_3(5,:)/max(abs(SIGN1_3(5,:))); SIGN1_3(6,:) = SIGN1_3(6,:)/max(abs(SIGN1_3(6,:))); SIGN1_3(7,:) = SIGN1_3(7,:)/max(abs(SIGN1_3(7,:))); 
% SIGN2_1(1,:) = SIGN2_1(1,:)/max(abs(SIGN2_1(1,:))); SIGN2_1(2,:) = SIGN2_1(2,:)/max(abs(SIGN2_1(2,:))); SIGN2_1(3,:) = SIGN2_1(3,:)/max(abs(SIGN2_1(3,:))); SIGN2_1(4,:) = SIGN2_1(4,:)/max(abs(SIGN2_1(4,:))); SIGN2_1(5,:) = SIGN2_1(5,:)/max(abs(SIGN2_1(5,:))); SIGN2_1(6,:) = SIGN2_1(6,:)/max(abs(SIGN2_1(6,:))); SIGN2_1(7,:) = SIGN2_1(7,:)/max(abs(SIGN2_1(7,:))); 
% SIGN2_2(1,:) = SIGN2_2(1,:)/max(abs(SIGN2_2(1,:))); SIGN2_2(2,:) = SIGN2_2(2,:)/max(abs(SIGN2_2(2,:))); SIGN2_2(3,:) = SIGN2_2(3,:)/max(abs(SIGN2_2(3,:))); SIGN2_2(4,:) = SIGN2_2(4,:)/max(abs(SIGN2_2(4,:))); SIGN2_2(5,:) = SIGN2_2(5,:)/max(abs(SIGN2_2(5,:))); SIGN2_2(6,:) = SIGN2_2(6,:)/max(abs(SIGN2_2(6,:))); SIGN2_2(7,:) = SIGN2_2(7,:)/max(abs(SIGN2_2(7,:))); 
% SIGN2_3(1,:) = SIGN2_3(1,:)/max(abs(SIGN2_3(1,:))); SIGN2_3(2,:) = SIGN2_3(2,:)/max(abs(SIGN2_3(2,:))); SIGN2_3(3,:) = SIGN2_3(3,:)/max(abs(SIGN2_3(3,:))); SIGN2_3(4,:) = SIGN2_3(4,:)/max(abs(SIGN2_3(4,:))); SIGN2_3(5,:) = SIGN2_3(5,:)/max(abs(SIGN2_3(5,:))); SIGN2_3(6,:) = SIGN2_3(6,:)/max(abs(SIGN2_3(6,:))); SIGN2_3(7,:) = SIGN2_3(7,:)/max(abs(SIGN2_3(7,:))); 

figure;
subplot(3,3,1); plot(SIGN1_1(1,:),'rd'); hold on; plot(SIGN1_2(1,:),'gd'); plot(SIGN1_3(1,:),'bd'); plot(SIGN2_1(1,:),'k*'); plot(SIGN2_2(1,:),'y*'); plot(SIGN2_3(1,:),'m*');
subplot(3,3,2); plot(SIGN1_1(2,:),'rd'); hold on; plot(SIGN1_2(2,:),'gd'); plot(SIGN1_3(2,:),'bd'); plot(SIGN2_1(2,:),'k*'); plot(SIGN2_2(2,:),'y*'); plot(SIGN2_3(2,:),'m*');
subplot(3,3,3); plot(SIGN1_1(3,:),'rd'); hold on; plot(SIGN1_2(3,:),'gd'); plot(SIGN1_3(3,:),'bd'); plot(SIGN2_1(3,:),'k*'); plot(SIGN2_2(3,:),'y*'); plot(SIGN2_3(3,:),'m*');
subplot(3,3,4); plot(SIGN1_1(4,:),'rd'); hold on; plot(SIGN1_2(4,:),'gd'); plot(SIGN1_3(4,:),'bd'); plot(SIGN2_1(4,:),'k*'); plot(SIGN2_2(4,:),'y*'); plot(SIGN2_3(4,:),'m*');
subplot(3,3,5); plot(SIGN1_1(5,:),'rd'); hold on; plot(SIGN1_2(5,:),'gd'); plot(SIGN1_3(5,:),'bd'); plot(SIGN2_1(5,:),'k*'); plot(SIGN2_2(5,:),'y*'); plot(SIGN2_3(5,:),'m*');
subplot(3,3,6); plot(SIGN1_1(6,:),'rd'); hold on; plot(SIGN1_2(6,:),'gd'); plot(SIGN1_3(6,:),'bd'); plot(SIGN2_1(6,:),'k*'); plot(SIGN2_2(6,:),'y*'); plot(SIGN2_3(6,:),'m*');
subplot(3,3,7); plot(SIGN1_1(7,:),'rd'); hold on; plot(SIGN1_2(7,:),'gd'); plot(SIGN1_3(7,:),'bd'); plot(SIGN2_1(7,:),'k*'); plot(SIGN2_2(7,:),'y*'); plot(SIGN2_3(7,:),'m*');

drawnow


disp('SIGN1_2'); SIGN1_2_new = TimeWarpingSingleND(SIGN1_1,SIGN1_2);
disp('SIGN1_3'); SIGN1_3_new = TimeWarpingSingleND(SIGN1_1,SIGN1_3);
disp('SIGN2_1'); SIGN2_1_new = TimeWarpingSingleND(SIGN1_1,SIGN2_1);
disp('SIGN2_2'); SIGN2_2_new = TimeWarpingSingleND(SIGN1_1,SIGN2_2);
disp('SIGN2_3'); SIGN2_3_new = TimeWarpingSingleND(SIGN1_1,SIGN2_3);


figure;
subplot(3,3,1); plot(SIGN1_1(1,:),'rd'); hold on; plot(SIGN1_2_new(1,:),'gd'); plot(SIGN1_3_new(1,:),'bd'); plot(SIGN2_1_new(1,:),'k*'); plot(SIGN2_2_new(1,:),'y*'); plot(SIGN2_3_new(1,:),'m*');
subplot(3,3,2); plot(SIGN1_1(2,:),'rd'); hold on; plot(SIGN1_2_new(2,:),'gd'); plot(SIGN1_3_new(2,:),'bd'); plot(SIGN2_1_new(2,:),'k*'); plot(SIGN2_2_new(2,:),'y*'); plot(SIGN2_3_new(2,:),'m*');
subplot(3,3,3); plot(SIGN1_1(3,:),'rd'); hold on; plot(SIGN1_2_new(3,:),'gd'); plot(SIGN1_3_new(3,:),'bd'); plot(SIGN2_1_new(3,:),'k*'); plot(SIGN2_2_new(3,:),'y*'); plot(SIGN2_3_new(3,:),'m*');
subplot(3,3,4); plot(SIGN1_1(4,:),'rd'); hold on; plot(SIGN1_2_new(4,:),'gd'); plot(SIGN1_3_new(4,:),'bd'); plot(SIGN2_1_new(4,:),'k*'); plot(SIGN2_2_new(4,:),'y*'); plot(SIGN2_3_new(4,:),'m*');
subplot(3,3,5); plot(SIGN1_1(5,:),'rd'); hold on; plot(SIGN1_2_new(5,:),'gd'); plot(SIGN1_3_new(5,:),'bd'); plot(SIGN2_1_new(5,:),'k*'); plot(SIGN2_2_new(5,:),'y*'); plot(SIGN2_3_new(5,:),'m*');
subplot(3,3,6); plot(SIGN1_1(6,:),'rd'); hold on; plot(SIGN1_2_new(6,:),'gd'); plot(SIGN1_3_new(6,:),'bd'); plot(SIGN2_1_new(6,:),'k*'); plot(SIGN2_2_new(6,:),'y*'); plot(SIGN2_3_new(6,:),'m*');
subplot(3,3,7); plot(SIGN1_1(7,:),'rd'); hold on; plot(SIGN1_2_new(7,:),'gd'); plot(SIGN1_3_new(7,:),'bd'); plot(SIGN2_1_new(7,:),'k*'); plot(SIGN2_2_new(7,:),'y*'); plot(SIGN2_3_new(7,:),'m*');


save warped_data.mat SIGN1_1 SIGN1_2_new SIGN1_3_new SIGN2_1_new SIGN2_2_new SIGN2_3_new