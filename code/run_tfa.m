
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
%

function []=run_tfa(subname, artery, side)

file_name = strcat(subname, '_', side, '_', artery,'_tsv.tsv');
SubdirName = strcat('/data/jux/detre_group/tfa/inputs/');

X=importdata([SubdirName,file_name]); % get the data from the file

%X=X.data; % get only the numerical values, not the column-header text
t=X(:,1); % first column is the time 
p1=X(:,2); % second column is the ABP
v1=X(:,3); % third column is CBFV
fs=1/mean(diff(t)); % find the sampling frequency from the time-base

figure % plot the raw sigals
plot(t,p1,'k',t,v1,'k:');
title(file_name,'interpreter','none');
xlabel ('time (s)');
ylabel('mmHg, cm/s');
legend('ABP','CBFV');
title ('Raw signals');
axis tight

params.plot_title=[make_title(file_name), ' CBFV'];% set the title of plots to the file-name 
tfa_out=tfa_car(p1,v1,fs,params); % appy tfa
tfa_cell = struct2cell(tfa_out);
tfa_cell(6:11,:) = []; % remove the doubles
tfa_mat = cell2mat(tfa_cell);

% list the fields we want and their indices
fields = [ "Mean_abp", "Std_abp", "Mean_cbfv", "Std_cbfv", "Gain_vlf", "Phase_vlf", "Coh2_vlf", "Gain_lf", "Phase_lf", "Coh2_lf", "Gain_hf", "Phase_hf", "Coh2_hf"];
field_indices = [ 1 2 3 4 7 8 9 12 13 14 17 18 19 ] ;

col1 = fields';
col2 = zeros(13,1);
for i = 1:length(field_indices)
    j = field_indices(i);
    value = tfa_mat(j);
    col2(i) = value;
end

% remove NANs
ind = ~isnan(col2);
col2 = col2(ind);
col1 = col1(ind);

% create a string array of keys: values
table = [col1,col2];

cell = cellstr(table); % convert to cell array
file_text=subname + "_" + side + "_" + artery + "_results.txt";
file = fopen(strcat('/data/jux/detre_group/tfa/outputs/', subname, '/', file_text),'w');
formatSpec = '%s\t%s \n'; % format of a given line is: string [tab] string
[nrows, ncols] = size(cell);

%loop through rows of cell array and print the row to a line in the file
for row = 1:nrows
    fprintf(file, formatSpec, cell{row,:});
end
fclose(file);


%Save all the figures
% FolderName = strcat('/data/jux/detre_group/tfa/outputs/', subname);   
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% for iFig = 1:length(FigList)
%   FigHandle = FigList(iFig);
%   FigName   = num2str(get(FigHandle, 'Number'));
%   s = strcat(subname, '_', side, '_', artery, '_fig_', FigName);
%   set(0, 'CurrentFigure', FigHandle);
%   savefig(fullfile(FolderName, [s '.fig']));
% end


end
