function result = involutive(A,B,x)
%A span generato dai vettori su cui si applica la lie bracket
%B span generato dalla lieBracket dei dui vettori cui sopra
%se B viene aggiunto ad A ed il rank non cambia, allora B è involutivo ad A
C = [A B];
if rank(C)>rank(A)
	result = 0;
else
	result = 1;
end

