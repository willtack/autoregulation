function export_figs(currdir, ext)
%
% The function converts all '.fig' files in the current folder to image
% files whose type is specified by the input var 'ext'.
%
% INPUT
%   ext = char string indicating the type of the output images (type "doc
%         saveas" to obtain a list of possible formats)
%	currdir = directory containing files to be converted ** WT 08/2019
%
% By: L.Luini
% Release(dd/mm/yyyy): 16/10/2007


% list figures in the current folder

basedir=pwd;
cd(currdir)
w=dir('*.fig');

% convert all figures to the specified format
for i=1:length(w)
    filename=char(w(i).name);
    target_name=filename(1:end-4);
    
    % load file as image
    uiopen(filename,1);

    % save in new format
    saveas(gcf,target_name,ext);

    close all;
end

cd(basedir)

end
