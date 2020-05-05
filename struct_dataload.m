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
%Pelvis
segment = 1;
data.Pelvis.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Pelvis.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Pelvis.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Pelvis.Quat(i,:) = struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end

%Neck
segment = 6;
data.Neck.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Neck.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Neck.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Neck.Quat(i,:) = struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end


%Head
segment = 7;
data.Head.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Head.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Head.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Head.Quat(i,:) = struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end

%Right Shoulder
segment = 8;
data.Shoulder_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Shoulder_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Shoulder_R.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Shoulder_R.Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end


%Right Upper Arm
segment = 9;
data.Upperarm_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i= 1:nSamples
		data.Upperarm_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Upperarm_R.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Upperarm_R.Quat(i,:) = struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end


%Right Forearm
segment = 10;
data.Forearm_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Forearm_R.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Forearm_R.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Forearm_R.Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end

%Right Hand
segment = 11;
data.Hand_R.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Hand_R.Pos(i,:)= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Hand_R.Quat= zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Hand_R.Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end

%Left Shoulder
segment = 12;
data.Shoulder_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Shoulder_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Shoulder_L.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Shoulder_L.Quat(i,:) = struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end

%Left Upper Arm
segment = 13;
data.Upperarm_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Upperarm_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Upperarm_L.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Upperarm_L.Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end

%Left Forearm
segment = 14;
data.Forearm_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Forearm_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Forearm_L.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Forearm_L.Quat(i,:) = struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end

%Left Hand
segment = 15;
data.Hand_L.Pos = zeros(nSamples,3);
if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        data.Hand_L.Pos(i,:) = struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
    end
end

data.Hand_L.Quat = zeros(nSamples,4);
if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
    for i = 1:nSamples
        data.Hand_L.Quat(i,:) = struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
    end
end
% 
% %% Joint Angle (elbow,wrist,shoulder)
% 
% %jRightShoulder
% joint = 8;  
% data.J_Shoulder_R = zeros(nSamples,3);
% if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
%     for i = 1:nSamples
%         data.J_Shoulder_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
%     end
% end
% 
% %jRightElbow
% joint = 9;  
% data.J_Elbow_R = zeros(nSamples,3);
% if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
%     for i = 1:nSamples
%         data.J_Elbow_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
%     end
% end
% 
% %jRightWrist
% joint = 10;  
% data.J_Wrist_R = zeros(nSamples,3);
% if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
%     for i = 1:nSamples
%         data.J_Wrist_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
%     end
% end
% 
% %jLeftShoulder
% joint = 12;  
% data.J_Shoulder_L = zeros(nSamples,3);
% if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
%     for i = 1:nSamples 
%         data.J_Shoulder_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
%     end
% end
% 
% %jLeftElbow
% joint = 13;  
% data.J_Elbow_L = zeros(nSamples,3);
% if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
%     for i=1:nSamples
%         data.J_Elbow_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
%     end
% end
% 
% %jLeftWrist
% joint = 14;  
% data.J_Wrist_L = zeros(nSamples,3);
% if isfield(struct_mvnx.subject.frames.frame(1),'jointAngleXZY')
%     for i = 1:nSamples 
%         data.J_Wrist_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).jointAngleXZY((joint*3-2):(joint*3));
%     end
% end
% %% Segment Velocity (Forearm)
% 
% %vRightForearm
% velSegment = 10;  
% data.V_Forearm_R= zeros(nSamples,3);
% if isfield(struct_mvnx.subject.frames.frame(1),'velocity')
%     for i = 1:nSamples
%         data.V_Forearm_R(i,:)= struct_mvnx.subject.frames.frame(i+skip).velocity((velSegment*3-2):(velSegment*3));
%     end
% end
% 
% %vLeftForearm
% velSegment = 14;  
% data.V_Forearm_L= zeros(nSamples,3);
% if isfield(struct_mvnx.subject.frames.frame(1),'velocity')
%     for i = 1:nSamples
%         data.V_Forearm_L(i,:)= struct_mvnx.subject.frames.frame(i+skip).velocity((velSegment*3-2):(velSegment*3));
%     end
% end

end

