subplot(3,1,1); % Divides the figure to two subplots
plot(iqs.time,iqs.data); grid on;%axis([0 5 1.56 1.57]);% This would plot the current
xlabel('Time (s)'); ylabel('iqs (A)');

subplot(3,1,2);
plot(ids.time,ids.data); grid on;%axis([0 5 7 8]);% This would plot the current
xlabel('Time (s)'); ylabel('ids (A)');

subplot(3,1,3);
plot(wM.time,wM.data); grid on;
xlabel('Time (s)'); ylabel('Speed (rad/s)');