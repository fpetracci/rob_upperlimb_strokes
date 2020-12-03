disp('Data Analysis: Alessia Biondi, Andrea Ferroni and Francesco Petracci')

if verLessThan('matlab', '7.0')
    warning('You are running a very old (and unsupported) version of MATLAB.  You will very likely encounter significant problems using this files but you are on your own with this');
end

script_path = fileparts( mfilename('fullpath') );

addpath(genpath(fullfile(script_path, 'dynamic_model')));

clear script_path