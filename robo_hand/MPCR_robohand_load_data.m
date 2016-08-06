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
function MPCR_robohand_load_data



clear all
close all
clc

cd('~/hdd/Insync/MPCR_Data_Analysis/S001E01R01-03');
%cd('/Users/williamedwardhahn/Desktop/robohand')

load('raw_Left.mat')


who

size(EEG.data)

D=EEG.data;
D = D(1:32,:,:);
% Take the first second only:
% D=D(:,1:750,:);


% D1=[];


D2=[];


for i = 1:size(D,3)
    
    D1=squeeze(D(:,:,i));
    size(D1)

    D1=whiten_patches(D1')';
    
%     imagesc(D1);
    
    
    D2=[D2 D1(:)];
    
    size(D2)
  
    
end


imagesc(D2)

Data=D2;

save('Robohand_EEG_Data_Left.mat','Data')





clear all
close all
clc
cd('~/hdd/Insync/MPCR_Data_Analysis/S001E01R01-03');
%cd('/Users/williamedwardhahn/Desktop/robohand')


load('raw_Rest.mat')


who

size(EEG.data)

D=EEG.data;
D = D(1:32,:,:);
% Take the first second only:
% D=D(:,1:750,:);


% D1=[];


D2=[];


for i = 1:size(D,3)
    
    D1=squeeze(D(:,:,i));
    size(D1)

    D1=whiten_patches(D1')';
%     imagesc(D1);
    
    
    D2=[D2 D1(:)];
    
    size(D2)
  
    
end


imagesc(D2)

Data=D2;

save('Robohand_EEG_Data_Rest.mat','Data')






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

    