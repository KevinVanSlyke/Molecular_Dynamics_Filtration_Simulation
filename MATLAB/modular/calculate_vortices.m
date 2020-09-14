function [vortices, longestVortex, maxDur] = calculate_vortices(curlV)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

stride=1;
width=0;
angVelThresh=0.5;
durThresh=5;
vortices=zeros(3,2);
nVort=1;
for xInd=1+width:stride:size(curlV,1)-stride
    for yInd=1+width:stride:size(curlV,2)-stride
        duration=0;
        maxDuration=0;
        prevSign = sign(mean(curlV(xInd-width:xInd+width,yInd-width:yInd+width,1),'all'));
        tStart = 0;
        for tInd=2:1:size(curlV,3)
            angV=mean(curlV(xInd-width:xInd+width,yInd-width:yInd+width,tInd),'all');
            curSign=sign(angV);
            %Need to add a min and max for local ang vel
            if (abs(angV) >= angVelThresh) && (curSign==prevSign)
                duration = duration+1;
                if duration == 1
                    tStart = tInd;
                end
            else
                tEnd = tInd;
                if (duration >= durThresh)
                    vortices(:,:,nVort) = [xInd-width, xInd+width; yInd-width, yInd+width; tStart, tEnd];
                    if (duration > maxDuration)
                        maxDuration = duration;
                        longestVortex = vortices(:,:,nVort);
                        maxDur = maxDuration;
                    end
                    nVort=nVort+1;
                end
                duration=0;
            end
            prevSign=curSign; 
        end
    end
end

save('angularVel.mat', 'vortices', 'longestVortex', 'maxDuration');

end