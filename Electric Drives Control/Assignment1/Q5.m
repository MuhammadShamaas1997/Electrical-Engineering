Tsw=200e-6;
Udc=140;
subplot(2,1,1)
plot(ia.time,ia.data); grid on; hold on;
stairs(ia_k.time,ia_k.data,'r'); % Discrete signal
axis([0.15 0.1504 9 11]); % Controls axis scaling
xlabel('Time (s)'); ylabel('Current (A)');
subplot(2,1,2)
plot(ua.time,ua.data); grid on;
axis([0.15 0.1504 -10 150]);
xlabel('Time (s)'); ylabel('Voltage (V)');