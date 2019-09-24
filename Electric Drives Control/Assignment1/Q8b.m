%% Plotting wM, wMref
plot(wM.time,wM.data); grid on; hold on;
stairs(wMref.time,wMref.data,'r'); % Discrete signal
axis([0.12 0.17 -200 200]); % Controls axis scaling
xlabel('Time (s)'); ylabel('Speed (rad/s)');
