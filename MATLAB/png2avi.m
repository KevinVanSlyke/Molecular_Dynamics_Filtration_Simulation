function [] = png2avi(fRate)

% writerObj = VideoWriter('Zoom_ArgonVelocity_LogKE.avi');
writerObj = VideoWriter('Angular_ArgonVelocity.avi');

%writerObj = VideoWriter('Impurity_Velocity_Quiver.avi');
%writerObj = VideoWriter('Impurity_Count.avi');
%writerObj = VideoWriter('Impurity_Temp.avi');
%writerObj = VideoWriter('Impurity_Pres.avi');

%writerObj = VideoWriter('Argon_Velocity_Quiver.avi');
%writerObj = VideoWriter('Argon_Count.avi');
%writerObj = VideoWriter('Argon_Temp.avi');
%writerObj = VideoWriter('Argon_Pres.avi');

%writerObj = VideoWriter('Gas_Velocity_Quiver.avi');
%writerObj = VideoWriter('Gas_Count.avi');
%writerObj = VideoWriter('Gas_Temp.avi');
%writerObj = VideoWriter('Gas_Pres.avi');

writerObj.FrameRate=fRate;
open(writerObj);
for K = 0 : 1000 : 99000
    
    filename = sprintf('Angular_ArgonVelocity_Timestep_%d.png', K);
%     filename = sprintf('ArgonVelocity_LogKE_Timestep_%d.png', K);

%    filename = sprintf('Impurity_Quiver_Timestep_%d.png', K);
%    filename = sprintf('Impurity_Count_Timestep_%d.png', K);
%    filename = sprintf('Impurity_Temp_Timestep_%d.png', K);
%    filename = sprintf('Impurity_Pres_Timestep_%d.png', K);

%    filename = sprintf('Argon_Quiver_Timestep_%d.png', K);
%    filename = sprintf('Argon_Count_Timestep_%d.png', K);
%    filename = sprintf('Argon_Temp_Timestep_%d.png', K);
%    filename = sprintf('Argon_Pres_Timestep_%d.png', K);

%    filename = sprintf('Gas_Quiver_Timestep_%d.png', K);
%    filename = sprintf('Gas_Count_Timestep_%d.png', K);
%    filename = sprintf('Gas_Temp_Timestep_%d.png', K);
%    filename = sprintf('Gas_Pres_Timestep_%d.png', K);

    thisimage = imread(filename);
    writeVideo(writerObj, thisimage);
end
close(writerObj);

end