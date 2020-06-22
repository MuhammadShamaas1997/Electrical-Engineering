hold on;
% subplot(3,2,1)
% plot(Vinput.time,Vinput.signals.values);
% xlabel('Time (s)');
% ylabel('Input Voltage (V)');
% axis([0.24997 0.25 -200 200]);
% 
% subplot(3,2,2)
% plot(Iprimary.time,Iprimary.signals.values);
% xlabel('Time (s)');
% ylabel('Input Current (A)');
% axis([0.24995 0.25 0 125]);
% 
% 
% subplot(3,2,3)
% hold on;
% plot(Vou.time,Vou.signals.values);
% xlabel('Time (s)');
% ylabel('Output Voltage 1 (V)');
% axis([0.24997 0.25 4.88 4.89]);
% 
% subplot(3,2,4)
% hold on;
% plot(Iou.time,Iou.signals.values);
% xlabel('Time (s)');
% ylabel('Output Current 1 (A)');
% axis([0.24997 0.25 97.6 97.8]);
% 
% 
% subplot(3,2,5)
% hold on;
% plot(Vol.time,Vol.signals.values);
% xlabel('Time (s)');
% ylabel('Output Voltage 2 (V)');
% axis([0.24997 0.25 14.92 14.94]);
% 
% subplot(3,2,6)
% hold on;
% plot(Iol.time,Iol.signals.values);
% xlabel('Time (s)');
% ylabel('Output Current 2 (A)');
% axis([0.24997 0.25 14.92 14.94]);


%subplot(2,1,1)
hold on;
plot(((Vinput.time)*1000)-249.92,Vinput.signals.values);
plot(((Iprimary.time)*1000)-249.92,Iprimary.signals.values,'r');
xlabel('Time (ms)');
ylabel('Input Voltage (V)/ Input Current (A)');
legend('Voltage','Current')
axis([0 250-249.92 -200 200]);
grid('on')

% subplot(2,1,2)
% hold on;
% plot(Iprimary.time,Iprimary.signals.values);
% plot(Ioup.time,Ioup.signals.values,'r');
% xlabel('Time (s)');
% ylabel('Current (A)');
% legend('Input','Output')
% axis([0.2 0.25 -500 500]);