
% Prepared by David Simpson (ds@isvr.soton.ac.uk), 12/12/2015
% DISCLAIMER: WHILE WE HAVE ENDEVOURED TO PROVIDE AN ERROR FREE IMPLEMENTATION,
% WE CANNOT GUARANTEE THIS. IF YOU FIND PROBLEMS WITH THE FUNCTION,
% PLEASE LET US KNOW AS SOON AS POSSIBLE SO WE CAN CORRECT THEM AND SUPPORT OUR  SCIENTIFIC COMMUNITY.

% This software id distributed under a GNU General Public License.

% This program is free software: you can redistribute it and/or modify it under the terms of the
% GNU General Public License as published by the Free Software Foundation.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License (http://www.gnu.org/licenses ) for more details.

% Copyright: David Simpson, 2015


%
%   Modified by Will Tackett
%   August 13, 2019
%
%   July 8th, 2021

function []=run_tfa(subname, side, artery)

fileName = strcat(subname, '_', side, '_', artery,'_tsv.tsv');
baseDirName = strcat('/Users/will/Desktop/TFA test'); % CHANGE
inputDirName = strcat(baseDirName, '/inputs');
outputDirName = strcat(baseDirName, '/outputs');

X=importdata(fullfile(inputDirName, fileName)); % get the data from the file

%X=X.data; % get only the numerical values, not the column-header text
t=X(:,1); % first column is the time
p1=X(:,2); % second column is the ABP
v1=X(:,3); % third column is CBFV
fs=1/mean(diff(t)); % find the sampling frequency from the time-base

figure % plot the raw sigals
plot(t,p1,'k',t,v1,'k:');
title(fileName,'interpreter','none');
xlabel ('time (s)');
ylabel('mmHg, cm/s');
legend('ABP','CBFV');
title ('Raw signals');
axis tight

% Round 1 - normalize ABP
params.normalize_ABP = 1;
params.normalize_CBFV = 1;
params.plot_title=sprintf('%s %s %s (normalized for CBFV and ABP)', subname, side, artery);
fields = [ "Mean_abp", "Std_abp", "Mean_cbfv", "Std_cbfv", "Gain_vlf", "Phase_vlf", "Coh2_vlf", "P_abp_vlf", "P_cbf_vlf", "Gain_lf", "Phase_lf", "Coh2_lf", "P_abp_lf", "P_cbf_lf", "Gain_hf", "Phase_hf", "Coh2_hf", "P_abp_hf", "P_cbfv_hf"];
field_indices = [ 1 2 3 4 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21] ;
values = tfa_output(p1,v1,fs,params,field_indices);


% Round 2 - don't normalize ABP
params.plot=1;
params.normalize_ABP = 0;
params.normalize_CBFV = 1;
params.plot_title=sprintf('%s %s %s normalized for CBFV but not ABP', subname, side, artery);
noabp_fields = [ "Gain_vlf_noABP", "Gain_lf_noABP", "Gain_hf_noABP" ];
noabp_field_indices = [ 7 12 17 ];
noabp_values = tfa_output(p1,v1,fs,params,noabp_field_indices);

% Combine columns
col1 = [ fields noabp_fields ];
col2 = [ values noabp_values ];

% remove NANs
ind = ~isnan(col2);
col1 = col1(ind);
col2 = col2(ind);

% create a cell array of variables (cols) and observation (row)
table = [col1; col2];
cell = cellstr(table); % convert to cell array
cell = [ {'Subject'; subname}, cell ]; % add additional header info

% check if output folder is made already. if not, make it.
outputSubjectFolder = strcat(outputDirName, '/', subname);
if ~exist(outputSubjectFolder, 'dir')
   mkdir(outputSubjectFolder)
end

% write out to csv
file_text=subname + "_" + side + "_" + artery + "_results.csv";
writecell(cell, strcat(outputDirName,'/', subname, '/', file_text));

% save all the figures
FolderName = strcat(outputDirName, '/', subname);
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
   FigHandle = FigList(iFig);
   FigName = num2str(get(FigHandle, 'Number'));
   s = strcat(subname, '_', side, '_', artery, '_fig_', FigName);
   set(0, 'CurrentFigure', FigHandle);
   savefig(fullfile(FolderName, [s '.fig']));
end

 
% convert figures to png and delete originals
export_figs(outputSubjectFolder, 'png');
cmd = sprintf("rm '%s/'*.fig", outputSubjectFolder);
system(cmd);

end
