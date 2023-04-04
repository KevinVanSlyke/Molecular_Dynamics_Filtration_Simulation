function [] = wca_multi_D_potentials()
    epsilon = 1;
    Sigma = 1;
    uFig = figure();
    hold on
    x=0:0.01:40;
    plot(x,wca(x,epsilon,Sigma),x,lj(x,epsilon,Sigma));
%     plot(x,wca(x,epsilon,Sigma));
%     plot(x,wca(x,epsilon,5*Sigma));
    axis([0 4 -1.5 3]);
    ylabel("$U/\epsilon$ (Dimensionless)", 'Interpreter', 'latex','FontSize',12);
    xlabel("$r/\sigma$ (Dimensionless)", 'Interpreter', 'latex','FontSize',12);
    xFrom = 0;
    xToWCA = 2^(1/6)*Sigma;
    yConstLJ = -epsilon;
    plot([xFrom xToWCA], [yConstLJ yConstLJ], ':k');
    yTo = -1;
    yFrom = -2;
    xConst = 2^(1/6)*Sigma;
    plot([xConst xConst], [yTo yFrom], ':k');
    legend("WCA Potential", "LJ Potential");
%     xticks([1,2^(1/6)*Sigma,2,3,4]);
%     xticklabels({'1','$r_m$','2','3','4'}, "interpreter","latex");
end
