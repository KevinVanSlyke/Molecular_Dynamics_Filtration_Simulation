function [t,x,y,uI,vI,uA,vA,countI,countA,tempI,tempA,internalTempI,internalTempA,internalKEI,internalKEA] = read_convert_chunk_files(simString, nBinsX, nBinsY)
% function [t,x,y,uI,vI,uA,vA,countI,countA,tempI,tempA,tempComI,tempComA] = read_convert_chunk_files(simString, nBinsX, nBinsY)
% function [t,x,y,uA,vA,countA,tempA] = read_convert_chunk_files(simString, nBinsX, nBinsY)
% simString = '120W_1D_120F_100S';
% nBinsX = 102;
% nBinsY = 100;

aVcmChunkFile=strcat('argon_vcm_', simString, '.chunk');
% aVcmChunkFile=strcat('vcm_', simString, '_0T_r0.chunk');
[argonVcmChunkData] = read_chunk(aVcmChunkFile);
% save('argonVcmChunkData.mat','argonVcmChunkData');
[t,x,y,uA,vA] = chunkConvert(argonVcmChunkData, aVcmChunkFile, nBinsX, nBinsY);
clear argonVcmChunkData
save('argonVcmMesh.mat', 't', 'x', 'y', 'uA','vA', 'aVcmChunkFile');

aCountChunkFile=strcat('argon_count_', simString, '.chunk');
% aCountChunkFile=strcat('count_', simString, '_0T_r0.chunk');
[argonCountChunkData] = read_chunk(aCountChunkFile);
% save('argonCountChunkData.mat','argonCountChunkData');
[t,x,y,countA] = chunkCountConvert(argonCountChunkData, aCountChunkFile, nBinsX, nBinsY);
clear argonCountChunkData
save('argonCountMesh.mat', 't', 'x', 'y', 'countA','aCountChunkFile');

aTempChunkFile=strcat('argon_temp_', simString, '.chunk');
% aTempChunkFile=strcat('temp_', simString, '_0T_r0.chunk');
[argonTempChunkData] = read_chunk(aTempChunkFile);
% save('argonTempChunkData.mat','argonTempChunkData');
[t,x,y,tempA] = chunkCountConvert(argonTempChunkData, aTempChunkFile, nBinsX, nBinsY);
clear argonTempChunkData
save('argonTempMesh.mat', 't', 'x', 'y', 'tempA','aTempChunkFile');

aInternalTempChunkFile=strcat('argon_internalTemp_', simString, '.chunk');
% aTempChunkComFile=strcat('tempCom_', simString, '_0T_r0.chunk');
[argonInternalTempChunkData] = read_chunk(aInternalTempChunkFile);
% save('argonInternalTempChunkData.mat','argonComTempChunkData');
[t,x,y,internalTempA] = chunkCountConvert(argonInternalTempChunkData, aInternalTempChunkFile, nBinsX, nBinsY);
clear argonInternalTempChunkData
save('argonInternalTempMesh.mat', 't', 'x', 'y', 'internalTempA','aInternalTempChunkFile');

iVcmChunkFile=strcat('impurity_vcm_', simString, '.chunk');
[impurityVcmChunkData] = read_chunk(iVcmChunkFile);
% save('impurityVcmChunkData.mat', 'impurityVcmChunkData');
[t,x,y,uI,vI] = chunkConvert(impurityVcmChunkData, iVcmChunkFile, nBinsX, nBinsY);
clear impurityVcmChunkData
save('impurityVcmMesh.mat', 't', 'x', 'y', 'uI','vI', 'iVcmChunkFile');

iCountChunkFile=strcat('impurity_count_', simString, '.chunk');
[impurityCountChunkData] = read_chunk(iCountChunkFile);
% save('impurityCountChunkData.mat', 'impurityCountChunkData');
[t,x,y,countI] = chunkCountConvert(impurityCountChunkData, iCountChunkFile, nBinsX, nBinsY);
clear impurityCountChunkData
save('impurityCountMesh.mat', 't', 'x', 'y', 'countI','iCountChunkFile');

iTempChunkFile=strcat('impurity_temp_', simString, '.chunk');
[impurityTempChunkData] = read_chunk(iTempChunkFile);
% save('impurityTempChunkData.mat', 'impurityTempChunkData');
[t,x,y,tempI] = chunkCountConvert(impurityTempChunkData, iTempChunkFile, nBinsX, nBinsY);
clear impurityTempChunkData
save('impurityTempMesh.mat', 't', 'x', 'y', 'tempI','iTempChunkFile');

iInternalTempChunkFile=strcat('impurity_internalTemp_', simString, '.chunk');
[impurityInternalTempChunkData] = read_chunk(iInternalTempChunkFile);
% save('impurityInternalTempChunkData.mat', 'impurityInternalTempChunkData');
[t,x,y,internalTempI] = chunkCountConvert(impurityInternalTempChunkData, iInternalTempChunkFile, nBinsX, nBinsY);
clear impurityInternalTempChunkData
save('impurityInternalTempMesh.mat', 't', 'x', 'y', 'internalTempI','iInternalTempChunkFile');


%%Extra local analysis, not calculated in CCR runs
%%-------------------------------------------------%%
aInternalKEChunkFile=strcat('argon_internalKE_', simString, '.chunk');
% aInternalKEChunkFile=strcat('internalKE_', simString, '_0T_r0.chunk');
[argonInternalKEChunkData] = read_chunk(aInternalKEChunkFile);
% save('argonInternalKEChunkData.mat','argonInternalKEChunkData');
[t,x,y,internalKEA] = chunkCountConvert(argonInternalKEChunkData, aInternalKEChunkFile, nBinsX, nBinsY);
clear argonInternalKEChunkData
save('argonInternalKEMesh.mat', 't', 'x', 'y', 'internalKEA','aInternalKEChunkFile');

iInternalKEChunkFile=strcat('impurity_internalKE_', simString, '.chunk');
[impurityInternalKEChunkData] = read_chunk(iInternalKEChunkFile);
% save('impurityInternalKEChunkData.mat', 'impurityInternalKEChunkData');
[t,x,y,internalKEI] = chunkCountConvert(impurityInternalKEChunkData, iInternalKEChunkFile, nBinsX, nBinsY);
clear impurityInternalKEChunkData
save('impurityInternalKEMesh.mat', 't', 'x', 'y', 'internalKEI','iInternalKEChunkFile');
%%-------------------------------------------------%%

% save(strcat('Mesh_Data_', simString, '_0T.mat'));
% save(strcat('Shifted_Mesh_Data_', simString, '.mat'));
save(strcat('Mesh_Data_', simString, '.mat'));

end