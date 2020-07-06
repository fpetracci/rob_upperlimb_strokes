function eul = correct2pi_err(eul)
%Forse è più comodo fare un for che aggiusto un vettore in ingresso
for i = 2:size(eul,2)
	for j = 1:10
		if ((eul(j,i) - (eul(j,i-1))) > pi)
			eul(j,i) = eul(j,i) - 2*pi;
		elseif ((eul(j,i) - (eul(j,i-1))) < -pi)
			eul(j,i) = eul(j,i) + 2*pi;
		else
			eul(j,i) = eul(j,i);
		end
	end
end
end

