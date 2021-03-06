disp('Non Linear model loading: Alessia Biondi, Andrea Ferroni and Francesco Petracci')

if verLessThan('matlab', '7.0')
    warning('You are running a very old (and unsupported) version of MATLAB.  You will very likely encounter significant problems using this files but you are on your own with this');
end

script_path = fileparts( mfilename('fullpath') );

addpath(genpath(fullfile(script_path, 'funzioni_analisi')));
addpath(genpath(fullfile(script_path, 'funzioni_controllo')));

clear script_path