%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------------------------------%
%
% Machine Perception and Cognitive Robotics Laboratory
%
%     Center for Complex Systems and Brain Sciences
%
%              Florida Atlantic University
%
%------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------------------------------%
function MPCR_robohand_load_data_with_filt08_40

clear all; close all; clc;

cd('~/hdd/Insync/MPCR_Data_Analysis/S001E01R01-03');
%cd('/Users/williamedwardhahn/Desktop/robohand')

load('raw_Left.mat', 'EEG')

% who
% size(EEG.data)

D=EEG.data;
D = double(D);

% Design filter: (bandpass)
sr = 500; % sampling rate
niq = sr/2; % niquist limit (sample rate/ 2)
low = 8; % lower limit (Hz)
high = 40; % upper limit (Hz)
w1 = low/niq; % normalized freq limits
w2 = high/niq;
order = 4; % filter order
bord = order/2; % bandpass order is 2N

[b,a] = butter(bord, [w1 w2]); % butterworth filter design


% Take the first second only:
% D=D(:,1:750,:);
% D1=[];


D2=[];


for i = 1:size(D,3)
    
    D1=squeeze(D(:,:,i));
    size(D1)
    
    % Apply filter
    D1 = filtfilt(b,a,D1')';
    % Whiten the signals (necessary with filter?)
    D1=whiten_patches(D1')';
    

    
    
%     imagesc(D1);
        
    D2=[D2 D1(:)];
%     size(D2)  
    
end

imagesc(D2)
Data=D2;
save('Robohand_EEG_Data_Left_filt08-40.mat','Data')


% ================================================================


clear all
close all
clc
cd('~/hdd/Insync/MPCR_Data_Analysis/S001E01R01-03');
%cd('/Users/williamedwardhahn/Desktop/robohand')


load('raw_Right.mat', 'EEG')

% who
% size(EEG.data)

D=EEG.data;
D = double(D);

% Design filter: (bandpass)
sr = 500; % sampling rate
niq = sr/2; % niquist limit (sample rate/ 2)
low = 8; % lower limit (Hz)
high = 40; % upper limit (Hz)
w1 = low/niq; % normalized freq limits
w2 = high/niq;
order = 4; % filter order
bord = order/2; % bandpass order is 2N

[b,a] = butter(bord, [w1 w2]); % butterworth filter design

% Take the first second only:
%  D=D(:,1:500,:);


% D1=[];


D2=[];


for i = 1:size(D,3)
    
    D1=squeeze(D(:,:,i));
    size(D1)
    
   
        % Apply filter
    D1 = filtfilt(b,a,D1')';
    D1=whiten_patches(D1')';

    
    %     imagesc(D1);

        
    D2=[D2 D1(:)];
%     size(D2)
      
end

imagesc(D2)
Data=D2;
save('Robohand_EEG_Data_Right_filt08-40.mat','Data')






% 
% for i = 1:size(D,3)
%     
%    
% for j=1:size(D,2)
%    
%     
%     imagesc(D(:,j,i))
%     pause(0.1)
%     [i,j]
%     
%     
%     
% end
%     
%     
%     
%     
%     
% end






% D1=[];
% 
% 
% for i = 1:size(D,3)
%    
%     D2=squeeze(D(:,:,i));
% 
%     D2=whiten_patches(D2')';
%    
%     D1=[D1; D2];
%     
%     size(D1)
%     
%     
% end
% 
% 
% imagesc(D1')
% colormap gray
% 
% 
% 





end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X=whiten_patches(X)

% Whiten Images in Matlab
% http://xcorr.net/2013/04/30/whiten-images-in-matlab/

X = bsxfun(@minus,X,mean(X)); %remove mean
fX = fft(fft(X,[],2),[],3); %fourier transform of the images
spectr = sqrt(mean(abs(fX).^2)); %Mean spectrum
X = ifft(ifft(bsxfun(@times,fX,1./spectr),[],2),[],3); %whitened X


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

    