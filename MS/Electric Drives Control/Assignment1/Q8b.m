%% Plotting wM, wMref
plot(wM.time,wM.data); grid on; hold on;
stairs(wMref.time,wMref.data,'r'); % Discrete signal
axis([0 0.017 0 1.2]); % Controls axis scaling
xlabel('Time (s)'); ylabel('Speed (rad/s)');
