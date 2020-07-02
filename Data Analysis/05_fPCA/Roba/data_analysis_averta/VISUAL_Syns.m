close all
clear all
clc
    
addpath('kinematics')

%     load realTrack
%     load PC0All
%     load PC1All
%     load PC2All
%     load PC3All
%     load PC4All
%     load PC5All
%     load PC6All
%     load PC7All
%     load PC8All
%     load PC9All
%     load PC10All
load (['UpperLimbParametersDEFAndrea.mat'])
    
load Savings/all_ds_syns, syn_set = all_ds_syns;
load Savings/mean_pose,

%load coeffs, syn_set = coeffs;

UpperLimbParametersDEF(10) = UpperLimbParametersDEF(10)*2;
MkSuppDimensions = [15 7 22.5 55];
Rot = EulerRotMatrix( -pi/12, pi/2, pi/12 );

    %EstimatedQ = syn_set(:,1);
delta = 2;
range = [0:-0.005:-delta, -delta:0.005:delta, delta:-0.005:0];
for rep = [1:3]
    if rep == 1
        EstimatedQ = range.*syn_set(:,1);
        v = VideoWriter(['videos/Reconstruction_s1.avi']);
    elseif rep == 2
        EstimatedQ = range.*syn_set(:,2);
        v = VideoWriter(['videos/Reconstruction_s2.avi']);
    elseif rep == 3
        EstimatedQ = range.*syn_set(:,3);
        v = VideoWriter(['videos/Reconstruction_s3.avi']);
    elseif rep == 4
        EstimatedQ = range.*syn_set(:,4);
        v = VideoWriter(['videos/Reconstruction_s4.avi']);
    elseif rep == 5
        EstimatedQ = range.*syn_set(:,5);
        v = VideoWriter(['videos/Reconstruction_s5.avi']);
    elseif rep == 6
        EstimatedQ = range.*syn_set(:,6);
        v = VideoWriter(['videos/Reconstruction_s6.avi']);
    elseif rep == 7
        EstimatedQ = range.*syn_set(:,7);
        v = VideoWriter(['videos/Reconstruction_s7.avi']);
    end
   
NumFrame = length (EstimatedQ(1,:));
    %fv = stlread('Torso2.stl');
    %fv.vertices = fv.vertices*10;
    %UpperLimbParametersDEF = [40 240 -60 0 0 140 0 0 190 45 0 0 300 270];
        %v = VideoWriter(['Reconstruction_real.avi']);
        close all
        open(v);
             figure;
disp (['Exporting S' num2str(rep)])

    for i = 1:NumFrame
%disp (['frame' num2str(i)])
        %close all
        clf;hold on;

        AnglesNow = mean_pose+EstimatedQ(:,i);%*0 + [0 0 0 0 0 0 0]';
        %MeasuresNow = MKPos(i,:)'; %column vector 48 elem
        EstimationsNow = hfun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow); %column vector 36 elem

        TShoulder = gWorldS1fun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldShoulder = TShoulder(1:3,4);
        TElbow = gWorldE1fun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldElbow = TElbow(1:3,4);
        TElbow = gWorldE1fun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldElbow = TElbow(1:3,4);
        TWrist = gWorldW1fun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldWrist = TWrist(1:3,4);
        THand = gWorldHfun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldHand = THand(1:3,4);

        DistWorldShoulder = Rot * DistWorldShoulder; 
        DistWorldElbow = Rot * DistWorldElbow; 
        DistWorldWrist = Rot * DistWorldWrist; 
        DistWorldHand = Rot * DistWorldHand; 
        
        
        plot3([DistWorldShoulder(1) DistWorldElbow(1) DistWorldWrist(1) DistWorldHand(1)],...
              [DistWorldShoulder(2) DistWorldElbow(2) DistWorldWrist(2) DistWorldHand(2)],...
              [DistWorldShoulder(3) DistWorldElbow(3) DistWorldWrist(3) DistWorldHand(3)],'y','LineWidth',10)%
        
      
        plot3(DistWorldShoulder(1),DistWorldShoulder(2),DistWorldShoulder(3),'ok','MarkerSize',15,'MarkerFaceColor','k')
        plot3(DistWorldElbow(1),DistWorldElbow(2),DistWorldElbow(3),'ok','MarkerSize',15,'MarkerFaceColor','k')
        plot3(DistWorldWrist(1),DistWorldWrist(2),DistWorldWrist(3),'ok','MarkerSize',15,'MarkerFaceColor','k')

        
    x = [DistWorldShoulder(1) DistWorldShoulder(1)      DistWorldShoulder(1)     DistWorldShoulder(1)];
    y = [DistWorldShoulder(2) DistWorldShoulder(2)+100  DistWorldShoulder(2)+100 DistWorldShoulder(2)];
    z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)-600 DistWorldShoulder(3)-600];
    fill3(x,y,z,'yellow')

    x = [DistWorldShoulder(1) DistWorldShoulder(1)-600  DistWorldShoulder(1)-600 DistWorldShoulder(1)];
    y = [DistWorldShoulder(2) DistWorldShoulder(2)      DistWorldShoulder(2)     DistWorldShoulder(2)];
    z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)-600 DistWorldShoulder(3)-600];
    fill3(x,y,z,'yellow')

    x = [DistWorldShoulder(1) DistWorldShoulder(1)      DistWorldShoulder(1)-600 DistWorldShoulder(1)-600];
    y = [DistWorldShoulder(2) DistWorldShoulder(2)+100  DistWorldShoulder(2)+100 DistWorldShoulder(2)];
    z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)     DistWorldShoulder(3)];
    fill3(x,y,z,'yellow')
    
    [x,y,z] = sphere;
    surf(x*150 + 240,y*150+60,z*150,'FaceColor','yellow','EdgeColor','black')

    axis( [-500 500 -700 500 -200 800])

    %view(86.8000, -26) %front view
    ax = gca;
    view( 0, -35)
    ax.CameraUpVector = [1 0 0];

    xlabel x; ylabel y; zlabel z;

    name = strcat('Rec_',num2str(rep),'\frame',num2str(i));
    %saveas( gcf, name, 'jpg' );

    frame = getframe(gca,[0 0 450 420]);
    
    writeVideo(v,frame);  
    end
    close (v);
end