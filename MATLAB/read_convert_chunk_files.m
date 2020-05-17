function [t,x,y,uI,vI,uA,vA,countI,countA,tempI,tempA] = read_convert_chunk_files()
iVcmChunkFile='impurity_vcm_120W_10D_120F_100S_0T_r0.chunk';
aVcmChunkFile='argon_vcm_120W_10D_120F_100S_0T_r0.chunk';
iCountChunkFile='impurity_count_120W_10D_120F_100S_0T_r0.chunk';
aCountChunkFile='argon_count_120W_10D_120F_100S_0T_r0.chunk';
iTempChunkFile='impurity_temp_120W_10D_120F_100S_0T_r0.chunk';
aTempChunkFile='argon_temp_120W_10D_120F_100S_0T_r0.chunk';

[impurityVcmChunkData] = read_chunk(iVcmChunkFile);
% save('impurityVcmChunkData.mat', 'impurityVcmChunkData');
[t,x,y,uI,vI] = chunkConvert(impurityVcmChunkData, iVcmChunkFile);
clear impurityVcmChunkData
save('impurityVcmMesh.mat', 't', 'x', 'y', 'uI','vI', 'iVcmChunkFile');

[argonVcmChunkData] = read_chunk(aVcmChunkFile);
% save('argonVcmChunkData.mat','argonVcmChunkData');
[t,x,y,uA,vA] = chunkConvert(argonVcmChunkData, aVcmChunkFile);
clear argonVcmChunkData
save('argonVcmMesh.mat', 't', 'x', 'y', 'uA','vA', 'aVcmChunkFile');

[impurityCountChunkData] = read_chunk(iCountChunkFile);
% save('impurityCountChunkData.mat', 'impurityCountChunkData');
[t,x,y,countI] = chunkCountConvert(impurityCountChunkData, iCountChunkFile);
clear impurityCountChunkData
save('impurityCountMesh.mat', 't', 'x', 'y', 'countI','iCountChunkFile');

[argonCountChunkData] = read_chunk(aCountChunkFile);
% save('argonCountChunkData.mat','argonCountChunkData');
[t,x,y,countA] = chunkCountConvert(argonCountChunkData, aCountChunkFile);
clear argonCountChunkData
save('argonCountMesh.mat', 't', 'x', 'y', 'countA','aCountChunkFile');

[impurityTempChunkData] = read_chunk(iTempChunkFile);
% save('impurityTempChunkData.mat', 'impurityTempChunkData');
[t,x,y,tempI] = chunkCountConvert(impurityTempChunkData, iTempChunkFile);
clear impurityTempChunkData
save('impurityTempMesh.mat', 't', 'x', 'y', 'tempI','iTempChunkFile');

[argonTempChunkData] = read_chunk(aTempChunkFile);
% save('argonTempChunkData.mat','argonTempChunkData');
[t,x,y,tempA] = chunkCountConvert(argonTempChunkData, aTempChunkFile);
clear argonTempChunkData
save('argonTempMesh.mat', 't', 'x', 'y', 'tempA','aTempChunkFile');

% save('Chunk_Rectangular_120W_10D_120F_100S_0T.mat');
save('Mesh_Rectangular_120W_10D_120F_100S_0T.mat');

% %%
% vcmChunkFile='vcm_120W_1D_120F_100S_0T_r0.chunk';
% [vcmChunkData] = read_chunk(vcmChunkFile);
% save('vcmChunkData.mat','vcmChunkData');
% countChunkFile='count_120W_1D_120F_100S_0T_r0.chunk';
% [countChunkData] = read_chunk(countChunkFile);
% save('countChunkData.mat','countChunkData');
% tempChunkFile='temp_120W_1D_120F_100S_0T_r0.chunk';
% [tempChunkData] = read_chunk(tempChunkFile);
% save('tempChunkData.mat','tempChunkData');
% save('Chunk_Rectangular.mat');
% 
% [t,x,y,u,v] = chunkConvert(vcmChunkData, vcmChunkFile);
% clear vcmChunkData
% save('vcmMesh.mat', 't', 'x', 'y', 'u','v', 'vcmChunkFile');
% [t,x,y,count] = chunkCountConvert(countChunkData, countChunkFile);
% clear countChunkData
% save('countMesh.mat', 't', 'x', 'y', 'count','countChunkFile');
% [t,x,y,temp] = chunkCountConvert(tempChunkData, tempChunkFile);
% clear tempChunkData
% save('tempMesh.mat', 't', 'x', 'y', 'temp','tempChunkFile');
% 
% save('Mesh_Rectangular_120W_1D_120F_100S_0T.mat');
end