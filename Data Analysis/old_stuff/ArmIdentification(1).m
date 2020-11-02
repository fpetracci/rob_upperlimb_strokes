close all
clear all
clc


for index1 = 1 : 30
    for rep = 1 : 6
    close all
    tic

    %load  parameters (calibrated or not...)
    %Load_parameters;

    directory = 'datasets/';

    Subject = 'Laura_28';

    %Filename = 'task7.dat';
    Task = ['_' num2str(index1)];
    Repetition = ['_' num2str(rep)];
    Filename = [Subject Task Repetition];

    disp(['Identification ' Subject ' ' Filename])
    
    existflag = exist([directory Filename '.dat']);
    
    if existflag ~= 2
        disp([Subject ' ' Filename ' does not exists'])
        continue
    end
    
    syms q1 q2 q3 q4 q5 q6 q7
    syms DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 L1 L2 Suppx Suppy ParX ParZ

    SymbolicParameters = [DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 L1 L2 Suppx Suppy ParX ParZ];
    MkSuppDimensions = [15 7 22.5 55]; %MkSuppDimensions = [15 7 22.5 55] = [Suppx Suppy ParX ParZ]
    
    dir1 = 'EstimatedParameters/';
    load ([dir1 'UpperLimbParametersDEF' Subject '.mat'])

    %UpperLimbParametersDEF = [108.2569 174.7941 -50.3476 -6.7210 10.9731+50 131.3430 -14.1185 -0.2734 136.7899 49.4783 20.2631 -18.2123 285.5432 220.2431];
    %UpperLimbParametersDEF = [30 170 -80     0  40  140    0 20 155    22  5 0    300 225];
    NumericParameters = [UpperLimbParametersDEF MkSuppDimensions];

    qsym = [q1 q2 q3 q4 q5 q6 q7];

    data = load([directory Filename '.dat']); %Load data

    IDS_Definition

    MkNumberUL = length(MkIDS_UL)-4;

    %% load dataset & rotate 
    disp('Rotating dataset...')
    dataset_reorg_UpperLimb
    NumFrame = numel(MKPosSmoothed); %total number of frames
    %data are organized in a cell vector of NFRAMES elements. Each element is a
    %matrix NMKs*4. The first column collects a IDs and columns 2:4 are the 
    %positions x y z read from Phase Space. 
    %N.B. Dataset for this section is reduced to upperlimb markers only

    %Dataset now is RotatedData
    disp('...done')

    MKPos = MKPosSmoothed;

    %data=data.frame(:,2:end)';
    data = MKPos';
    %initialize joint angles vector
    %q = zeros(7,1);
    q = zeros(7,1);

    %load measures 36 rows and NTOT columns (32markers * 3dimensions = 96 rows) NTOT columns (NTOT = number of samples)
    [RAWS,NTOT] = size(data);

    % initialize the innovation vector
    innovation = zeros(MkNumberUL*3,1);

    % initialize the innovation variance vector (96x96)
    varInnov = zeros(MkNumberUL*3,MkNumberUL*3);

    % Define the measurement covariance
    R_OBS = 10^1*eye(MkNumberUL*3); 

    %Define P and Q
    P = 0.01*eye(7); %incertezza c.i.  ok 0.001
    processNoise = 0.001*eye(7); %Q %incertezza modello

    %initialize a matrix that will contains all estimed angles
    EstimatedQ = [];

    hnvalues = [];

    for i = 1:NTOT

        qold = q; %Project the state ahead 

        % Add the process noise  (Pk = I*Pk-1*I + Q)
        for j = 1:7
            P(j,j) = P(j,j) + processNoise(j,j); %Project the error covariance ahead
        end

        % Define the observation vector (96x1)
        observation = data(:,i);

        %define Initial Guess Angles & Bounds
        anglesinit = [-pi/2 0 0 0 0 0 0]; %initial guess (Angles)

        angleslb   = [-pi  -pi/2 -pi/2  0      -pi/2 -pi/4 -pi/2]; %upper bounds (Angles)
        anglesub   = [0      pi/4  pi/2   2/3*pi pi/2  0.3   pi/2]; %lower bounds (Angles)

        means = (angleslb+anglesub)/2;
        vars = (anglesub-angleslb)/2;

        sinqold = [means(1)+vars(1)*sin(q(1)) means(2)+vars(2)*sin(q(2)) means(3)+vars(3)*sin(q(3))...
                   means(4)+vars(4)*sin(q(4)) means(5)+vars(5)*sin(q(5)) means(6)+vars(6)*sin(q(6)) means(7)+vars(7)*sin(q(7))];

        %hn = hfun(NumericParameters, sinqold');
        %Hn = jacobianfun(NumericParameters, sinqold');
        hn = hfun(NumericParameters, qold');
        Hn = jacobianfun(NumericParameters, qold');

        %AddedAngle = UpperLimbParametersDEF(15);
        AddedAngle = 0;
        %AddedAngle = 0;
    %     hn(1) = hn(1)*sin(AddedAngle); hn(2) = hn(2)*cos(AddedAngle);
    %     hn(4) = hn(4)*sin(AddedAngle); hn(5) = hn(5)*cos(AddedAngle);
    %     hn(7) = hn(7)*sin(AddedAngle); hn(8) = hn(8)*cos(AddedAngle);
    %     hn(10) = hn(10)*sin(AddedAngle); hn(11) = hn(11)*cos(AddedAngle);
    %     hn(13) = hn(13)*sin(AddedAngle); hn(14) = hn(14)*cos(AddedAngle);
    %     hn(16) = hn(16)*sin(AddedAngle); hn(17) = hn(17)*cos(AddedAngle);


        hn(1) = hn(1) + UpperLimbParametersDEF(5)*sin(AddedAngle); hn(2) = hn(2) + UpperLimbParametersDEF(5)*cos(AddedAngle);
        hn(4) = hn(4) + UpperLimbParametersDEF(5)*sin(AddedAngle); hn(5) = hn(5) + UpperLimbParametersDEF(5)*cos(AddedAngle);
        hn(7) = hn(7) + UpperLimbParametersDEF(5)*sin(AddedAngle); hn(8) = hn(8) + UpperLimbParametersDEF(5)*cos(AddedAngle);
        hn(10) = hn(10) + UpperLimbParametersDEF(5)*sin(AddedAngle); hn(11) = hn(11) + UpperLimbParametersDEF(5)*cos(AddedAngle);
        hn(13) = hn(13) + UpperLimbParametersDEF(5)*sin(AddedAngle); hn(14) = hn(14) + UpperLimbParametersDEF(5)*cos(AddedAngle);
        hn(16) = hn(16) + UpperLimbParametersDEF(5)*sin(AddedAngle); hn(17) = hn(17) + UpperLimbParametersDEF(5)*cos(AddedAngle);



        hnvalues = [hnvalues hn]; 

        innovation = zeros(length(hn),1);

        for i = 1 : length(hn)
            if observation(i) ~= 0
                innovation(i) = observation(i) - hn(i);
            end
        end

        %innovation = observation - hn; % (96x1)
        varInnov = Hn*P*Hn' + R_OBS; % (96x96) 

        % Kalman Gain
        K = P*Hn'*varInnov^-1;   % (27x96)

        % Calculate state corrections
        q = qold + K * innovation;

        % Update the covariance 
        P = P - K*Hn*P;

        %save estimated angles (in columns) 
        EstimatedQ = [EstimatedQ qold];
        %EstimatedQ = [EstimatedQ sinqold']; 
    end

    dir1 = 'EstimatedAngles/';

    estname = [dir1 'EstimatedQArm' Filename '.mat'];
    save(estname, 'EstimatedQ')

    toc

    %% PLOT SECTION


    dirName = 'plots/ARM/';

    %Joint Angles
    plotName = 'Joint_Angles';

    figure;hold on;
    subplot(2,4,1);plot(EstimatedQ(1,:),'*');title('Joint Angle q1');xlabel('frame number');ylabel('rad');
    subplot(2,4,2);plot(EstimatedQ(2,:),'*');title('Joint Angle q2');xlabel('frame number');ylabel('rad');
    subplot(2,4,3);plot(EstimatedQ(3,:),'*');title('Joint Angle q3');xlabel('frame number');ylabel('rad');
    subplot(2,4,4);plot(EstimatedQ(4,:),'*');title('Joint Angle q4');xlabel('frame number');ylabel('rad');
    subplot(2,4,5);plot(EstimatedQ(5,:),'*');title('Joint Angle q5');xlabel('frame number');ylabel('rad');
    subplot(2,4,6);plot(EstimatedQ(6,:),'*');title('Joint Angle q6');xlabel('frame number');ylabel('rad');
    subplot(2,4,7);plot(EstimatedQ(7,:),'*');title('Joint Angle q7');xlabel('frame number');ylabel('rad');

    saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.fig'));
    saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.jpg'));

    %Mean Error per Frame
    Err = [];
    for i = 1 : NTOT

        meas = data(:,i);

        estpos = hfun(NumericParameters, EstimatedQ(1:7,i)');

        err1 = zeros(length(meas),1);
        for j = 1 :length(meas)
            if meas(j)==0
                err1(j) = 0;
            else 
                err1(j) = meas(j)-estpos(j);
            end
        end

        Err = [Err err1];
    end


    Err1 = [];
    for i = 1 : NTOT
        Err1(i) = mean(abs(Err(:,i)));
    end


    dir1 = 'EstimationErrors/';

    errname = [dir1 'ErrPerFrame' Filename '.mat'];
    save(errname, 'Err1')

    plotName = 'ErrPerFrame';
    figure;hold on;stem(Err1);xlabel('frame number');ylabel('mm');
    title('Mean Error per Frame')
    saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.fig'));
    saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.jpg'));
    axis([0 length(Err1) 0 100])


    %Mean, Max e Min Error per Marker

    Err2 = zeros(1,48);
    Err3 = zeros(1,48);
    Err4 = zeros(1,48);
    for i = 1 : 48
        Err2(i) = mean(abs(Err(i,:)));
        Err3(i) = max(abs(Err(i,:)));
        Err4(i) = min(abs(Err(i,:)));
    end

    MeanMkErr = zeros(1,16);
    MaxMkErr = zeros(1,16);
    MinMkErr = zeros(1,16);
    for i = 1 : 16
        MeanMkErr(i) = norm(Err2(1+(i-1)*3:3+(i-1)*3));
        MaxMkErr(i) = norm(Err3(1+(i-1)*3:3+(i-1)*3));
        MinMkErr(i) = norm(Err4(1+(i-1)*3:3+(i-1)*3));

    end
    plotName = 'ErrPerMarker';
    figure;hold on;stem(MkIDS_UL(5:end),MeanMkErr,'r');plot(MkIDS_UL(5:end),MinMkErr,'*b')%plot(MkIDS_UL(5:end),MaxMkErr,'g*');
    title('Error per Marker');legend('Median Values','Min Values');xlabel('Mk Number');ylabel('mm')%'Max Values',
    axis([0 72 0 100])

    saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.fig'));
    saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.jpg'));

    % % % %% Delete Bad Est
    % % % ToDelete = [];
    % % % for i = 1 : NTOT
    % % %     
    % % %     if Err1(i) >30
    % % %         ToDelete = [ToDelete i];
    % % %         
    % % %     end 
    % % % end
    % % % EstimatedQNew = [];
    % % % for i = 1 : NTOT
    % % %     if(~find(ToDelete==i))
    % % %         EstimatedQNew = [EstimatedQNew EstimatedQ(:,i)];
    % % %         disp (num2str(i))
    % % %     end
    % % % end
    % % % 
    % % % EstimatedQ = EstimatedQNew;
    % % % 
    % % % %% PLOT SECTION 1
    % % % 
    % % % dirName = 'plots/ARM/';
    % % % 
    % % % %Joint Angles
    % % % plotName = 'Joint_AnglesNew';
    % % % 
    % % % figure;hold on;
    % % % subplot(2,4,1);plot(EstimatedQ(1,:),'*');title('Joint Angle q1');xlabel('frame number');ylabel('rad');
    % % % subplot(2,4,2);plot(EstimatedQ(2,:),'*');title('Joint Angle q2');xlabel('frame number');ylabel('rad');
    % % % subplot(2,4,3);plot(EstimatedQ(3,:),'*');title('Joint Angle q3');xlabel('frame number');ylabel('rad');
    % % % subplot(2,4,4);plot(EstimatedQ(4,:),'*');title('Joint Angle q4');xlabel('frame number');ylabel('rad');
    % % % subplot(2,4,5);plot(EstimatedQ(5,:),'*');title('Joint Angle q5');xlabel('frame number');ylabel('rad');
    % % % subplot(2,4,6);plot(EstimatedQ(6,:),'*');title('Joint Angle q6');xlabel('frame number');ylabel('rad');
    % % % subplot(2,4,7);plot(EstimatedQ(7,:),'*');title('Joint Angle q7');xlabel('frame number');ylabel('rad');
    % % % 
    % % % saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.fig'));
    % % % saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.jpg'));
    % % % 
    % % % %Mean Error per Frame
    % % % Err = [];
    % % % for i = 1 : NTOT
    % % % 
    % % %     meas = data(:,i);
    % % %     
    % % %     estpos = hfun(NumericParameters, EstimatedQ(1:7,i)');
    % % %     
    % % %     err1 = zeros(length(meas),1);
    % % %     for j = 1 :length(meas)
    % % %         if meas(j)==0
    % % %             err1(j) = 0;
    % % %         else 
    % % %             err1(j) = meas(j)-estpos(j);
    % % %         end
    % % %     end
    % % %     
    % % %     Err = [Err err1];
    % % % end
    % % % 
    % % % 
    % % % Err1 = [];
    % % % for i = 1 : NTOT-20
    % % %     Err1(i) = mean(abs(Err(:,i)));
    % % % end
    % % % 
    % % % plotName = 'ErrPerFrameNew';
    % % % figure;hold on;stem(Err1);xlabel('frame number');ylabel('mm');
    % % % title('Mean Error per Frame')
    % % % saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.fig'));
    % % % saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.jpg'));
    % % % 
    % % % 
    % % % %Mean, Max e Min Error per Marker
    % % % 
    % % % Err1 = [];
    % % % Err2 = [];
    % % % Err3 = [];
    % % % for i = 1 : 36
    % % %     Err1(i) = mean(abs(Err(i,:)));
    % % %     Err2(i) = max(abs(Err(i,:)));
    % % %     Err3(i) = min(abs(Err(i,:)));
    % % % end
    % % % 
    % % % MeanMkErr = zeros(1,12);
    % % % MaxMkErr = zeros(1,12);
    % % % MinMkErr = zeros(1,12);
    % % % for i = 1 : 12
    % % %     MeanMkErr(i) = norm(Err1(1+(i-1)*3:3+(i-1)*3));
    % % %     MaxMkErr(i) = norm(Err2(1+(i-1)*3:3+(i-1)*3));
    % % %     MinMkErr(i) = norm(Err3(1+(i-1)*3:3+(i-1)*3));
    % % % 
    % % % end
    % % % plotName = 'ErrPerMarkerNew';
    % % % figure;hold on;stem(MkIDS_UL(5:end),MeanMkErr,'r');plot(MkIDS_UL(5:end),MaxMkErr,'g*');plot(MkIDS_UL(5:end),MinMkErr,'*b')
    % % % title('Error per Marker');legend('Mean Values','Max Values','Min Values');xlabel('Mk Number');ylabel('mm')
    % % % saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.fig'));
    % % % saveas(gcf,strcat(dirName,plotName,Subject,Filename,'.jpg'));
    % % % 
    end
end