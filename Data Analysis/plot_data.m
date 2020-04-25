% example: plot_data(strokes_data.task1.subject1)
% this function plot the angular joint (wrist,elbow,shoulder) with the limb
% that is doing the task for each task, as result we have 3 figures 
% LA funzione andrebbe migliorata rendendola più corta con un for, il
% problema è mettere una variabile dentro il plot insieme all'input struct.
% 
function plot_data(task)

%% Trial 1
figure(1)
subplot(3,2,1)			
	plot(task.left_side.trial1.J_Shoulder_L)
	
	title("Shoulder")
 
subplot(3,2,3)
	plot(task.left_side.trial1.J_Elbow_L)
	title("Elbow")

subplot(3,2,5)
	plot(task.left_side.trial1.J_Wrist_L)
	title("Wrist")

subplot(3,2,2)
	plot(task.right_side.trial1.J_Shoulder_R)
	title("Shoulder")

subplot(3,2,4)	
	plot(task.right_side.trial1.J_Elbow_R)
	title("Elbow")

subplot(3,2,6)			
	plot(task.right_side.trial1.J_Wrist_R)
	title("Wrist")
	
if(task.stroke_side == 1)
	sgtitle('Right Stroke Trial 1')
elseif(task.stroke_side == 0)
	sgtitle('left Stroke Trial 1')
else
	sgtitle('NO Stroke Trial 1')
end

%% Trial 2
figure(2)
subplot(3,2,1)			
	plot(task.left_side.trial2.J_Shoulder_L)
	title("Shoulder")
 
subplot(3,2,3)
	plot(task.left_side.trial2.J_Elbow_L)
	title("Elbow")

subplot(3,2,5)
	plot(task.left_side.trial2.J_Wrist_L)
	title("Wrist")

subplot(3,2,2)
	plot(task.right_side.trial2.J_Shoulder_R)
	title("Shoulder")

subplot(3,2,4)	
	plot(task.right_side.trial2.J_Elbow_R)
	title("Elbow")

subplot(3,2,6)			
	plot(task.right_side.trial2.J_Wrist_R)
	title("Wrist")
	
if(task.stroke_side == 1)
	sgtitle('Right Stroke')
elseif(task.stroke_side == 0)
	sgtitle('left Stroke')
else
	sgtitle('NO Stroke')
end
%% Trial 3
figure(3)
subplot(3,2,1)			
	plot(task.left_side.trial3.J_Shoulder_L)
	title("Shoulder")
 
subplot(3,2,3)
	plot(task.left_side.trial3.J_Elbow_L)
	title("Elbow")

subplot(3,2,5)
	plot(task.left_side.trial3.J_Wrist_L)
	title("Wrist")

subplot(3,2,2)
	plot(task.right_side.trial3.J_Shoulder_R)
	title("Shoulder")

subplot(3,2,4)	
	plot(task.right_side.trial3.J_Elbow_R)
	title("Elbow")

subplot(3,2,6)			
	plot(task.right_side.trial3.J_Wrist_R)
	title("Wrist")
	
if(task.stroke_side == 1)
	sgtitle('Right Stroke')
elseif(task.stroke_side == 0)
	sgtitle('left Stroke')
else
	sgtitle('NO Stroke')
end

end

