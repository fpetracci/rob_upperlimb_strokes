clear; clc

figure(1)
clf
axis equal
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
grid on
alpha_edge = 0.5;
%head
col_head_edge = [255, 170, 0]./255;
col_head_face = [255, 230, 179]./255;
scale_head	= 0.3/80;				
%shoulder_pos = hom2vett(arm_fkine(arm, zeros(10,1), 6)); % armfkine to get shoulder height
%L5_pos = hom2vett(arm_fkine(arm, zeros(10,1), 1)); % armfkine to get shoulder height
%head_offset = [-0.26 - shoulder_pos(1); -0.2 - L5_pos(2); shoulder_pos(3)];

head_offset = [-1.7850;-0.10;-2.3300];
head_rotate = rotz(pi/2) * rotx(0.8*pi/4);


% init head model
%p_head = patch(stlread('head_david.stl'));
p_head = patch(stlread('HEAD_low_poly.stl'));
T_head = hgmat(head_rotate*scale_head, [0;0;0]+head_offset);
t_head = hgtransform('Parent',gca);
set(t_head,'Matrix',T_head);
set(p_head,'Parent',t_head);
set(p_head, 'FaceColor', col_head_face);	% Set the face colour
set(p_head, 'EdgeColor', col_head_edge);	% Set the edge colour
set(p_head, 'EdgeAlpha', alpha_edge);		% Set the edge transparency (0 transparent)
