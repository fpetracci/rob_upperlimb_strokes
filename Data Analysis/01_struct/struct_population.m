% This script populates the structure 'dataset' after its creation.
% It will be fullfilled using, step by step, the current content of the
% struct 'data', that contains values about a single data collection (a task,
% a subject and a single trial).




Manual_stroke = 12; % select the id AFA for the Popolation
strokesLabel = [ "02" "03" "04" "05" "06" "08" "09" "10" "12" "16" "17" "19" "20" "21" "22" "24" "25"  "29" "30";... % number of patient in the data
				  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9" "10" "11" "12" "13" "14" "15" "16" "17"  "18" "19";... % non so come dirlo
				  "0"  "1"  "0"  "1"  "0"  "1"  "0"  "0"  "1"  "1"  "0"  "0"  "0"  "1"  "1"  "0"  "1"  "1"  "1";... % upper limb with strokes 0-->Left 1--> Right
				  "1"  "1"  "0"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"  "1"];   % dominant upper limb     0-->Left 1--> Right
%% Population of healthy Subject

fprintf('Preparing Healthy_data \n')

foldername_array_h = ['Healthies\H01_SoftProTasks\'; 'Healthies\H02_SoftProTasks\'; 'Healthies\H03_SoftProTasks\'; 'Healthies\H04_SoftProTasks\'; 'Healthies\H05_SoftProTasks\'];


folder_h_num = size(foldername_array_h,1);
for z = 1:folder_h_num
	folder = foldername_array_h(z,:);
	for k = 1:nSubject_healthy
		for i = 1:nTasks
			for j = 1:nTrial
				if k <= 9
					if i <= 9 
						filenameL = [folder 'H0' num2str(k) '_T0' num2str(i) '_L' num2str(j) '.mvnx'];
						filenameR = [folder 'H0' num2str(k) '_T0' num2str(i) '_R' num2str(j) '.mvnx'];
					else
						filenameL = [folder 'H0' num2str(k) '_T' num2str(i) '_L' num2str(j) '.mvnx'];
						filenameR = [folder 'H0' num2str(k) '_T' num2str(i) '_R' num2str(j) '.mvnx'];
					end
				else
					if i <= 9 
						filenameL = [folder 'H' num2str(k) '_T0' num2str(i) '_L' num2str(j) '.mvnx'];
						filenameR = [folder 'H' num2str(k) '_T0' num2str(i) '_R' num2str(j) '.mvnx'];
					else
						filenameL = [folder 'H' num2str(k) '_T' num2str(i) '_L' num2str(j) '.mvnx'];
						filenameR = [folder 'H' num2str(k) '_T' num2str(i) '_R' num2str(j) '.mvnx'];
					end
				end
				
				% print of the current status in the command window
				str = ['folder ', num2str(z) , '  subject ', num2str(k), '  task ', num2str(i), '  trial ', num2str(j), '\n'];
				fprintf(str)
			
				if (isfile(filenameL))
					
					healthy_task(i).subject(k).left_side_trial(j) = struct_dataload(filenameL);
					
					if j == nTrial
						for jj = 1:nTrial
							healthy_task(i).subject(k).left_side_trial(jj).stroke_task = 0;
							healthy_task(i).subject(k).left_side_trial(jj).stroke_side = -1;
							healthy_task(i).subject(k).left_side_trial(jj).task_side = 0;
						end
					end
				
				end
				if (isfile(filenameR))
					
					healthy_task(i).subject(k).right_side_trial(j) = struct_dataload(filenameR);
					
					if j == nTrial
						for jj = 1:nTrial
							healthy_task(i).subject(k).right_side_trial(jj).stroke_task = 0;
							healthy_task(i).subject(k).right_side_trial(jj).stroke_side = -1;
							healthy_task(i).subject(k).right_side_trial(jj).task_side = 1;
						end
					end

				end
				
				healthy_task(i).subject(k).stroke_side= -1;

			end
		end
	end
end

fprintf('Saving Healthy_task.mat... \n')
save('healthy_task', 'healthy_task');
fprintf('healthy_task.mat saved! \n')
				
%% Population of stroke Subject

fprintf('Preparing Strokes_data \n')

foldername_array_s = ['Strokes\P02_SoftProTasks\'; 'Strokes\P03_SoftProTasks\'; 'Strokes\P04_SoftProTasks\'; 'Strokes\P05_SoftProTasks\'; 'Strokes\P06_SoftProTasks\'; ...
	'Strokes\P08_SoftProTasks\'; 'Strokes\P09_SoftProTasks\'; 'Strokes\P10_SoftProTasks\'; 'Strokes\P12_SoftProTasks\'; 'Strokes\P16_SoftProTasks\'; ...
	'Strokes\P17_SoftProTasks\'; 'Strokes\P19_SoftProTasks\'; 'Strokes\P20_SoftProTasks\'; 'Strokes\P21_SoftProTasks\'; 'Strokes\P22_SoftProTasks\'; ...
	'Strokes\P24_SoftProTasks\'; 'Strokes\P25_SoftProTasks\'; 'Strokes\P28_SoftProTasks\'; 'Strokes\P29_SoftProTasks\'; 'Strokes\P30_SoftProTasks\'];

folder_s_num = size(foldername_array_s,1);
nSubject_strokes = size(strokesLabel,2); %number of column
for z = 1:folder_s_num
	folder = foldername_array_s(z,:);
	for k = 1:nSubject_strokes
		nsub_Z = eval(strokesLabel(1,k));
		for i = 1:nTasks
			for j = 1:nTrial
				if nsub_Z <= 9
					if i <= 9 
						filenameL = [folder 'P0' num2str(nsub_Z) '_T0' num2str(i) '_L' num2str(j) '.mvnx'];
						filenameR = [folder 'P0' num2str(nsub_Z) '_T0' num2str(i) '_R' num2str(j) '.mvnx'];
					else
						filenameL = [folder 'P0' num2str(nsub_Z) '_T' num2str(i) '_L' num2str(j) '.mvnx'];
						filenameR = [folder 'P0' num2str(nsub_Z) '_T' num2str(i) '_R' num2str(j) '.mvnx'];
					end
				else
					if i <= 9 
						filenameL = [folder 'P' num2str(nsub_Z) '_T0' num2str(i) '_L' num2str(j) '.mvnx'];
						filenameR = [folder 'P' num2str(nsub_Z) '_T0' num2str(i) '_R' num2str(j) '.mvnx'];
					else
						filenameL = [folder 'P' num2str(nsub_Z) '_T' num2str(i) '_L' num2str(j) '.mvnx'];
						filenameR = [folder 'P' num2str(nsub_Z) '_T' num2str(i) '_R' num2str(j) '.mvnx'];
					end
				end
				
				% print of the current status in the command window
				str = ['folder ', num2str(z) , '  subject ', num2str(k), '  task ', num2str(i), '  trial ', num2str(j), '\n'];
				fprintf(str)
			
				if (isfile(filenameL))
					
					strokes_task(i).subject(k).left_side_trial(j) = struct_dataload(filenameL);
					
					if j == nTrial
						task_side = not(eval(strokesLabel(3,k)));
						%here subject executes the task using his left arm, so
						%if stroke affected his left side(eval(strokesLabel(3,k))=0),
						%he actually does it using the injured side (side has 
						%to be = 1), instead if stroke affected his right 
						%side, he actually does it using the healthy side
						%(side has to be = 0)
						
						for jj = 1:nTrial
							
							strokes_task(i).subject(k).left_side_trial(jj).stroke_task = task_side;
							strokes_task(i).subject(k).left_side_trial(jj).stroke_side = strokesLabel(3,k);
							strokes_task(i).subject(k).left_side_trial(jj).task_side = 0;
						end
					end
				
				end
				if (isfile(filenameR))
					
					strokes_task(i).subject(k).right_side_trial(j) = struct_dataload(filenameR);
					
					if j == nTrial
						task_side = eval(strokesLabel(3,k));
				
						%here subject executes the task using his right arm, so
						%if stroke affected his right side(eval(strokesLabel(3,k))=1),
						%he actually does it using the injured side (side has 
						%to be = 1), instead if stroke affected his left 
						%side, he actually does it using the healthy side
						%(side has to be = 0)
						
						for jj = 1:nTrial
							strokes_task(i).subject(k).right_side_trial(jj).stroke_task = task_side;
							strokes_task(i).subject(k).right_side_trial(jj).stroke_side = strokesLabel(3,k);
							strokes_task(i).subject(k).right_side_trial(jj).task_side = 1;
						end
					end

				end
				
				strokes_task(i).subject(k).stroke_side = str2double(strokesLabel(3,k));
			
			end
		end
	end
end
fprintf('Saving strokes_data.mat... \n')
save('strokes_task', 'strokes_task');
fprintf('strokes_task.mat saved! \n')
fprintf('All done! \n')