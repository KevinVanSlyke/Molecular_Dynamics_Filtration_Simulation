% function [t,x,y,uI,vI,uA,vA,countI,countA,tempI,tempA] = read_convert_chunk_files(simString, nBinsX, nBinsY)
function [t,x,y,uA,vA,countA,tempA] = read_convert_chunk_files(simString, nBinsX, nBinsY)
% simString = '120W_1D_120F_100S';
% nBinsX = 102;
% nBinsY = 100;

% aVcmChunkFile=strcat('argon_vcm_', simString, '_0T_r0.chunk');
aVcmChunkFile=strcat('vcm_', simString, '_0T_r0.chunk');
[argonVcmChunkData] = read_chunk(aVcmChunkFile);
% save('argonVcmChunkData.mat','argonVcmChunkData');
[t,x,y,uA,vA] = chunkConvert(argonVcmChunkData, aVcmChunkFile, nBinsX, nBinsY);
clear argonVcmChunkData
save('argonVcmMesh.mat', 't', 'x', 'y', 'uA','vA', 'aVcmChunkFile');

% aCountChunkFile=strcat('argon_count_', simString, '_0T_r0.chunk');
aCountChunkFile=strcat('count_', simString, '_0T_r0.chunk');
[argonCountChunkData] = read_chunk(aCountChunkFile);
% save('argonCountChunkData.mat','argonCountChunkData');
[t,x,y,countA] = chunkCountConvert(argonCountChunkData, aCountChunkFile, nBinsX, nBinsY);
clear argonCountChunkData
save('argonCountMesh.mat', 't', 'x', 'y', 'countA','aCountChunkFile');

% aTempChunkFile=strcat('argon_temp_', simString, '_0T_r0.chunk');
aTempChunkFile=strcat('temp_', simString, '_0T_r0.chunk');
[argonTempChunkData] = read_chunk(aTempChunkFile);
% save('argonTempChunkData.mat','argonTempChunkData');
[t,x,y,tempA] = chunkCountConvert(argonTempChunkData, aTempChunkFile, nBinsX, nBinsY);
clear argonTempChunkData
save('argonTempMesh.mat', 't', 'x', 'y', 'tempA','aTempChunkFile');

% iVcmChunkFile=strcat('impurity_vcm_', simString, '_0T_r0.chunk');
% [impurityVcmChunkData] = read_chunk(iVcmChunkFile);
% % save('impurityVcmChunkData.mat', 'impurityVcmChunkData');
% [t,x,y,uI,vI] = chunkConvert(impurityVcmChunkData, iVcmChunkFile, nBinsX, nBinsY);
% clear impurityVcmChunkData
% save('impurityVcmMesh.mat', 't', 'x', 'y', 'uI','vI', 'iVcmChunkFile');
% 
% iCountChunkFile=strcat('impurity_count_', simString, '_0T_r0.chunk');
% [impurityCountChunkData] = read_chunk(iCountChunkFile);
% % save('impurityCountChunkData.mat', 'impurityCountChunkData');
% [t,x,y,countI] = chunkCountConvert(impurityCountChunkData, iCountChunkFile, nBinsX, nBinsY);
% clear impurityCountChunkData
% save('impurityCountMesh.mat', 't', 'x', 'y', 'countI','iCountChunkFile');
% 
% iTempChunkFile=strcat('impurity_temp_', simString, '_0T_r0.chunk');
% [impurityTempChunkData] = read_chunk(iTempChunkFile);
% % save('impurityTempChunkData.mat', 'impurityTempChunkData');
% [t,x,y,tempI] = chunkCountConvert(impurityTempChunkData, iTempChunkFile, nBinsX, nBinsY);
% clear impurityTempChunkData
% save('impurityTempMesh.mat', 't', 'x', 'y', 'tempI','iTempChunkFile');

save(strcat('Mesh_Data_', simString, '_0T.mat'));
end