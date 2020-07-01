close all
clear all
clc

EstimatedQTask4 = load('EstimatedAngles/EstimatedQArmGiuseppe4.mat');
EstimatedQTask9 = load('EstimatedAngles/EstimatedQArmGiuseppe9.mat');
EstimatedQTask4 = EstimatedQTask4.EstimatedQ;
EstimatedQTask9 = EstimatedQTask9.EstimatedQ;

%SIGN2 = EstimatedQTask9(3,1:end);
%SIGN1 = EstimatedQTask10(3,1:end);
SIGN1 = EstimatedQTask9(3,1:end);
SIGN2 = EstimatedQTask4(3,1:end);
SIGN3 = EstimatedQTask4(2,1:end);

SIGN1(260:390) = SIGN1(259);


SIGN1 = SIGN1(300:end);
SIGN2 = SIGN2(300:end);
SIGN3 = SIGN3(300:end);

D = diff(SIGN1);

figure;
plot(D,'rd');

figure;
plot(SIGN1,'rd');
hold on
plot(SIGN2,'g*');
plot(SIGN3,'b*');
legend('s1ORIG','s2ORIG')

SIGN1 = smooth(SIGN1,100)';
SIGN2 = smooth(SIGN2,100)';
SIGN3 = smooth(SIGN3,50)';

figure;
plot(SIGN1,'rd');
hold on
plot(SIGN2,'g*');
plot(SIGN3,'b*');
legend('SIGN1Filt','SIGN2Filt')

[SIGN1_1, SIGN1_2, SIGN1_3] = segmentation(SIGN1);
[SIGN2_1, SIGN2_2, SIGN2_3] = segmentation(SIGN2);
[SIGN3_1, SIGN3_2, SIGN3_3] = segmentation(SIGN3);


SIGN1_1 = SIGN1_1/max(abs(SIGN1_1));
SIGN1_2 = SIGN1_2/max(abs(SIGN1_2));
SIGN1_3 = SIGN1_3/max(abs(SIGN1_3));
SIGN2_1 = SIGN2_1/max(abs(SIGN2_1));
SIGN2_2 = SIGN2_2/max(abs(SIGN2_2));
SIGN2_3 = SIGN2_3/max(abs(SIGN2_3));
SIGN3_1 = SIGN3_1/max(abs(SIGN3_1));
SIGN3_2 = SIGN3_2/max(abs(SIGN3_2));
SIGN3_3 = SIGN3_3/max(abs(SIGN3_3));



figure;
plot(SIGN1_1,'rd');
hold on
plot(SIGN1_2,'go');
plot(SIGN1_3,'bo');
plot(SIGN2_1,'ko');
plot(SIGN2_2,'yo');
plot(SIGN2_3,'mo');
plot(SIGN3_1,'rd');
plot(SIGN3_2,'gd');
plot(SIGN3_3,'bd');

figure;
plot(SIGN1_1,'r*');
hold on
plot(SIGN3_1,'rd');
plot(SIGN3_2,'gd');
plot(SIGN3_3,'bd');


drawnow
disp('SIGN1_2'); SIGN1_2_new = TimeWarpingSingle1D(SIGN1_1,SIGN1_2);
disp('SIGN1_3'); SIGN1_3_new = TimeWarpingSingle1D(SIGN1_1,SIGN1_3);
disp('SIGN2_1'); SIGN2_1_new = TimeWarpingSingle1D(SIGN1_1,SIGN2_1);
disp('SIGN2_2'); SIGN2_2_new = TimeWarpingSingle1D(SIGN1_1,SIGN2_2);
disp('SIGN2_3'); SIGN2_3_new = TimeWarpingSingle1D(SIGN1_1,SIGN2_3);
disp('SIGN3_1'); SIGN3_1_new = TimeWarpingSingle1D(SIGN3_1,SIGN3_1);
disp('SIGN3_2'); SIGN3_2_new = TimeWarpingSingle1D(SIGN3_1,SIGN3_2);
disp('SIGN3_3'); SIGN3_3_new = TimeWarpingSingle1D(SIGN3_1,SIGN3_3);



figure;
plot(SIGN1_1,'rd');
hold on
plot(SIGN1_2_new,'go');
plot(SIGN1_3_new,'bo');
plot(SIGN2_1_new,'ko');
plot(SIGN2_2_new,'yo');
plot(SIGN2_3_new,'mo');
plot(SIGN3_1_new,'rd');
plot(SIGN3_2_new,'gd');
plot(SIGN3_3_new,'bd');


figure;
plot(SIGN1_1,'r*');
hold on
plot(SIGN3_1_new,'rd');
plot(SIGN3_2_new,'gd');
plot(SIGN3_3_new,'bd');

save warped_dataSIGNLE.mat SIGN1_1 SIGN1_2_new SIGN1_3_new SIGN2_1_new SIGN2_2_new SIGN2_3_new SIGN3_1_new SIGN3_2_new SIGN3_3_new