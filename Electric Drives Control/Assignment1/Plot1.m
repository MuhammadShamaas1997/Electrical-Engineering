subplot(2,1,1); % Divides the figure to two subplots
plot(ia.time,ia.data); grid on;
%IN = 20; % Rated current
%plot(ia.time,ia.data/IN); % This would plot the p.u. current
xlabel('Time (s)'); ylabel('Current (A)');
subplot(2,1,2);
plot(wM.time,wM.data); grid on;
xlabel('Time (s)'); ylabel('Speed (rad/s)');