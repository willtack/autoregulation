function tit=make_title(file_name);
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

tit=regexprep(file_name,'_','\\_');