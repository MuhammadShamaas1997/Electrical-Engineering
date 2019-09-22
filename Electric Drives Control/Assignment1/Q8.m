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
%% Gains of the 2DOF PI speed controller (for Section 4.2)
alphas = 0.1*alphac; % Closed?loop bandwidth
kps = alphas*La; % Proportional gain
kis = alphas^2*La; % Integral gain
b = kps - Ra; % Active damping
TN = 7; % Rated torque
Tmax = 2*TN; % Saturation: upper limit
Tmin = -2*TN; % Saturation: lower limit

%% Plotting wM, wMref, iaref, ia, TM and TMref
subplot(3,1,1)
plot(wM.time,wM.data); grid on; hold on;
stairs(wMref.time,wMref.data,'r'); % Discrete signal
axis([0 0.5 -200 200]); % Controls axis scaling
xlabel('Time (s)'); ylabel('Speed (rad/s)');
subplot(3,1,2)
plot(ia.time,ia.data); grid on;hold on;
plot(iaref.time,iaref.data,'r');
axis([0 0.5 -50 50]);
xlabel('Time (s)'); ylabel('Current (A)');
subplot(3,1,3)
plot(TM.time,TM.data); grid on;hold on;
plot(TMref.time,TMref.data,'r');
axis([0 0.5 -20 20]);
xlabel('Time (s)'); ylabel('Torque (Nm)');
