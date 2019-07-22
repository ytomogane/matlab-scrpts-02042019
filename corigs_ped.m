%-----------------------------------------------------------------------
% Date: 02/14/2017
% This script is for coregistrate T2/Gd/FLAIR/DTI to mprage
% make sure all the image is axial and well-aligend before running
% make sure you have installed SPM12 on your computer
% Note that you should open coregistrated DTI images with nifti format
% ------cye7@jhu.edu
clc
clear
% set the mainfolder
t1path='H:\pediatric additional cases 03032019\7F366717_1';
t2path='H:\pediatric additional cases 03032019\7F366717_1\img_files';
flairpath='H:\pediatric additional cases 03032019\7F366717_1\img_files';
Gdpath='H:\pediatric additional cases 03032019\7F366717_1\img_files';
DTIpath='H:\pediatric additional cases 03032019\7F366717_1\Results';
% get the all subfolder path of mprage
subpath_t1=strsplit(genpath(t1path),pathsep); 
subpath_t1=subpath_t1';
%% get the ID of each subject
[pre,mid,~]=cellfun(@(x) fileparts(x), subpath_t1,'UniformOutput',false);
a=cellfun(@(x) strfind(x,'yr'),mid,'UniformOutput',false);
idx=cellfun(@isempty, a);
%mid(idx)=[];
%pre(idx)=[];
preage2=cellfun(@(x) strsplit(x, filesep), pre,'UniformOutput',false);
mid_ID=cellfun(@(x) strsplit(x, '_'), mid,'UniformOutput',false);

for i = 1:length(mid_ID) % for each subject
    ID_mat(i)=mid_ID{i}(1);
    allimg=ls([char(pre(i)),filesep,char(mid(i)),'\output\target1',filesep,'*.img']); % find mprage image
    t1img_path=[char(pre(i)),filesep,char(mid(i)),'\output\target1',filesep,strtrim(allimg(1,:))];  % assign mprage image path
    [suf,~]=strsplit(strtrim(allimg(1,:)),'.');
    parimg=ls([char(pre(i)),filesep,char(mid(i)),'\output\target1',filesep,'*M2.img']); % find parcellation map
    parimg_path=[char(pre(i)),filesep,char(mid(i)),'\output\target1',filesep,strtrim(parimg(1,:))]; % assign parcellation map path
    inhomo_cor(t1img_path); % inhomogeneity correction
    t1img_path_inho=[char(pre(i)),filesep,char(mid(i)),'\output\target1',filesep,'m',char(suf(1)),'.nii']; % assign corrected mprage image path
    
    
    
 
    t2img=ls([t2path,filesep,char(ID_mat(i)),'*T2.img']); % find t2 image
    t2img_path=[t2path,filesep,t2img];% assign t2 image path
    inhomo_cor(t2img_path); % inhomogeneity correction
    [suf,~]=strsplit(t2img,'.');  
    t2img_path_inho=[t2path,filesep,'m',char(suf(1)),'.nii'];% assign corrected t2 image path
    coregis_spm12({t1img_path_inho},{t2img_path_inho},{t2img_path_inho}); % coregister using SPM12
    

    flairimg=ls([flairpath,filesep,char(ID_mat(i)),'*FLAIR.img']);  % find flair image
    flairimg_path=[flairpath,filesep,flairimg];% assign flair image path
    inhomo_cor(flairimg_path); % inhomogeneity correction
    [suf,~]=strsplit(flairimg,'.');
    flairimg_path_inho=[flairpath,filesep,'m',char(suf(1)),'.nii'];% assign corrected flair image path
    coregis_spm12({t1img_path_inho},{flairimg_path_inho},{flairimg_path_inho}); % coregister using SPM12
    

    Gdimg=ls([Gdpath,filesep,char(ID_mat(i)),'*Gd.img']); % find Gd image
    Gdimg_path=[Gdpath,filesep,Gdimg]; % assign Gd image path
    inhomo_cor(Gdimg_path); % inhomogeneity correction
    [suf,~]=strsplit(Gdimg,'.');
    Gdimg_path_inho=[Gdpath,filesep,'m',char(suf(1)),'.nii']; % assign corrected Gd image path
    coregis_spm12({t1img_path_inho},{Gdimg_path_inho},{Gdimg_path_inho}); % coregister using SPM12
   
    
    %% DTI coregistration
     b0_path=[DTIpath,filesep,char(preage2(i)),filesep,char(mid(i)),filesep,'QcDtiMap\','RefB0.img']; % assign b0 image path
     inhomo_cor(b0_path); % inhomogeneity correction
     mb0_path=[DTIpath,filesep,char(preage2(i)),filesep,char(mid(i)),filesep,'QcDtiMap\','mRefB0.nii'];% assign corrected b0 image path
     FA_path=[DTIpath,filesep,char(preage2(i)),filesep,char(mid(i)),filesep,'QcDtiMap\','FaMap.img'];% assign Fa image path
     trace_path=[DTIpath,filesep,char(preage2(i)),filesep,char(mid(i)),filesep,'QcDtiMap\','Trace.img'];% assign Trace image path
     Coreg_rrb0_spm12(t1img_path_inho,mb0_path,t2img_path_inho,FA_path,trace_path);%
     %coregister using SPM12 (first b0 to t2, than t2 to mprage, then apply transformation matrix to Fa and Trace)



end


