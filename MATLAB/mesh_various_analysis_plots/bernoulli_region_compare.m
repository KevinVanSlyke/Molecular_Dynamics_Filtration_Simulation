function [] = bernoulli_region_compare(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI)

uA(isnan(uA))=0;
vA(isnan(vA))=0;
uI(isnan(uI))=0;
vI(isnan(vI))=0;

xLow = 800;
xUp = 1400;
yLow = 700;
yUp = 1300;

xOrifice1 = [1020 1020 1020 1020]/20; %51
xOrifice2 = [1140 1140 1140 1140]/20; %57
yOrifice1 = [960 1060 1060 960]/20; %48-53
yOrifice2l = [840 940 940 840]/20; %42-47
yOrifice2u = [1080 1180 1180 1080]/20; %54-59

% countAMax = max(countA,[],'all');
% tempAMax = max(tempA,[],'all');
% countIMax = max(countI,[],'all');
% tempIMax = max(tempI,[],'all');
% kinetic = countA.*tempA+countI.*tempI;

%%This should not be multiplied by the atom count, temp/chunk is already total KE
kinetic = countA.*tempA+countI.*tempI;
% pressure = countA.*(uA.^2+vA.^2).^(1/2)+countI.*(uI.^2+vI.^2).^(1/2);

% kineticMax = max(kinetic,[],'all');
% kineticMin = min(kinetic,[],'all');
% kinTickSpace = round(kineticMax/10,2,'significant');
% maxAMag = max((uA.^2+vA.^2).^(1/2),[],'all');
% maxIMag = max((uI.^2+vI.^2).^(1/2),[],'all');
% maxMag = max(maxAMag,maxIMag);
% uANorm = uA./maxMag;
% vANorm = vA./maxMag;
% uINorm = uI./maxMag;
% vINorm = vI./maxMag;

% e1u = uA(41:50,48:53,:);
% insideVx = uA(51:75,48:53,:);
% rearVx = uA(76:85,48:53,:);
v1 = 200*120;
e1uA=uA(41:50,48:53,:);
% e1flow = 1/2*e1uA.^2;
e1vA=vA(41:50,48:53,:);
e1countA=countA(41:50,48:53,:);
e1tempA=tempA(41:50,48:53,:);
e1uI=uI(41:50,48:53,:);
e1vI=uI(41:50,48:53,:);
e1countI=countI(41:50,48:53,:);
e1tempI=tempI(41:50,48:53,:);
e1kinetic=kinetic(41:50,48:53,:);
% e1pressure = pressure(41:50,48:53,:);
e1mass = e1countA+e1countI*25;
e1press = e1kinetic*v1./e1mass;
e1flow = 1/2*(e1countA.*e1uA.^2+25*e1countI.*e1uI.^2)/v1;

v2 = 500*120;
e2uA=uA(51:75,48:53,:);
e2vA=vA(51:75,48:53,:);
e2countA=countA(51:75,48:53,:);
e2tempA=tempA(51:75,48:53,:);
e2uI=uI(51:75,48:53,:);
e2vI=uI(51:75,48:53,:);
e2countI=countI(51:75,48:53,:);
e2tempI=tempI(51:75,48:53,:);
e2kinetic=kinetic(51:75,48:53,:);
e2pressure = e2kinetic*v1;
e2mass = e2countA+e2countI*25;
e2press = e2kinetic*v2./e2mass;
e2flow = 1/2*(e2countA.*e2uA.^2+25*e2countI.*e2uI.^2)/v2;

v3 = 200*120;
e3uA=uA(76:85,48:53,:);
% e3flow = 1/2*e3uA.^2;
e3vA=vA(76:85,48:53,:);
e3countA=countA(76:85,48:53,:);
e3tempA=tempA(76:85,48:53,:);
e3uI=uI(76:85,48:53,:);
e3vI=uI(76:85,48:53,:);
e3countI=countI(76:85,48:53,:);
e3tempI=tempI(76:85,48:53,:);
e3kinetic=kinetic(76:85,48:53,:);
% e3pressure = pressure(58:59,36:41,:);
e3mass = e3countA+e3countI*25;
e3press = e3kinetic*v3./e3mass;
e3flow = 1/2*(e3countA.*e3uA.^2+25*e3countI.*e3uI.^2)/v2;


