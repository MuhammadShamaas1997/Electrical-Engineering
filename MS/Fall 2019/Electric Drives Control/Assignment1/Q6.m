%% Plotting TM, TMref and wM
subplot(2,1,1)
plot(TM.time,TM.data); grid on; hold on;
stairs(TMref.time,TMref.data,'r'); % Discrete signal
axis([0 0.02 -1.2 1.2]); % Controls axis scaling
xlabel('Time (s)'); ylabel('Torque (Nm)');
subplot(2,1,2)
plot(wM.time,wM.data); grid on;
axis([0 0.02 -6 6]);
xlabel('Time (s)'); ylabel('Speed (rad/s)');

