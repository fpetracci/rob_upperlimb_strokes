% author: Claudio Gaz, Marco Cognetti
% date: August 2, 2019
% 
% -------------------------------------------------
% Parameters Retrieval Algorithm
% -------------------------------------------------
% C. Gaz, M. Cognetti, A. Oliva, P. Robuffo Giordano, A. De Luca, 'Dynamic
% Identification of the Franka Emika Panda Robot With Retrieval of Feasible
% Parameters Using Penalty-Based Optimization'. IEEE RA-L, 2019.
%
% the following code has been tested on Matlab 2018b

close all
clc
clear all

% global variables
global SA_step Y_stack_LI tau_stack P_li_full_subs num_of_samples use_complete_regressor

num_of_joints = 7; % DoFs of the Franka Emika Panda robot

% --------------------
% phi function choice
% --------------------
% 'false' if phi(p_k) = || pi(p_k) - pi_hat ||^2, (two-steps ident.)
% 'true' if phi(p_k) = || Y_stack*pi(p_k) - tau_stack ||^2 (one-step ident.) 
use_complete_regressor = true;

% load numerical evaluated regressor and symbolic dynamic coefficients,
% useful for final cross-validation and in case use_complete_regressor =
% true.
%
% In particular:
%  - Y_stack_LI contains a stacked evaluated regressor (exciting
%  trajectories have been used)
%  - tau_stack contains the vector of stacked measurements (joint
%  torques)
%  - P_li_full contains the symbolic dynamic coefficients vector, with
%  the inertia tensors expressed w.r.t. link frames
%  - P_li_full_subs contains the symbolic dynamic coefficients vector,
%  with the inertia tensors expressed w.r.t. link CoMs
load regressor_and_pars_data

% total samples retrieved during exciting trajectories
num_of_samples = size(Y_stack_LI,1)/num_of_joints; 

% ---------------------------
% read lower and upper bounds
% ---------------------------
if use_complete_regressor
    [LB,UB] = read_bounds('bounds_gM_friction.csv'); 
else
    [LB,UB] = read_bounds('bounds_gM.csv');
end

%----------------------------------
% initializations
%----------------------------------
num_of_runs = 10; % independent (parallelizable) runs of the entire algorithm (29)
num_of_SA_steps = 5; % successive runs of the algorithm (29). It is the variable \kappa in (29)

num_x = length(LB); % number of parameters

% LOSSES vector contains the values of the loss functions for each
% independent run in num_of_runs. They are initialized to +infinity
LOSSES = Inf*ones(num_of_runs,1);

% SOL vector contains the solution (that is, the estimated values of the
% dynamic parameters) for each independent run in num_of_runs
SOL = zeros(num_x,num_of_runs);

% OUTPUTS and EXITFLAGS are variables related to 'simulannealbnd' Matlab
% function
OUTPUTS = cell(num_of_runs,1);
EXITFLAGS = zeros(num_of_runs,1);

%----------------------------------
% optimizator: Simulated Annealing
%----------------------------------

for i=1:num_of_runs
    for SA_step=1:num_of_SA_steps
        stringtodisp = sprintf('RUN %d of %d, step %d of %d',i,num_of_runs,SA_step,num_of_SA_steps);
        disp(stringtodisp);
        if SA_step==1
            X0 = rand(num_x,1).*(UB-LB) + LB; % random initial point inside bounds
        end
        options = saoptimset('HybridFcn',{@fmincon}); % use Nelder-Mead optimization as hybrid function

        if use_complete_regressor
            [X,FVAL,EXITFLAG,OUTPUT] = simulannealbnd(@(x) error_fcn_gM_LMI_regressor(x),X0,LB,UB,options);
        else
            [X,FVAL,EXITFLAG,OUTPUT] = simulannealbnd(@(x) error_fcn_gM_LMI(x),X0,LB,UB,options);
        end

        X0 = X;
    end
    disp('---------------------------');
    disp(sprintf('.........LOSS = %f',FVAL));
    disp('---------------------------');
    LOSSES(i) = FVAL;
    SOL(:,i) = X;
    OUTPUTS{i} = OUTPUT;
    EXITFLAGS(i) = EXITFLAG;
  
end

% retrieve optimal solution
min_idx = find(LOSSES==min(LOSSES));
optimal_solution = SOL(:,min_idx);

%----------------------------------
% Self-validation
%----------------------------------

