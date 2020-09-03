# rob_upperlimb_strokes

TO DO LIST

DATA ANALYSISISISIS
. visualizzatore di task, visualizzatore task con i marker  --- view_trial
. analizzare rPCA risultati


MODELLL
. modello per dinamica e poi simulink
. modello muscolo - hill?

Paper ICNR2020
. lasciamo perdere

IDEE:
. reverse engineering di un indice di ergonomia da come muovono il braccio i soggetti healthy

-------------------------------------------------------------------




LOG

19 Aprile
Apertura file, discussione struct, animazione. Prima bozza di structure fatta 
(data - task01 - subject01 -destro/sinistro -trial01 - dati che servono)
dati che servono: velocita`, posizione, rotazioni giunti e stroke (true se il braccio che compie il task e` quello colpito da stroke)

20 Aprile
Struct definita,il file PopulationStruct.m sembra ordinare correttamente il file prova,

02 Maggio 
UPDATEMI

15 Maggio
ALLORA??

24 Giugno


_____________________________________________________
venerdi meeting
fino a che punto di dettaglio ha senso spingersi per il modello?
	link con inerzia che non sia un parallelepipedo e qualcosa che modelli braccio umano. inerzia del macchinario e inerzia del paziente
	inerzia del paziente va modellata e va considerata l'azione del muscolo:componente elastica e viscosa con parametri ragionevoli

cinematica inversa, noi gli diamo il modello scrivendo la tabella di denavit hartenberg, otteniamo gli angoli di giunto cosi. poi popoliamo un'altra struttura con
le cose che ci servono e l analisi si fa su quella struttura. 7dgl è più che sufficiente

per check, vedi l'errore di ricostruzione. cinematica diretta