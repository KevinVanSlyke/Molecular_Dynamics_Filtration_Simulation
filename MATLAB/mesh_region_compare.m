function [] = mesh_region_compare(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI)

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

countAMax = max(countA,[],'all');
tempAMax = max(tempA,[],'all');
countIMax = max(countI,[],'all');
tempIMax = max(tempI,[],'all');
% kinetic = countA.*tempA+countI.*tempI;
kinetic = countA.*tempA;

kineticMax = max(kinetic,[],'all');
kineticMin = min(kinetic,[],'all');
kinTickSpace = round(kineticMax/10,2,'significant');
maxAMag = max((uA.^2+vA.^2).^(1/2),[],'all');
maxIMag = max((uI.^2+vI.^2).^(1/2),[],'all');
maxMag = max(maxAMag,maxIMag);
uANorm = uA./maxMag;
vANorm = vA./maxMag;
uINorm = uI./maxMag;
vINorm = vI./maxMag;

e1uA=uA(52:53,42:47,:);
e1vA=vA(52:53,42:47,:);
e1countA=countA(52:53,42:47,:);
e1tempA=tempA(52:53,42:47,:);
e1uI=uI(52:53,42:47,:);
e1vI=uI(52:53,42:47,:);
e1countI=countI(52:53,42:47,:);
e1tempI=tempI(52:53,42:47,:);
e1kinetic=kinetic(52:53,42:47,:);

e2uA=uA(52:53,54:59,:);
e2vA=vA(52:53,54:59,:);
e2countA=countA(52:53,54:59,:);
e2tempA=tempA(52:53,54:59,:);
e2uI=uI(52:53,54:59,:);
e2vI=uI(52:53,54:59,:);
e2countI=countI(52:53,54:59,:);
e2tempI=tempI(52:53,54:59,:);
e2kinetic=kinetic(52:53,54:59,:);

e3uA=uA(58:59,36:41,:);
e3vA=vA(58:59,36:41,:);
e3countA=countA(58:59,36:41,:);
e3tempA=tempA(58:59,36:41,:);
e3uI=uI(58:59,36:41,:);
e3vI=uI(58:59,36:41,:);
e3countI=countI(58:59,36:41,:);
e3tempI=tempI(58:59,36:41,:);
e3kinetic=kinetic(58:59,36:41,:);

e4uA=uA(58:59,48:53,:);
e4vA=vA(58:59,48:53,:);
e4countA=countA(58:59,48:53,:);
e4tempA=tempA(58:59,48:53,:);
e4uI=uI(58:59,48:53,:);
e4vI=uI(58:59,48:53,:);
e4countI=countI(58:59,48:53,:);
e4tempI=tempI(58:59,48:53,:);
e4kinetic=kinetic(58:59,48:53,:);

e5uA=uA(58:59,60:65,:);
e5vA=vA(58:59,60:65,:);
e5countA=countA(58:59,60:65,:);
e5tempA=tempA(58:59,60:65,:);
e5uI=uI(58:59,60:65,:);
e5vI=uI(58:59,60:65,:);
e5countI=countI(58:59,60:65,:);
e5tempI=tempI(58:59,60:65,:);
e5kinetic=kinetic(58:59,60:65,:);

o1uA(:,:)=uA(51,48:53,:);
o1vA(:,:)=vA(51,48:53,:);
o1countA(:,:)=countA(51,48:53,:);
o1tempA(:,:)=tempA(51,48:53,:);
o1uI(:,:)=uI(51,48:53,:);
o1vI(:,:)=uI(51,48:53,:);
o1countI(:,:)=countI(51,48:53,:);
o1tempI(:,:)=tempI(51,48:53,:);
o1kinetic(:,:)=kinetic(51,48:53,:);

o21uA(:,:)=uA(57,42:47,:);
o21vA(:,:)=vA(57,42:47,:);
o21countA(:,:)=countA(57,42:47,:);
o21tempA(:,:)=tempA(57,42:47,:);
o21uI(:,:)=uI(57,42:47,:);
o21vI(:,:)=uI(57,42:47,:);
o21countI(:,:)=countI(57,42:47,:);
o21tempI(:,:)=tempI(57,42:47,:);
o21kinetic(:,:)=kinetic(57,42:47,:);

