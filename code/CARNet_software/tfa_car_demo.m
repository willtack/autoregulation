
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


clear all
close all

file_name='tfa_sample_data.txt';% 'tfa_sample_data_1.txt';'tfa_sample_data_2.txt';  % select the file to process 
path_name='';
% [file_name,path_name]=uigetfile('C:\Users\dms\Dropbox\Diversity\BOOTSTRAP\bootstrap_files\txt_files\*.txt','Select file');


X=importdata([path_name,file_name]); % get the data from the file

X=X.data; % get only the numerical values, not the column-header text
t=X(:,1); % first column is the time 
p1=X(:,2); % second column is the ABP
v1=X(:,3); % third column is CBFV left
v2=X(:,4); % fourth column is the CBFV right
fs=1/mean(diff(t)); % find the sampling frequency from the time-base

figure % plot the raw sigals
plot(t,p1,'k',t,v1,'k:');
title(file_name,'interpreter','none');
xlabel ('time (s)');
ylabel('mmHg, cm/s');
legend('ABP','CBFV');
title ('Raw signals');
axis tight

params.plot_title=[make_title(file_name), ',left CBFV'];% set the title of plots to the file-name 
%(make_title just makes sure that underscores do not become subscripts in the title). Leave all other parameters as default in tfa_car.m
tfa_out=tfa_car(p1,v1,fs,params); % apply tfa to the left CBFV channel (v1)
tfa_out

params.plot_title=[make_title(file_name), ',right CBFV'];% 
tfa_out=tfa_car(p1,v2,fs,params); % apply tfa to the right CBFV channel (v2)
tfa_out
