subplot(2,1,1); % Divides the figure to two subplots
%plot(ia.time,ia.data); grid on;
IN = 20; % Rated current
plot(ia.time,ia.data/IN); grid on;% This would plot the p.u. current
xlabel('Time (s)'); ylabel('per unit Current (p.u.)');
subplot(2,1,2);
nN=3000;%rev/min
wN=nN*(2*pi/60);
plot(wM.time,wM.data/wN); grid on;
xlabel('Time (s)'); ylabel('per unit Speed (p.u.)');