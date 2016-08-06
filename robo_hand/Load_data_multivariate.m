%%

%=================================================================
%
% Load EEG data in a multivariate/multichannel manner. 
% Thomas Colestock
% Florida Atlantic University
% BioRobotics Laboratory
% - Department of Ocean and Mechanical Engineering
% Machine Perception and Cognitive Robotics Laboratory
% - Center for Complex Systems and Brain Sciences
% 
% April 18, 2016
% ver 0.01
%
%==================================================================


%% 

clear all; close all; clc; 

cd('~/hdd/Insync/MPCR_Data_Analysis/S001E01R01-03');
load('raw_Rest.mat','EEG');

D=EEG.data;

D2=zeros(size(D,2),size(D,3),size(D,1));

for i = 1:size(D,3)
    
    D1=squeeze(D(:,:,i));
    %     size(D1)
    
    % Whiten Images in Matlab
    % http://xcorr.net/2013/04/30/whiten-images-in-matlab/
    X = D1';
    X = bsxfun(@minus,X,mean(X)); %remove mean
    fX = fft(fft(X,[],2),[],3); %fourier transform of the images
    spectr = sqrt(mean(abs(fX).^2)); %Mean spectrum
    X = ifft(ifft(bsxfun(@times,fX,1./spectr),[],2),[],3); %whitened X    
%     D1=whiten_patches(D1')';
    D1 = X;
    
    for j = 1:size(D1,2)
    D2(:,i,j) = D1(:,j);
    end
            
end

Data=D2;
save('White_Rest_Multivariate.mat','Data');