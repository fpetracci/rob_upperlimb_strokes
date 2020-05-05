function data = struct_dataload(filename)
% This function loads the relevant data inside the file .mvnx specified into "data".
% filename should be a char with the file path of the chosen .mvnx file.
% Example: data = struct_DataLoad('folder\P19_T07_L3.mvnx')

%Any file contains data about a single task, a single subject and a single
%trial.

struct_mvnx = load_mvnx(filename);

%% In this part is checked which row the data start at

nSamples_plus = length(struct_mvnx.subject.frames.frame);
i = 1;
while isempty(struct_mvnx.subject.frames.frame(i).index)
	skip = i; %number of lines not to be considered since data listed in temporal values ??is not provided
	i = i+1;
end

nSamples = nSamples_plus - skip; % number of sample with temporal values

%% Import files outside tree struct

data = struct; %struct definition
%% Position and quaternions

%Neck
segment = 6;
data.P_Neck = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Neck(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Neck_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Neck_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end


%Head
segment = 7;
data.P_Head = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Head(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Head_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Head_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end

%Right Shoulder
segment = 8;
data.P_Shoulder_R = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Shoulder_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Shoulder_R_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Shoulder_R_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end


%Right Upper Arm
segment = 9;
data.P_Upperarm_R = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i= 1:nSamples
		data.P_Upperarm_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Upperarm_R_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Upperarm_R_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end


%Right Forearm
segment = 10;
data.P_Forearm_R = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Forearm_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Forearm_R_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Forearm_R_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end

%Right Hand
segment = 11;
data.P_Hand_R = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Hand_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Hand_R_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Hand_R_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end

%Left Shoulder
segment = 12;
data.P_Shoulder_L = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Shoulder_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Shoulder_L_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Shoulder_L_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end

%Left Upper Arm
segment = 13;
data.P_Upperarm_L = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Upperarm_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Upperarm_L_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Upperarm_L_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end

%Left Forearm
segment = 14;
data.P_Forearm_L = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Forearm_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Forearm_L_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Forearm_L_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end

%Left Hand
segment = 15;
data.P_Hand_L = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.P_Hand_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.P_Hand_L_Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.P_Hand_L_Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*4-3):(segment*4));
    end
end

%% Joint Angle (elbow,wrist,shoulder)

%jRightShoulder
joint = 8;  
data.J_Shoulder_R = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
    for i = 1:nSamples
        data.J_Shoulder_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
    end
end

%jRightElbow
joint = 9;  
data.J_Elbow_R = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
    for i = 1:nSamples
        data.J_Elbow_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
    end
end

%jRightWrist
joint = 10;  
data.J_Wrist_R = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
    for i = 1:nSamples
        data.J_Wrist_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
    end
end

%jLeftShoulder
joint = 12;  
data.J_Shoulder_L = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
    for i = 1:nSamples 
        data.J_Shoulder_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
    end
end

%jLeftElbow
joint = 13;  
data.J_Elbow_L = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
    for i=1:nSamples
        data.J_Elbow_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
    end
end

%jLeftWrist
joint = 14;  
data.J_Wrist_L = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
    for i = 1:nSamples 
        data.J_Wrist_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
    end
end
%% Segment Velocity (Forearm)

%vRightForearm
velSegment = 10;  
data.V_Forearm_R= zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'velocity')
    for i = 1:nSamples
        data.V_Forearm_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).velocity((velSegment*3-2):(velSegment*3));
    end
end

%vLeftForearm
velSegment = 14;  
data.V_Forearm_L= zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'velocity')
    for i = 1:nSamples
        data.V_Forearm_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).velocity((velSegment*3-2):(velSegment*3));
    end
end

end

