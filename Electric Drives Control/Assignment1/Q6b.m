%clear; % Removes variables from the workspace
%% Parameter estimates
Ra = 0.5; % Armature resistance
La = 2.5e-3; % Armature inductance
kf = 0.35; % Flux constant
J = 1e-3; % Moment of inertia
%% Gains of the 2DOF PI current controller
alphac = 2*pi*500; % Closed?loop bandwidth
kpc = alphac*La; % Proportional gain
kic = alphac^2*La; % Integral gain
r = kpc - Ra; % Active resistance
Umax = 140; % Saturation: upper limit
Umin = -140; % Saturation: lower limit

%% Plotting TM, TMref and wM
%subplot(2,1,1)
plot(TM.time,TM.data); grid on; hold on;
stairs(TMref.time,TMref.data,'r'); % Discrete signal
axis([0.004 0.008 -1.2 1.2]); % Controls axis scaling
xlabel('Time (s)'); ylabel('Torque (Nm)');
% subplot(2,1,2)
% plot(wM.time,wM.data); grid on;
% axis([0 0.02 -6 6]);
% xlabel('Time (s)'); ylabel('Current (A)');
% 