o22uA(:,:)=uA(57,54:59,:);
o22vA(:,:)=vA(57,54:59,:);
o22countA(:,:)=countA(57,54:59,:);
o22tempA(:,:)=tempA(57,54:59,:);
o22uI(:,:)=uI(57,54:59,:);
o22vI(:,:)=uI(57,54:59,:);
o22countI(:,:)=countI(57,54:59,:);
o22tempI(:,:)=tempI(57,54:59,:);
o22kinetic(:,:)=kinetic(57,54:59,:);

m1uA(:,:,:)=uA(52:56,1:41,:);
m1vA(:,:,:)=vA(52:56,1:41,:);
m1countA(:,:,:)=countA(52:56,1:41,:);
m1tempA(:,:,:)=tempA(52:56,1:41,:);
m1uI(:,:,:)=uI(52:56,1:41,:);
m1vI(:,:,:)=uI(52:56,1:41,:);
m1countI(:,:,:)=countI(52:56,1:41,:);
m1tempI(:,:,:)=tempI(52:56,1:41,:);
m1kinetic(:,:,:)=kinetic(52:56,1:41,:);

m2uA(:,:,:)=uA(52:56,42:59,:);
m2vA(:,:,:)=vA(52:56,42:59,:);
m2countA(:,:,:)=countA(52:56,42:59,:);
m2tempA(:,:,:)=tempA(52:56,42:59,:);
m2uI(:,:,:)=uI(52:56,42:59,:);
m2vI(:,:,:)=uI(52:56,42:59,:);
m2countI(:,:,:)=countI(52:56,42:59,:);
m2tempI(:,:,:)=tempI(52:56,42:59,:);
m2kinetic(:,:,:)=kinetic(52:56,42:59,:);

m3uA(:,:,:)=uA(52:56,60:100,:);
m3vA(:,:,:)=vA(52:56,60:100,:);
m3countA(:,:,:)=countA(52:56,60:100,:);
m3tempA(:,:,:)=tempA(52:56,60:100,:);
m3uI(:,:,:)=uI(52:56,60:100,:);
m3vI(:,:,:)=uI(52:56,60:100,:);
m3countI(:,:,:)=countI(52:56,60:100,:);
m3tempI(:,:,:)=tempI(52:56,60:100,:);
m3kinetic(:,:,:)=kinetic(52:56,60:100,:);

uO1(:)=mean(uI(51,48:53,:).*countI(51,48:53,:)+uA(51,48:53,:).*countA(51,48:53,:)./(countI(51,48:53,:)+countA(51,48:53,:)));
uO1(isnan(uO1))=0;
uO21(:)=mean(uI(57,42:47,:).*countI(57,42:47,:)+uA(57,42:47,:).*countA(57,42:47,:)./(countI(57,42:47,:)+countA(57,42:47,:)));
uO21(isnan(uO21))=0;
uO22(:)=mean(uI(57,54:59,:).*countI(57,54:59,:)+uA(57,54:59,:).*countA(57,54:59,:)./(countI(57,54:59,:)+countA(57,54:59,:)));
uO22(isnan(uO22))=0;

uF(:)=mean(uI(48,:,:).*countI(48,:,:)+uA(48,:,:).*countA(48,:,:)./(countI(48,:,:)+countA(48,:,:)));
uF(isnan(uF))=0;
uM(:)=mean(uI(54,:,:).*countI(54,:,:)+uA(54,:,:).*countA(54,:,:)./(countI(54,:,:)+countA(54,:,:)));
uM(isnan(uM))=0;
uR(:)=mean(uI(60,:,:).*countI(60,:,:)+uA(60,:,:).*countA(60,:,:)./(countI(60,:,:)+countA(60,:,:)));
uR(isnan(uR))=0;


cutInd = size(t,1);
% cutInd = 201;

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;

