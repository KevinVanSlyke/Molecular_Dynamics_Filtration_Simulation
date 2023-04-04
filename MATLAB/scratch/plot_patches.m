function [] = plot_patches()
figure;
zCut = 0;
xLo=0;
xHi=100;
yLo=0;
yHi=100;

width = 20;
depth = 10;
spacing = 40;
separation = 20;
shift = 20;
xMid = 50;
yMid = 50;
xLeft = xMid;
yLeft = yMid-width/2;
xRight = xMid+depth+separation;
yRight = yMid+shift-spacing-width/2;


patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor','none');
patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor','none');
patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor','none');
patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+width+spacing yRight+width+spacing yRight+width], [zCut zCut zCut zCut], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor','none');
patch( [xRight xRight xRight+depth xRight+depth], [yRight+2*width+spacing 2000 2000 yRight+2*width+spacing], [zCut zCut zCut zCut], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor','none');
axis([20 120 0 120])

end