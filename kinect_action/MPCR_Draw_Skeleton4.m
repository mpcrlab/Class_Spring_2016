
function MPCR_Draw_Skeleton4

Data=[];


for a=1:16

    for s=1:5

        for i=1:3

            try 
            D=drawskt(a,a,s,s,i,i);
            catch
                continue
            end

            D=[D; a;s ;i];
            
%             hist(D)
%             pause
%             D=D/norm(D);
%             
%             hist(D)
%             pause
%             
            Data=[Data D];
            
            size(Data)
            imagesc(Data)
            pause(0.1) 
            
            
        end

    end
    
end


save('MSRAction3D_Data_Train.mat','Data')



Data=[];

for a=1:16

    for s=6:10

        for i=1:3

            try 
            D=drawskt(a,a,s,s,i,i);
            catch
                continue
            end

            D=[D; a;s ;i];
            
%             hist(D)
%             pause
%             D=D/norm(D);
%             
%             hist(D)
%             pause
%             
            Data=[Data D];
            
            size(Data)
            imagesc(Data)
            pause(0.1) 
            
            
        end

    end
    
end


save('MSRAction3D_Data_Test.mat','Data')


end








%USAGE: drawskt(1,3,1,4,1,2) --- show actions 1,2,3 performed by subjects 1,2,3,4 with instances 1 and 2.
function D = drawskt(a1,a2,s1,s2,e1,e2)

J=[20     1     2     1     8    10     2     9    11     3     4     7     7     5     6    14    15    16    17;
    3     3     3     8    10    12     9    11    13     4     7     5     6    14    15    16    17    18    19];

B=[];
for a=a1:a2
    for s=s1:s2
        for e=e1:e2
            file=sprintf('a%02i_s%02i_e%02i_skeleton.txt',a,s,e);
            fp=fopen(file);
            if (fp>0)
               A=fscanf(fp,'%f');
               B=[B; A];
               fclose(fp);
            end
        end
    end
end

l=size(B,1)/4;
B=reshape(B,4,l);
B=B';
B=reshape(B,20,l/20,4);


size(B)

C=[];



for i=1:29%size(B,2)
    

%     imagesc(squeeze(B(:,i,:)))


    

    B1=squeeze(B(:,i,1:3));
    
%     imagesc(B1)
%     pause
    
    B1=(B1-(repmat(B1(7,:),20,1)));
    
%     imagesc(B1)
%     pause
    
    
    
    C=[C; B1];
    
    

    
end

% size(C)
% 
% imagesc(C)


D=[whiten_patches(C(:,1)); whiten_patches(C(:,2)); whiten_patches(C(:,3))];




% imagesc(D)








return 





X=B(:,:,1);
Z=400-B(:,:,2);
Y=B(:,:,3)/4;
P=B(:,:,4);

for s=1:size(X,2)
    S=[X(:,s) Y(:,s) Z(:,s)];
  
    xlim = [0 800];
    ylim = [0 800];
    zlim = [0 800];
    set(gca, 'xlim', xlim, ...
             'ylim', ylim, ...
             'zlim', zlim);

    h=plot3(S(:,1),S(:,2),S(:,3),'r.');
    %rotate(h,[0 45], -180);
    set(gca,'DataAspectRatio',[1 1 1])
    axis([0 400 0 400 0 400])

    for j=1:19
        c1=J(1,j);
        c2=J(2,j);
        line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)]);
    end
    pause(1/20)
end


end





function X=whiten_patches(X)

% Whiten Images in Matlab
% http://xcorr.net/2013/04/30/whiten-images-in-matlab/

X = bsxfun(@minus,X,mean(X)); %remove mean
fX = fft(fft(X,[],2),[],3); %fourier transform of the images
spectr = sqrt(mean(abs(fX).^2)); %Mean spectrum
X = ifft(ifft(bsxfun(@times,fX,1./spectr),[],2),[],3); %whitened X


end