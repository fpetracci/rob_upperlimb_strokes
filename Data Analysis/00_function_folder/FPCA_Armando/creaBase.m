function base = creaBase(intervallo, num_basi, ordine)

if length(intervallo) == 1
    intervallo = [0,intervallo];
end
if nargin < 2
    num_basi = 1;
end
if nargin < 3
    ordine = min(4,num_basi);
end
breaks = [];
if isempty(num_basi) & isempty(breaks)
    nbreaks = 21;
    num_basi  = 19 + ordine;
    breaks  = linspace(intervallo(1), intervallo(2), nbreaks);
end
if isempty(num_basi) & ~isempty(breaks)
    nbreaks = length(breaks);
    num_basi  = nbreaks + ordine - 2;
end
if ~isempty(num_basi) & isempty(breaks)
    nbreaks = num_basi - ordine + 2;
    breaks  = linspace(intervallo(1), intervallo(2), nbreaks);
end
nbreaks = length(breaks);
if nbreaks > 2
    param   = breaks(2:(nbreaks-1));
else
    param = [];
end
if ~isempty(param)
    nparams  = length(param);
    if (param(1) <= intervallo(1))
        error('ERRORE NEL RANGE DI VALORI');
    end
    if (param(nparams) >= intervallo(2))
        error('ERRORE NEL RANGE DI VALORI');
    end
end
base.intervallo  = intervallo;
base.num_basi    = num_basi;
base.param    = param;

