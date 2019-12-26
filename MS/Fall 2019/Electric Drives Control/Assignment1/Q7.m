%% Plotting wM, wMref, ia, iaref TM and TMref
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
