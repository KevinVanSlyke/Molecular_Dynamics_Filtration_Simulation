figure();
plot(t, frontPtclTrans(:,1),'r-');
hold on
plot(t, frontPtclTrans(:,2),'r:');
plot(t, upPtclTrans(:,1), 'b-');
plot(t, upPtclTrans(:,2), 'b:');
plot(t, lowPtclTrans(:,1), 'k-');
plot(t, lowPtclTrans(:,2), 'k:');
legend('Front Orifice Argon','Front Orifice Impurity','Upper Orifice Argon','Upper Orifice Impurity','Lower Orifice Argon','Lower Orifice Impurity');
% legend('Front Orifice Impurity','Upper Orifice Impurity','Lower Orifice Impurity');
% legend('Front Orifice Argon','Upper Orifice Argon','Lower Orifice Argon');
ylabel('Particle Count');
xlabel('Time');
title('Particle Transmission Through Orifices');
