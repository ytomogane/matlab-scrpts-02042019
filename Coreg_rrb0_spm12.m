%-----------------------------------------------------------------------
% Chenfei Ye updated:11/17/2016 
% This function can coregister b0 to T2W, then T2W to MPRAGE (two-step method)
% out = Coreg_rrb0_spm12(dir_ref,dir_b0,dir_T2)
% Input:
% dir_ref: MPRAGE
% dir_b0: b0 image
% dir_T2: T2W image 
% dir_FA: FA image
% dir_trace: Trace image
% Output:
% generate rb0.img in the same folder of b0 image
% ------cye7@jhu.edu
%-----------------------------------------------------------------------
% example:
% dir_ref='C:\Users\susumulab\Desktop\double_interpolation\test\oWIPMPRAGESENSE.nii';
% dir_T2='C:\Users\susumulab\Desktop\double_interpolation\test\Skinny_T2AX_00002.nii';
% dir_b0='C:\Users\susumulab\Desktop\double_interpolation\test\b0.hdr';
% dir_trace='C:\Users\susumulab\Desktop\double_interpolation\test\Trace.hdr';
% dir_FA='C:\Users\susumulab\Desktop\double_interpolation\test\FaMap.hdr'};
function Coreg_rrb0_spm12(dir_ref,dir_b0,dir_T2,dir_FA,dir_trace)


job.ref ={[dir_ref,',1']};
job.source ={[dir_T2,',1']};
job.source2 ={[dir_b0,',1']};
job.other ={[dir_FA,',1'];[dir_trace,',1']};
job.eoptions.cost_fun = 'nmi';
job.eoptions.sep = [4 2];
job.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
job.eoptions.fwhm = [7 7];
job.roptions.interp = 1;
job.roptions.wrap = [0 0 0];
job.roptions.mask = 0;
job.roptions.prefix = 'r';


if ~isfield(job,'other') || isempty(job.other{1}), job.other = {}; end
PO = [job.source(:); job.other(:)];
PO = spm_select('expand',PO);

PO1 = [job.source2(:); job.other(:)];
PO1 = spm_select('expand',PO1);

%-Coregister
%--------------------------------------------------------------------------
    % get the T2 to MPRAGE transform matrix
    x1  = spm_coreg(char(job.ref), char(job.source), job.eoptions);
    M_T2toMPRAGE  = spm_matrix(x1); % Return an affine transformation matrix from 6 parameters
    
    % get the b0 to T2 transform matrix
    x2  = spm_coreg(char(job.source), char(job.source2), job.eoptions);
    M_b0toT2  = spm_matrix(x2);% Return an affine transformation matrix from 6 parameters
    
    MM = zeros(4,4,numel(PO1));
    for j=1:numel(PO1)
        MM(:,:,j) = spm_get_space(PO1{j});
    end
    for j=1:numel(PO1)
        % Link two transform matrix together
        spm_get_space(PO1{j}, (M_T2toMPRAGE*M_b0toT2)\MM(:,:,j));
    end


%-Reslice
%--------------------------------------------------------------------------
if isfield(job,'roptions')
    P            = char(job.ref{:},job.source2{:},job.other{:});
    flags.mask   = job.roptions.mask;
    flags.mean   = 0;
    flags.interp = job.roptions.interp;
    flags.which  = 1;
    flags.wrap   = job.roptions.wrap;
    flags.prefix = job.roptions.prefix;

    spm_reslice(P, flags);
end


end
