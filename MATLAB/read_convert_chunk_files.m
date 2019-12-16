function [] = read_convert_chunk_files()
iVcmChunkFile='impurity_vcm_120W_5D_120F_100S_0T_r0.chunk';
aVcmChunkFile='argon_vcm_120W_5D_120F_100S_0T_r0.chunk';
iCountChunkFile='impurity_count_120W_5D_120F_100S_0T_r0.chunk';
aCountChunkFile='argon_count_120W_5D_120F_100S_0T_r0.chunk';
iTempChunkFile='impurity_temp_120W_5D_120F_100S_0T_r0.chunk';
aTempChunkFile='argon_temp_120W_5D_120F_100S_0T_r0.chunk';

[impurityVcmChunkData] = read_chunk(iVcmChunkFile);
[t,x,y,uI,vI] = chunkConvert(impurityVcmChunkData, iVcmChunkFile);
save('impurityVcmChunkData.mat', 'impurityVcmChunkData');
clear impurityVcmChunkData
save('impurityVcmMesh.mat', 't', 'x', 'y', 'uI','vI', 'iVcmChunkFile');

[argonVcmChunkData] = read_chunk(aVcmChunkFile);
[t,x,y,uA,vA] = chunkConvert(argonVcmChunkData, aVcmChunkFile);
save('argonVcmChunkData.mat','argonVcmChunkData');
clear argonVcmChunkData
save('argonVcmMesh.mat', 't', 'x', 'y', 'uA','vA', 'aVcmChunkFile');

[impurityCountChunkData] = read_chunk(iCountChunkFile);
[t,x,y,countI] = chunkCountConvert(impurityCountChunkData, iCountChunkFile);
save('impurityCountChunkData.mat', 'impurityCountChunkData');
clear impurityCountChunkData
save('impurityCountMesh.mat', 't', 'x', 'y', 'countI','iCountChunkFile');

[argonCountChunkData] = read_chunk(aCountChunkFile);
[t,x,y,countA] = chunkCountConvert(argonCountChunkData, aCountChunkFile);
save('argonCountChunkData.mat','argonCountChunkData');
clear argonCountChunkData
save('argonCountMesh.mat', 't', 'x', 'y', 'countA','aCountChunkFile');

[impurityTempChunkData] = read_chunk(iTempChunkFile);
[t,x,y,tempI] = chunkCountConvert(impurityTempChunkData, iTempChunkFile);
save('impurityTempChunkData.mat', 'impurityTempChunkData');
clear impurityTempChunkData
save('impurityTempMesh.mat', 't', 'x', 'y', 'tempI','iTempChunkFile');

[argonTempChunkData] = read_chunk(aTempChunkFile);
[t,x,y,tempA] = chunkCountConvert(argonTempChunkData, aTempChunkFile);
save('argonTempChunkData.mat','argonTempChunkData');
clear argonTempChunkData
save('argonTempMesh.mat', 't', 'x', 'y', 'tempA','aTempChunkFile');

save('Mesh_Rectangular_120W_5D_120F_100S_0T.mat');
end