% meanK(:) = mean(m2kinetic,[1 2]);
% plot(t(1:cutInd)',meanK(1:cutInd), 'Color', [.75 .75 .75]);
% meanK(:) = mean(kinetic(60:61,:,:),[1 2]);
% plot(t(1:cutInd)',meanK(1:cutInd), 'Color', [0 0 0]);
% meanK(:) = mean(e3kinetic,[1 2]);

meanK(:) = mean(e1kinetic,[1 2]);
plot(t(1:cutInd)',meanK(1:cutInd), 'Color', [0, 0.4470, 0.7410]);
meanK(:) = mean(e2kinetic,[1 2]);
plot(t(1:cutInd)',meanK(1:cutInd), 'Color', [0.8500, 0.3250, 0.0980]);
meanK(:) = mean(e3kinetic,[1 2]);
plot(t(1:cutInd)',meanK(1:cutInd),'Color',[0.9290, 0.6940, 0.1250]);
meanK(:) = mean(e4kinetic,[1 2]);
plot(t(1:cutInd)',meanK(1:cutInd),'Color',[0.4940, 0.1840, 0.5560]);
meanK(:) = mean(e5kinetic,[1 2]);
plot(t(1:cutInd)',meanK(1:cutInd),'Color',[0.4660, 0.6740, 0.1880]);
title("Kinetic Energy Near Corners", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Kinetic Energy, $E^*$",'Interpreter','Latex');
% legend('Lower Front', 'Upper Front', 'Lower Rear', 'Center Rear', 'Upper Rear');
legend('Filter Center', 'Rear Slice', 'Lower Rear', 'Center Rear', 'Upper Rear');
% legend('Rear Slice','Lower Rear', 'Center Rear', 'Upper Rear');
% print('Edge_Kinetic_Short', '-dpng');
print('Edge_Kinetic', '-dpng');
close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
plot(t(1:cutInd)',uO21(1:cutInd));
plot(t(1:cutInd)',uO22(1:cutInd));
plot(t(1:cutInd)',uO1(1:cutInd),'Color',[0.4940 0.1840 0.5560]);
title("Average Velocity, Inside Orifices", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Horizontal Velocity, $v^*$",'Interpreter','Latex');
legend('Lower Rear Orifice','Upper Rear Orifice','Front Orifice');
% print('Orifice_Velocity_Short', '-dpng');
print('Orifice_Velocity', '-dpng');
close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
meanK(:) = mean(kinetic(57,42:47,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK);
meanK(:) = mean(kinetic(57,54:59,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK);
meanK(:) = mean(kinetic(51,48:53,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK);
title("Kinetic Energy, Inside Orifices", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Kinetic Energy, $E^*$",'Interpreter','Latex');
legend('Lower Rear Orifice','Upper Rear Orifice','Front Orifice');
% print('Orifice_Kinetic_Short', '-dpng');
print('Orifice_Kinetic', '-dpng');
close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
plot(t(1:cutInd)',uF(1:cutInd));
plot(t(1:cutInd)',uM(1:cutInd));
plot(t(1:cutInd)',uR(1:cutInd));
title("Average Velocity, Vertical Slices", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Horizontal Velocity, $v^*$",'Interpreter','Latex');
legend('Front', 'Center', 'Rear');
% print('Slice_Velocity_Short', '-dpng');
print('Slice_Velocity', '-dpng');
close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
meanK(:) = mean(m1kinetic(:,:,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK,'Color',[0.4940 0.1840 0.5560]);
meanK(:) = mean(m2kinetic(:,:,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK,'Color',[0.4660 0.6740 0.1880]);
meanK(:) = mean(m3kinetic(:,:,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK,'Color',[0.3010 0.7450 0.9330]);
title("Kinetic Energy, Internal Filter Regions", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Kinetic Energy, $E^*$",'Interpreter','Latex');
legend('Below Orifices', 'Between Orifices', 'Above Orifices');
% print('Internal_Kinetic_Short', '-dpng');
print('Internal_Kinetic', '-dpng');
close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
meanK(:) = mean(kinetic(48,:,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK);
meanK(:) = mean(kinetic(54,:,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK);
meanK(:) = mean(kinetic(60,:,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanK);
title("Kinetic Energy, Vertical Slices", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("Kinetic Energy, $E^*$",'Interpreter','Latex');
legend('Front', 'Center', 'Rear');
% print('Slice_Kinetic_Short', '-dpng');
print('Slice_Kinetic', '-dpng');
close(qFig);

qFig = figure('Visible','on');
pos = get(qFig,'position');
set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])
hold on;
meanI(:) = sum(countI(52:56,1:41,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanI,'Color',[0.4940 0.1840 0.5560]);
meanI(:) = sum(countI(52:56,42:59,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanI,'Color',[0.4660 0.6740 0.1880]);
meanI(:) = sum(countI(52:56,60:100,1:cutInd),[1 2]);
plot(t(1:cutInd)',meanI,'Color',[0.3010 0.7450 0.9330]);
title("Impurity Count, Internal Filter Regions", 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("Time, $t^*$",'Interpreter','Latex');
ylabel("$N_I$",'Interpreter','Latex');
legend('Below Orifices', 'Between Orifices', 'Above Orifices');
% print('Internal_Impurity_Short', '-dpng');
print('Internal_Impurity', '-dpng');
close(qFig);
end