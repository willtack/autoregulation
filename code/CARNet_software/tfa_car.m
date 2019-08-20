

function tfa_out=tfa_car(ABP,CBFV,fs,params);

% function tfa_out=tfa_car(ABP,CBFV,fs,params)
% Transfer function analysis for cerebral autoregulation
% ABP and CBFV are in mmHg and cm/s, respecitvely, fs is the sampling
% frequency and params holds parameters for tfa analysis. Params is
% optional, and if not given will automatically use the default settings
% as given in the White Paper (2015).

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


% default parameters taken from Consensus Paper
default_params.vlf=[0.02,0.07];
default_params.lf=[0.07,0.2];
default_params.hf=[0.2,0.5];
default_params.detrend=0;
default_params.spectral_smoothing=3; % triangular filter of this length
default_params.coherence2_thresholds=[3:15;0.51,0.40,0.34,0.29,0.25,0.22,0.20,0.18,0.17,0.15,0.14,0.13,0.12]';% from consensus paper
; % the first column refers to the number of 50% overlapping hanning windows, with 3-point spectral smoothing; only coherence values above this are used in calculating the mean gain and phase
default_params.apply_coherence2_threshold=1;
default_params.remove_negative_phase=1;
default_params.remove_negative_phase_f_cutoff=0.1;
default_params.normalize_ABP=0;
default_params.normalize_CBFV=0;
default_params.window_type='hanning';% alternatives 'Boxcar'
default_params.window_length=102.4;% in s
default_params.overlap=59.99;% overlap in % (when overlap_adjust is on, this is adjusted down). Use 59.99% rather than 60 so with with data corresponding to 5 windows with 50% overlap, 5 windows are chosen
default_params.overlap_adjust=1;
default_params.plot=1;
default_params.plot_f_range=[0,0.5];
default_params.plot_title='';

% coordinates for the plots in relative screen units
subplot1=[.15,0.65,0.75,0.22];
subplot2=subplot1+[0,-0.25,0,0];
subplot3=subplot2+[0,-0.25,0,0];

% set all missing parameters in to the default values
if nargin<4
    params=default_params;
end
if ~isfield(params,'vlf');
    params.vlf=default_params.vlf;
end
if ~isfield(params,'lf');
    params.lf=default_params.lf;
end
if ~isfield(params,'hf');
    params.hf=default_params.hf;
end
if ~isfield(params,'detrend');
    params.detrend=default_params.detrend;
end
if ~isfield(params,'spectral_smoothing');
    params.spectral_smoothing=default_params.spectral_smoothing;
end
if ~isfield(params,'coherence2_thresholds');
    params.coherence2_thresholds=default_params.coherence2_thresholds;
end
if ~isfield(params,'apply_coherence2_threshold');
    params.apply_coherence2_threshold=default_params.apply_coherence2_threshold;
end
if ~isfield(params,'remove_negative_phase');
    params.remove_negative_phase=default_params.remove_negative_phase;
end
if ~isfield(params,'remove_negative_phase_f_cutoff');
    params.remove_negative_phase_f_cutoff=default_params.remove_negative_phase_f_cutoff;
end
if ~isfield(params,'normalize_ABP');
    params.normalize_ABP=default_params.normalize_ABP;
end
if ~isfield(params,'normalize_CBFV');
    params.normalize_CBFV=default_params.normalize_CBFV;
end
if ~isfield(params,'window_type');
    params.window_type=default_params.window_type;
end
if ~isfield(params,'window_length');
    params.window_length=default_params.window_length;
end
if ~isfield(params,'overlap');
    params.overlap=default_params.overlap;
end
if ~isfield(params,'overlap_adjust');
    params.overlap_adjust=default_params.overlap_adjust;
end
if ~isfield(params,'default_params.plot');
    params.plot=default_params.plot;
end
if ~isfield(params,'plot_f_range');
    params.plot_f_range=default_params.plot_f_range;
end
if ~isfield(params,'plot_title');
    params.plot_title=default_params.plot_title;
end

tfa_out.Mean_abp=mean(ABP);
tfa_out.Std_abp=std(ABP);

if params.detrend
    ABP=detrend(ABP);
else
    ABP=ABP-mean(ABP);
end
if params.normalize_ABP==1
    ABP=(ABP/tfa_out.Mean_abp)*100;
end

tfa_out.Mean_cbfv=mean(CBFV);
tfa_out.Std_cbfv=std(CBFV);
if params.detrend
    CBFV=detrend(CBFV);
else
    CBFV=CBFV-mean(CBFV);
end
if params.normalize_CBFV==1
    CBFV=(CBFV/tfa_out.Mean_cbfv)*100;
end

window_length=round(params.window_length*fs);
if strcmp(upper(params.window_type),'HANNING');
    wind=hanning_car(window_length);
end
if strcmp(upper(params.window_type),'BOXCAR');
    wind=boxcar(window_length);
end
if params.overlap_adjust==1
    L=floor((length(ABP)-window_length)/(window_length*(1-params.overlap/100)))+1;
    if L>1
        shift=floor((length(ABP)-window_length)/(L-1));
        overlap=(window_length-shift)/window_length*100;
        tfa_out.overlap=overlap;
    end
else
    overlap=params.overlap;
end
overlap=overlap/100;   
M_smooth=params.spectral_smoothing;
N_fft=window_length;
% keyboard


[H,C,f,Pxx,Pxy,Pyy,no_windows]=tfa1(ABP,CBFV,wind,overlap,M_smooth,fs,N_fft);

% keyboard



