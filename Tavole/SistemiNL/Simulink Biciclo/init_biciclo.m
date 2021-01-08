%% Questo script carica nel workspace le variabili di interesse per 
% simulare l'uniciclo

clear all; close all; clc;

disp('Caricamento Biciclo')

%% parametri simulazione

t_end		= 20;		% simulation time
threshold	= 1e-3;		% soglia numerica

%% stato iniziale

x_M_iniziale		= 10;	% posizione asse x iniziale [m]
y_M_iniziale		= -20;	% posizione asse y iniziale [m]
v_P_iniziale		= 1;	% velocita` piano iniziale [m\s]
v_P_dot_iniziale	= 0;	% derivata velocita` piano iniziale [m\s]
theta_P_iniziale	= pi/3;	% angolo heading iniziale [rad]
phi_iniziale		= 0;	% angolo sterzo iniziale [rad]

%% parametri biciclo

L = 1;
