function eul = correct2pi_err(eul)
%correct2pi_err Removes the pi discontinuity of input angles

angle_rad = pi;
angle_grad = 180;

for i = 2:size(eul,2)
	for j = 1:10

		if ((eul(j,i) - (eul(j,i-1))) > angle_grad)
			eul(j,i) = eul(j,i) - 2*angle_grad;
		elseif ((eul(j,i) - (eul(j,i-1))) < -angle_grad)
			eul(j,i) = eul(j,i) + 2*angle_grad;
		else
			eul(j,i) = eul(j,i);
		end
	end
end
end

