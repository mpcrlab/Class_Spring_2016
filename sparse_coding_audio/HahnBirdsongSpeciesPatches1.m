


clear all
close all
clc

cd('/Users/williamedwardhahn/Desktop/birdsong/Birdsong1/train_set')

ls

dr1=dir('*.wav')

f1={dr1.name}; % get only filenames to cell

d=[];


for i=1:length(f1) % for each species of bird
    
    
    
    i
    
    a1=f1{i};
    
    [y,fs] = audioread(a1);
    
    
    z = y(:,1);
    
    
    plot(z)
    drawnow()
   
    
    ps=200;
    
%     soundsc(z(100000:100000+patchsize),fs)
%     
%     return
    
    
    X=z(1:end-mod(size(z,1),ps));
    
    
    
    
    X = reshape(X, ps, size(X,1)/ps);
    %%%%%%%%%%%%
    
    
    
   



cd('/Users/williamedwardhahn/Desktop/birdsong/birdsongdata')
save(['HahnAudioPatches_' num2str(ps) a1 '_Birdsong_.mat'],'X','-v7.3')


X = bsxfun(@minus,X,mean(X)); %remove mean
fX = fft(fft(X,[],2),[],3); %fourier transform of the images
spectr = sqrt(mean(abs(fX).^2)); %mean spectrum
X = ifft(ifft(bsxfun(@times,fX,1./spectr),[],2),[],3); %whitened X


cd('/Users/williamedwardhahn/Desktop/birdsong/birdsongdata/Whitened')

save(['HahnAudioPatches_' num2str(ps) a1 '_Birdsong_whitened.mat'],'X','-v7.3')


cd('/Users/williamedwardhahn/Desktop/birdsong/Birdsong1/train_set')


end











%  save('songbird.mat','z','fs');


