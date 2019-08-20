function [H,C,f,Pxx,Pxy,Pyy,no_windows]=tfa1(x,y,wind,overlap,M_smooth,fs,Nfft);
% Transfer function analysis using the Welch method
% 
% [H,C,f,Pxx,Pxy,Pyy,no_windows]=tfa(x,y,T,overlap,fs,Nfft_opt);
% where x is the input signal, y the output signal, 
% M the window-length (in seconds, using a boxcar/rectangular window); if may be vector, and then will
% used as the window (e.g. hanning(256)), 
% overlap is the overlap (as a fraction of 1), 
% M_smooth - length of the triangular smoothing function. Must be odd
% number. 
% Nfft=0.. make the fft as long as the window (default value), else it defines the length of the fft (> window length)
% 
% H is the complex frequency response (transfer function)
% C is the coherence
% f is the corresponding frequency vector. 
% Pxx, Pxy, Pyy are the auto and cross-spectral densities. 
% no_windows is the number of windows used. 

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

if length(wind)==1
    M=wind;
    wind=boxcar(wind);
else
    M=length(wind);
end
    

if nargin<7 
    Nfft=0;
end
if Nfft==0
    Nfft=M;
end

[C,f,no_windows]=welch1(x,y,wind,overlap,fs);
Pxx=C.Pxx;
Pyy=C.Pyy;
Pxy=C.Pxy;

% [Pxy,f]=cpsd(y,x,wind,round(M*overlap),Nfft,fs,'twosided');
% [Pxx,f]=cpsd(x,x,wind,round(M*overlap),Nfft,fs,'twosided');
% [Pyy,f]=cpsd(y,y,wind,round(M*overlap),Nfft,fs,'twosided');

if M_smooth>1;
h=ones(floor((M_smooth+1)/2),1);
h=h/sum(h);
Pxx1=Pxx;
Pxx1(1)=Pxx(2);
Pyy1=Pyy;
Pyy1(1)=Pyy(2);
% Pxy1=abs(Pxy);
% Pxy1abs(1)=abs(Pxy(2));
Pxy1=(Pxy);
Pxy1(1)=Pxy(2);

Pxx1=filtfilt(h,1,Pxx1);
Pyy1=filtfilt(h,1,Pyy1);
Pxy1=filtfilt(h,1,Pxy1);

Pxx1(1)=Pxx(1);
Pxx=Pxx1;
Pyy1(1)=Pyy(1);
Pyy=Pyy1;
% Pxy1=Pxy1abs.*Pxy./abs(Pxy);
% Pxy1(1)=Pxy(1);
% Pxy1=Pxy1abs.*Pxy./abs(Pxy);
Pxy1(1)=Pxy(1);

% keyboard
Pxy=Pxy1;

end

% keyboard

H=Pxy./Pxx;
C=Pxy./(abs(Pxx.*Pyy).^0.5);

% no_windows=0;
% w_end=M;
% while w_end<=length(x);
%     no_windows=no_windows+1;
%     w_end=w_end+round(M-M*overlap);
% end