m1 = optimal_solution(1);
m2 = optimal_solution(2);
m3 = optimal_solution(3);
m4 = optimal_solution(4);
m5 = optimal_solution(5);
m6 = optimal_solution(6);
m7 = optimal_solution(7);
c1x = optimal_solution(8);
c1y = optimal_solution(9);
c1z = optimal_solution(10);
c2x = optimal_solution(11);
c2y = optimal_solution(12);
c2z = optimal_solution(13);
c3x = optimal_solution(14);
c3y = optimal_solution(15);
c3z = optimal_solution(16);
c4x = optimal_solution(17);
c4y = optimal_solution(18);
c4z = optimal_solution(19);
c5x = optimal_solution(20);
c5y = optimal_solution(21);
c5z = optimal_solution(22);
c6x = optimal_solution(23);
c6y = optimal_solution(24);
c6z = optimal_solution(25);
c7x = optimal_solution(26);
c7y = optimal_solution(27);
c7z = optimal_solution(28);
I1xx = optimal_solution(29);
I1xy = optimal_solution(30);
I1xz = optimal_solution(31);
I1yy = optimal_solution(32);
I1yz = optimal_solution(33);
I1zz = optimal_solution(34);
I2xx = optimal_solution(35);
I2xy = optimal_solution(36);
I2xz = optimal_solution(37);
I2yy = optimal_solution(38);
I2yz = optimal_solution(39);
I2zz = optimal_solution(40);
I3xx = optimal_solution(41);
I3xy = optimal_solution(42);
I3xz = optimal_solution(43);
I3yy = optimal_solution(44);
I3yz = optimal_solution(45);
I3zz = optimal_solution(46);
I4xx = optimal_solution(47);
I4xy = optimal_solution(48);
I4xz = optimal_solution(49);
I4yy = optimal_solution(50);
I4yz = optimal_solution(51);
I4zz = optimal_solution(52);
I5xx = optimal_solution(53);
I5xy = optimal_solution(54);
I5xz = optimal_solution(55);
I5yy = optimal_solution(56);
I5yz = optimal_solution(57);
I5zz = optimal_solution(58);
I6xx = optimal_solution(59);
I6xy = optimal_solution(60);
I6xz = optimal_solution(61);
I6yy = optimal_solution(62);
I6yz = optimal_solution(63);
I6zz = optimal_solution(64);
I7xx = optimal_solution(65);
I7xy = optimal_solution(66);
I7xz = optimal_solution(67);
I7yy = optimal_solution(68);
I7yz = optimal_solution(69);
I7zz = optimal_solution(70);

if use_complete_regressor % consider friction pars

    fc1 = optimal_solution(71);
    fc2 = optimal_solution(72);
    fc3 = optimal_solution(73);
    fc4 = optimal_solution(74);
    fc5 = optimal_solution(75);
    fc6 = optimal_solution(76);
    fc7 = optimal_solution(77);
    fv1 = optimal_solution(78);
    fv2 = optimal_solution(79);
    fv3 = optimal_solution(80);
    fv4 = optimal_solution(81);
    fv5 = optimal_solution(82);
    fv6 = optimal_solution(83);
    fv7 = optimal_solution(84);
    fo1 = optimal_solution(85);
    fo2 = optimal_solution(86);
    fo3 = optimal_solution(87);
    fo4 = optimal_solution(88);
    fo5 = optimal_solution(89);
    fo6 = optimal_solution(90);
    fo7 = optimal_solution(91);
    
else % set friction pars to zero
    fc1 = 0;
    fc2 = 0;
    fc3 = 0;
    fc4 = 0;
    fc5 = 0;
    fc6 = 0;
    fc7 = 0;
    fv1 = 0;
    fv2 = 0;
    fv3 = 0;
    fv4 = 0;
    fv5 = 0;
    fv6 = 0;
    fv7 = 0;
    fo1 = 0;
    fo2 = 0;
    fo3 = 0;
    fo4 = 0;
    fo5 = 0;
    fo6 = 0;
    fo7 = 0;
end

% compute coefficients vector with the estimated dynamic parameters
P_li_expanded_eval = get_Panda_coefficients_expanded(I2xx,I2xy,I3xx,I2xz,I3xy,I4xx,I3xz,I4xy,I5xx,I4xz,I5xy,I6xx,I5xz,I6xy,I7xx,I6xz,I7xy,I7xz,I2yy,I2yz,I3yy,I3yz,I4yy,I4yz,I5yy,I5yz,I6yy,I6yz,I7yy,I7yz,I1zz,I2zz,I3zz,I4zz,I5zz,I6zz,I7zz,c1x,c2x,c3x,c4x,c5x,c6x,c7x,c1y,c2y,c3y,c4y,c5y,c6y,c7y,c2z,c3z,c4z,c5z,c6z,c7z,fc1,fc2,fc3,fc4,fc5,fc6,fc7,fo1,fo2,fo3,fo4,fo5,fo6,fo7,fv1,fv2,fv3,fv4,fv5,fv6,fv7,m1,m2,m3,m4,m5,m6,m7);

% joint torques estimation
tau_stack_estimation = Y_stack_LI*P_li_expanded_eval;

% reshape tau_stack vectors (measured and estimated)
TAU_TRUE = zeros(num_of_joints,num_of_samples);
TAU_ESTD = zeros(num_of_joints,num_of_samples);
for i = 1 : num_of_samples
    for j = 1:7
        TAU_TRUE(j,i) = tau_stack((i-1)*7 + j);
        TAU_ESTD(j,i) = tau_stack_estimation((i-1)*7 + j);
    end
end

% plot validation results
figure
samples = 1:num_of_samples;
for i=1:num_of_joints
    subplot(4,2,i);
    plot(samples,TAU_TRUE(i,:),samples,TAU_ESTD(i,:));
    grid;
    xlabel('samples [#]');
    ylabel('torque [Nm]');
    if i==7
        legend('true','estimated');
    end
end
    