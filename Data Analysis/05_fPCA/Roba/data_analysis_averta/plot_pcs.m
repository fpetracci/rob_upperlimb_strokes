dirName = 'plots/fpca/';

figure;
subplot(2,2,1);plot(pc1_dof1(:,1),'r');title('pc1 dof1')
subplot(2,2,2);plot(pc2_dof1(:,1),'g');title('pc2 dof1')
subplot(2,2,3);plot(pc3_dof1(:,1),'b');title('pc3 dof1')
subplot(2,2,4);plot(pc4_dof1(:,1),'k');title('pc4 dof1')
plotName = 'PCs';
Subject = 'Dof1';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));


figure;
subplot(2,2,1);plot(pc1_dof2(:,1),'r');title('pc1 dof2')
subplot(2,2,2);plot(pc2_dof2(:,1),'g');title('pc2 dof2')
subplot(2,2,3);plot(pc3_dof2(:,1),'b');title('pc3 dof2')
subplot(2,2,4);plot(pc4_dof2(:,1),'k');title('pc4 dof2')
plotName = 'PCs';
Subject = 'Dof2';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,2,1);plot(pc1_dof3(:,1),'r');title('pc1 dof3')
subplot(2,2,2);plot(pc2_dof3(:,1),'g');title('pc2 dof3')
subplot(2,2,3);plot(pc3_dof3(:,1),'b');title('pc3 dof3')
subplot(2,2,4);plot(pc4_dof3(:,1),'k');title('pc4 dof3')
plotName = 'PCs';
Subject = 'Dof3';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,2,1);plot(pc1_dof4(:,1),'r');title('pc1 dof4')
subplot(2,2,2);plot(pc2_dof4(:,1),'g');title('pc2 dof4')
subplot(2,2,3);plot(pc3_dof4(:,1),'b');title('pc3 dof4')
subplot(2,2,4);plot(pc4_dof4(:,1),'k');title('pc4 dof4')
plotName = 'PCs';
Subject = 'Dof4';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,2,1);plot(pc1_dof5(:,1),'r');title('pc1 dof5')
subplot(2,2,2);plot(pc2_dof5(:,1),'g');title('pc2 dof5')
subplot(2,2,3);plot(pc3_dof5(:,1),'b');title('pc3 dof5')
subplot(2,2,4);plot(pc4_dof5(:,1),'k');title('pc4 dof5')
plotName = 'PCs';
Subject = 'Dof5';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,2,1);plot(pc1_dof6(:,1),'r');title('pc1 dof6')
subplot(2,2,2);plot(pc2_dof6(:,1),'g');title('pc2 dof6')
subplot(2,2,3);plot(pc3_dof6(:,1),'b');title('pc3 dof6')
subplot(2,2,4);plot(pc4_dof6(:,1),'k');title('pc4 dof6')
plotName = 'PCs';
Subject = 'Dof6';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,2,1);plot(pc1_dof7(:,1),'r');title('pc1 dof7')
subplot(2,2,2);plot(pc2_dof7(:,1),'g');title('pc2 dof7')
subplot(2,2,3);plot(pc3_dof7(:,1),'b');title('pc3 dof7')
subplot(2,2,4);plot(pc4_dof7(:,1),'k');title('pc4 dof7')
plotName = 'PCs';
Subject = 'Dof7';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));
