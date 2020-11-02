% for reconstruct plots
close all
for i = 1:24
	reconstruct_plot(i)
end

% does subj confirms our hypot? err_h>err_la>err_s 
% .b>g>r 7/10
% .r>g>b 3
% D = colpito al dominante		-> LA = non dominante (meno vicino ai sani?)
% F = colpito al non dominante	-> LA = dominante (più vicino ai sani?)
 
% 6  54	F -> 10sì 	7mmm 	3no		- è abbastanza sano, ci sta sia così
% 7  55	D -> 10sì 	7sì 	3mmm	- same
% 8  55	D -> 10mmm 	7mmm 	3no		- sono circa tutti sovrapposti i 'mm', ci sta essendo poco affected
% 9  38	D -> 10mmm	7sì 	3sì		- è quel che vogliamo
% 10 41	F -> 10sì	7mmm 	3mno	- da rivedere
% 11 47	D -> 10sì	7sì		3no		- è coerente, sì sì no indica che non compensa col busto
% 12 40	F -> 10ni	7ni		3ni		- rispetto ai sani è okay, non torna tra stroke side e less affected side
% 13 49	F -> 10sì	7sì		3sì		- non rispetto alla media dei sani ma ci sta, tra stroke side e less affected side va bene
% 14 43	D -> 10sì	7sì		3sì		- in tutto, bello visto che è abbastanza affected
% 15 37	D -> 10sì	7sì		3sì		- like itttt visto che è spastichetto
% 16 53	F -> 10ni	7ni		3sì		- ci piace visto che è piuttosto sano
% 17 59	F -> 10mmm	7mmm	3mmm	- sono tutte e tre le linee quasi sovrapposte, non è male come risultato visto che è sanetto
% 18 37	F -> 10no	7no		3sì		- outlier scartato anche da Averta, copia come hanno giustificato loro
% 19 61	D -> 10sì	7sì		3mmm	- ci sta, il terzo mmm è perché compensa poco con la spalla infatti si ha sì anche nel 10
% 20 42	D -> 10mmm	7mmm	3sì		- okay rispetto ai sani, mmm tra la e s
% 21 48	F -> 10no	7no		3no		- outlier????
% 22 60	D -> 10no	7no		3sì		- ???
% 23 46	D -> 10sì	7sì		3no		- ci sta dato che non compensa, LA simile ad H
% 24 21	D -> 10sì	7sì		3sì		- alto impairment e le nostre ipotesi tornano perfette

% qua metterei il plot unico con le varianze

% se durante la fase sub acuta io muovo molto il braccio colpito, questo
% crea plasticità e quindi movimenti più legati ecc... allora possiamo
% provare a vedere se c'è una correlazione tra D e un peggioramento nel
% recupero, quindi mi aspetto che nei D l'ipotesi sia più confermata.

% F mi aspetto sia più vicino ai sani perché: LA è il dominante e quindi
% bello, S è usato meno anche quindi in fase sub acuta e quindi ci
% aspettiamo meno plasticità che si va a creare e quindi ipotesi meno
% evidente


