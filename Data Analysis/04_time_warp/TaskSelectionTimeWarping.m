s1 = correct2pi_err(q_task(1).subject(1).trial(6).q_grad(:,10:end)); % 240
s1 = correct2pi_err(q_task(2).subject(1).trial(4).q_grad(:,10:end));%240
s1 = correct2pi_err(q_task(3).subject(1).trial(6).q_grad(:,10:end))
s1 = correct2pi_err(q_task(4).subject(1).trial(1).q_grad(:,10:end)); % 240 alcuni task vanno scartati, non colpa del TW
s1 = correct2pi_err(q_task(5).subject(1).trial(6).q_grad(:,10:end));
s1 = correct2pi_err(q_task(6).subject(1).trial(6).q_grad(:,9:end));
s1 = correct2pi_err(q_task(7).subject(10).trial(3).q_grad(:,4:end));
s1 = correct2pi_err(q_task(8).subject(8).trial(5).q_grad (:,10:end));
s1 = correct2pi_err(q_task(9).subject(1).trial(6).q_grad(:,10:end));
s1 = correct2pi_err(q_task(10).subject(10).trial(2).q_grad(:,4:end));

s1 = correct2pi_err(q_task(11).subject(2).trial(1).q_grad(:,32:end));
s1 = correct2pi_err(q_task(12).subject(4).trial(2).q_grad(:,6:end));
s1 = correct2pi_err(q_task(13).subject(3).trial(3).q_grad(:,20:end)); % da qui in poi la magia del resample
% 14 scazzato completamente, non si capisce cosa faccia
s1 = correct2pi_err(q_task(15).subject(3).trial(3).q_grad(:,10:end));
s1 = correct2pi_err(q_task(16).subject(5).trial(4).q_grad(:,10:end));
s1 = correct2pi_err(q_task(17).subject(5).trial(4).q_grad(:,10:end));
s1 = correct2pi_err(q_task(18).subject(3).trial(2).q_grad(:,10:end));
s1 = correct2pi_err(q_task(19).subject(16).trial(2).q_grad(:,10:end));
s1 = correct2pi_err(q_task(20).subject(1).trial(1).q_grad(:,10:end));
% 21 sono per il solo resample invece che eliminare il task, da decidere
s1 = correct2pi_err(q_task(22).subject(1).trial(4).q_grad(:,10:end));
s1 = correct2pi_err(q_task(23).subject(10).trial(5).q_grad(:,10:end));
















