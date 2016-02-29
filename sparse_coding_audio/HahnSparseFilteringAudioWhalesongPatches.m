
clear all
close all
clc
beep off


cd('/Users/williamedwardhahn/Desktop/whale/train2/')

% ls

dr1=dir('*1.aif')

f1={dr1.name}; % get only filenames to cell

X=[];

length(f1)

for i=1:500%length(f1) % for each whale clip
%     i
    
    a1=f1{i};
    
    [y,fs] = audioread(a1);

    z = y(:,1);
     
%     plot(z)
%     drawnow()
  
    ps=fs;
    

    z=z(1:end-mod(size(z,1),ps));
    

    z = reshape(z, ps, size(z,1)/ps);
    
    
    X=[X z];
  
    
    size(X)
    
    

end
    

cd('/Users/williamedwardhahn/Desktop/whale/whalesongdata')
save(['HahnAudioPatches_' num2str(ps) a1 '_Whalesong_1.mat'],'X','-v7.3')
    
     

%     X = bsxfun(@minus,X,mean(X)); %remove mean
%     fX = fft(fft(X,[],2),[],3); %fourier transform of the images
%     spectr = sqrt(mean(abs(fX).^2)); %mean spectrum
%     X = ifft(ifft(bsxfun(@times,fX,1./spectr),[],2),[],3); %whitened X
%     
%     
%     cd('/Users/williamedwardhahn/Desktop/whale/whalesongdata/Whitened')
%     
%     save(['HahnAudioPatches_' num2str(ps) a1 '_Whalesong_whitened.mat'],'X','-v7.3')
    
 
    
    








%
%     X=z(1:end-mod(size(z,1),ps));
%
%
%
%
%     X = reshape(X, ps, size(X,1)/ps);
%%%%%%%%%%%%



%  save('songbird.mat','z','fs');


