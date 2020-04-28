% example: plot_data(healthy_task(1).subject(1))
% this function plot the angular joint (wrist,elbow,shoulder) with the limb
% that is doing the task for each task, as result we have 3 figures  
function plot_data(task)

%% Trial 1
for i=1:3
	
	figure(i)
	subplot(3,2,1)			
		plot(task.left_side_trial(i).J_Shoulder_L)
		title("Shoulder")

	subplot(3,2,3)
		plot(task.left_side_trial(i).J_Elbow_L)
		title("Elbow")

	subplot(3,2,5)
		plot(task.left_side_trial(i).J_Wrist_L)
		title("Wrist")

	subplot(3,2,2)
		plot(task.right_side_trial(i).J_Shoulder_R)
		title("Shoulder")

	subplot(3,2,4)	
		plot(task.right_side_trial(i).J_Elbow_R)
		title("Elbow")

	subplot(3,2,6)			
		plot(task.right_side_trial(i).J_Wrist_R)
		title("Wrist")

	if(task.stroke_side == 1)
		sgtitle(['Right Stroke Trial ' num2str(i)])
	elseif(task.stroke_side == 0)
		sgtitle(['left Stroke Trial ' num2str(i)])
	else
		sgtitle(['NO Stroke Trial ' num2str(i)])
	end
end

end