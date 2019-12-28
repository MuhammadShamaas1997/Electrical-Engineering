subplot(3,1,1);hold on; % Divides the figure to two subplots
plot(iqs.time,iqs.data); grid on;%axis([0 5 1.56 1.57]);% This would plot the current
plot(iqs_k.time,iqs_k.data); grid on;axis([2.498 2.512 0.5 2.5]);% This would plot the current
xlabel('Time (s)'); ylabel('iqs (A)');

subplot(3,1,2);hold on;
plot(ids.time,ids.data); grid on;%axis([0 5 7.81 7.82]);% This would plot the current
plot(ids_k.time,ids_k.data); grid on;axis([2.498 2.512 5 9]);% This would plot the current
xlabel('Time (s)'); ylabel('ids (A)');

subplot(3,1,3);hold on;
plot(vqs.time,vqs.data); grid on;
xlabel('Time (s)'); ylabel('vqs (V)');axis([2.498 2.512 -10 210]);