tfa_out.H=H;
tfa_out.C=C;
tfa_out.f=f;
tfa_out.Pxx=Pxx;
tfa_out.Pyy=Pyy;
tfa_out.Pxy=Pxy;
tfa_out.No_windows=no_windows;

% find the mean values in each frequency band
i=find(params.coherence2_thresholds(:,1)==no_windows);
if isempty(i)
disp('Warning:no coherence threshold defined for the number of windows obtained - all frequencies will be included');
coherence2_threshold=0;
else
    coherence2_threshold=params.coherence2_thresholds(i,2);
end

G=H; % save for plotting below
if params.apply_coherence2_threshold
i=find(abs(C).^2 < coherence2_threshold); % exclude low coherence
H(i)=nan;
% keyboard
end
P=angle(H);
if params.remove_negative_phase; % exclude negative phase below cut-off frequency
    n=find(f<params.remove_negative_phase_f_cutoff);
    k=find(P(n)<0);
    if ~isempty(k);
        P(n(k))=nan;
    end
end;
    
i=find(f>=params.vlf(1) & f<params.vlf(2));
tfa_out.Gain_vlf=nanmean(abs(H(i)));
tfa_out.Phase_vlf=nanmean(P(i))/(2*pi)*360;
tfa_out.Coh2_vlf=nanmean(abs(C(i)).^2);
tfa_out.P_abp_vlf=2*sum(Pxx(i))*f(2);
tfa_out.P_cbfv_vlf=2*sum(Pyy(i))*f(2);


i=find(f>=params.lf(1) & f<params.lf(2));
tfa_out.Gain_lf=nanmean(abs(H(i)));
tfa_out.Phase_lf=nanmean(P(i))/(2*pi)*360;
tfa_out.Coh2_lf=nanmean(abs(C(i)).^2);
tfa_out.P_abp_lf=2*sum(Pxx(i))*f(2);
tfa_out.P_cbfv_lf=2*sum(Pyy(i))*f(2);

i=find(f>=params.hf(1) & f<params.hf(2));
tfa_out.Gain_hf=nanmean(abs(H(i)));
dummy=angle(H(i));
tfa_out.Phase_hf=nanmean(P(i))/(2*pi)*360;
tfa_out.Coh2_hf=nanmean(abs(C(i)).^2);
tfa_out.P_abp_hf=2*sum(Pxx(i))*f(2);
tfa_out.P_cbfv_hf=2*sum(Pyy(i))*f(2);

if params.normalize_CBFV
    tfa_out.Gain_vlf_norm=tfa_out.Gain_vlf;
    tfa_out.Gain_lf_norm=tfa_out.Gain_lf;
    tfa_out.Gain_hf_norm=tfa_out.Gain_hf;
    tfa_out.Gain_vlf_not_norm=tfa_out.Gain_vlf*tfa_out.Mean_cbfv/100;
    tfa_out.Gain_lf_not_norm=tfa_out.Gain_lf*tfa_out.Mean_cbfv/100;
    tfa_out.Gain_hf_not_norm=tfa_out.Gain_hf*tfa_out.Mean_cbfv/100;
else
    tfa_out.Gain_vlf_not_norm=tfa_out.Gain_vlf;
    tfa_out.Gain_lf_not_norm=tfa_out.Gain_lf;
    tfa_out.Gain_hf_not_norm=tfa_out.Gain_hf;
    tfa_out.Gain_vlf_norm=tfa_out.Gain_vlf/tfa_out.Mean_cbfv*100;
    tfa_out.Gain_lf_norm=tfa_out.Gain_lf/tfa_out.Mean_cbfv*100;
    tfa_out.Gain_hf_norm=tfa_out.Gain_hf/tfa_out.Mean_cbfv*100;
end

    

if params.plot
    fig=figure;
    % set(fig,'Position',pos3);
    t=[0:length(ABP)-1]/fs;
    plot(t,ABP,t,CBFV,'r:');
    title(params.plot_title);
    xlabel('time (s)');
    legend('ABP','CBFV');
    axis tight
    fig=figure;
    ax(1)=subplot('position',subplot1);%(3,1,1);
    plot(f,abs(G));
    title(params.plot_title);
    ylabel('Gain');
    
    hold on
    plot(params.vlf,[1,1]*tfa_out.Gain_vlf,':r');
    plot(params.lf,[1,1]*tfa_out.Gain_lf,':r');
    plot(params.hf,[1,1]*tfa_out.Gain_hf,':r');
    set(ax(1),'XTickLabel','');
    axis tight
    ax(2)=subplot('position',subplot2);%(3,1,2);
    set(ax(2),'XTickLabel','');
    plot(f,angle(G)/(2*pi)*360);
    hold on
    ylabel('Phase (deg)');
    plot(params.vlf,[1,1]*tfa_out.Phase_vlf,':r');
    plot(params.lf,[1,1]*tfa_out.Phase_lf,':r');
    plot(params.hf,[1,1]*tfa_out.Phase_hf,':r');
    set(ax(2),'XTickLabel','');
    axis tight
    
    ax(3)=subplot('position',subplot3);%(3,1,3);
    plot(f,abs(C).^2);
    ylabel('|Coh|^2');
    hold on
    plot(params.vlf,[1,1]*tfa_out.Coh2_vlf,':r');
    plot(params.lf,[1,1]*tfa_out.Coh2_lf,':r');
    plot(params.hf,[1,1]*tfa_out.Coh2_hf,':r');
    plot(params.plot_f_range,coherence2_threshold*ones(1,2),'--k');
    axis tight
    
    xlabel('frequency(Hz)');
    linkaxes(ax,'x');
    xlim(params.plot_f_range);
    
end