cutInd = size(t,1);
% cutInd = 201;

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
meanP1(:) = mean(e1kinetic/v1,[1 2]);
plot(t(1:cutInd)',meanP1(1:cutInd), 'Color', [0, 0.4470, 0.7410]);
meanP2(:) = mean(e2kinetic/v2,[1 2]);
plot(t(1:cutInd)',meanP2(1:cutInd), 'Color', [0.8500, 0.3250, 0.0980]);
meanP3(:) = mean(e3kinetic/v3,[1 2]);
plot(t(1:cutInd)',meanP3(1:cutInd),'Color',[0.9290, 0.6940, 0.1250]);
title("Pressure Next to and Inside Channel", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Energy Density, $E^*/A^*$",'Interpreter','Latex');
% legend('Lower Front', 'Upper Front', 'Lower Rear', 'Center Rear', 'Upper Rear');
legend('Left of Channel', 'Inside Channel', 'Right of Channel');
% legend('Rear Slice','Lower Rear', 'Center Rear', 'Upper Rear');
% print('Edge_Kinetic_Short', '-dpng');
savefig('Pressure Compare.fig');
print('Pressure Compare', '-dpng');
% close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
plot(t(1:cutInd)',meanP1(1:cutInd), 'Color', [0, 0.4470, 0.7410]);
mean1flow(:) = mean(e1flow,[1 2]);
plot(t(1:cutInd)',mean1flow(1:cutInd), 'Color', [0.8500, 0.3250, 0.0980]);
mean1C(:) = meanP1+mean1flow;
plot(t(1:cutInd)',mean1C(1:cutInd),'Color',[0.9290, 0.6940, 0.1250]);
title("Energy Density Left of Channel", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Energy Density, $E^*/A^*$",'Interpreter','Latex');
% legend('Lower Front', 'Upper Front', 'Lower Rear', 'Center Rear', 'Upper Rear');
legend('Pressure', 'Flow Energy Density', 'Total Energy Density');
% legend('Rear Slice','Lower Rear', 'Center Rear', 'Upper Rear');
% print('Edge_Kinetic_Short', '-dpng');
savefig('Left Region Bernoulli.fig');
print('Left Region Bernoulli', '-dpng');
% close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
plot(t(1:cutInd)',meanP2(1:cutInd), 'Color', [0, 0.4470, 0.7410]);
mean2flow(:) = mean(e2flow,[1 2]);
plot(t(1:cutInd)',mean2flow(1:cutInd), 'Color', [0.8500, 0.3250, 0.0980]);
mean2C(:) = meanP2+mean2flow;
plot(t(1:cutInd)',mean2C(1:cutInd),'Color',[0.9290, 0.6940, 0.1250]);
title("Energy Density Inside Channel", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Energy Density, $E^*/A^*$",'Interpreter','Latex');
% legend('Lower Front', 'Upper Front', 'Lower Rear', 'Center Rear', 'Upper Rear');
legend('Pressure', 'Flow Energy Density', 'Total Energy Density');
% legend('Rear Slice','Lower Rear', 'Center Rear', 'Upper Rear');
% print('Edge_Kinetic_Short', '-dpng');
savefig('Channel Bernoulli.fig');
print('Channel Bernoulli', '-dpng');
% close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
plot(t(1:cutInd)',meanP3(1:cutInd), 'Color', [0, 0.4470, 0.7410]);
mean3flow(:) = mean(e3flow,[1 2]);
plot(t(1:cutInd)',mean3flow(1:cutInd), 'Color', [0.8500, 0.3250, 0.0980]);
mean3C(:) = meanP3+mean3flow;
plot(t(1:cutInd)',mean3C(1:cutInd),'Color',[0.9290, 0.6940, 0.1250]);
title("Energy Density Right of Channel", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Energy Density, $E^*/A^*$",'Interpreter','Latex');
% legend('Lower Front', 'Upper Front', 'Lower Rear', 'Center Rear', 'Upper Rear');
legend('Pressure', 'Flow Energy Density', 'Total Energy Density');
% legend('Rear Slice','Lower Rear', 'Center Rear', 'Upper Rear');
% print('Edge_Kinetic_Short', '-dpng');
savefig('Right Region Bernoulli.fig');
print('Right Region Bernoulli', '-dpng');
% close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
plot(t(1:cutInd)',e1flow(1:cutInd), 'Color', [0, 0.4470, 0.7410]);
plot(t(1:cutInd)',e2flow(1:cutInd), 'Color', [0.8500, 0.3250, 0.0980]);
plot(t(1:cutInd)',e3flow(1:cutInd),'Color',[0.9290, 0.6940, 0.1250]);
title("Flow Energy Density Next to and Inside Channel", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Energy Density, $E^*/A^*$",'Interpreter','Latex');
% legend('Lower Front', 'Upper Front', 'Lower Rear', 'Center Rear', 'Upper Rear');
legend('Left of Channel', 'Inside Channel', 'Right of Channel');
% legend('Rear Slice','Lower Rear', 'Center Rear', 'Upper Rear');
% print('Edge_Kinetic_Short', '-dpng');
savefig('Flow Compare.fig');
print('Flow Compare', '-dpng');

smooth1flow = smoothdata(e1flow, 'movmedian', 250);
smooth2flow = smoothdata(e2flow, 'movmedian', 250);
smooth3flow = smoothdata(e3flow, 'movmedian', 250);
qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
plot(t(1:cutInd)',smooth1flow(1:cutInd), 'Color', [0, 0.4470, 0.7410]);
plot(t(1:cutInd)',smooth2flow(1:cutInd), 'Color', [0.8500, 0.3250, 0.0980]);
plot(t(1:cutInd)',smooth3flow(1:cutInd),'Color',[0.9290, 0.6940, 0.1250]);
title("Smoothed Flow Energy Density Next to and Inside Channel", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Energy Density, $E^*/A^*$",'Interpreter','Latex');
% legend('Lower Front', 'Upper Front', 'Lower Rear', 'Center Rear', 'Upper Rear');
legend('Left of Channel', 'Inside Channel', 'Right of Channel');
% legend('Rear Slice','Lower Rear', 'Center Rear', 'Upper Rear');
% print('Edge_Kinetic_Short', '-dpng');
savefig('Smooth Flow Compare.fig');
print('Smooth Flow Compare', '-dpng');
% close(qFig);


smooth1flow = smoothdata(e1flow, 'movmedian', 250);
smooth2flow = smoothdata(e2flow, 'movmedian', 250);
smooth3flow = smoothdata(e3flow, 'movmedian', 250);
qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
plot(t(1:cutInd)',smooth1flow(1:cutInd), 'Color', [0, 0.4470, 0.7410]);
plot(t(1:cutInd)',smooth2flow(1:cutInd), 'Color', [0.8500, 0.3250, 0.0980]);
plot(t(1:cutInd)',smooth3flow(1:cutInd),'Color',[0.9290, 0.6940, 0.1250]);
title("Smoothed Flow Energy Density Next to and Inside Channel", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Energy Density, $E^*/A^*$",'Interpreter','Latex');
% legend('Lower Front', 'Upper Front', 'Lower Rear', 'Center Rear', 'Upper Rear');
legend('Left of Channel', 'Inside Channel', 'Right of Channel');
% legend('Rear Slice','Lower Rear', 'Center Rear', 'Upper Rear');
% print('Edge_Kinetic_Short', '-dpng');
savefig('Smooth Vel Compare.fig');
print('Smooth Flow Compare', '-dpng');
% close(qFig);
end