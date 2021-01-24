%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load_KUKA_DH() Builds and returns the D-H table of the Franka Emika   %
% Panda Robot (Modified DH).                                              %
% The kinematic chain is built until the flange frame, for that           %
% reason it seems to have 6 joints but, the last one is kept fixed.       %
% The format of the D-H table follows the example:                        %
% D-H table format example:                                               %
%  joint type | d_i | theta_i | a_i  | alpha_i                            %
%       1     | d1  |    q1   |  0   |   pi/2                             %
%                                                                         %
% joint type: 1 'revolute', 2 'prismatic'                                 %
% Convention: 'classic' (default) | 'modified'                            %
%                                                                         %
%                                                                         %
%   Author: Alexander Oliva                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [DH, Convention] = Load_KUKA_DH()

    j = ones(6,1);
    d = [0.400 0 0 0.384 0.080 0 ]';
    theta = [0 0 0 0 0 0 ]';
    a = [0.025 0.315 0.365 0 0 0 ]';
    alphas = [pi/2 0 0 pi/2 0 0  ]';
    Convention = 'modified';
    DH = [j, d, theta, a, alphas];

end