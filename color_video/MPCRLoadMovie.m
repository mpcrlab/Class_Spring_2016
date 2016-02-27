






clear all
close all
clc
beep off

cd /Users/williamedwardhahn/Documents/MATLAB/HahnVideo/


v = VideoReader('bike4.mov');



nf = v.NumberOfFrames
h = v.Height;
w = v.Width;


nfw=1000;


data=zeros(h,w,nfw);



for i=1:nfw

    i
    data(:,:,i)=rgb2gray(read(v,i));


end



save('bike_motion_data.mat','data')












load bike_motion_data.mat

j=1;

m=10;
n=10;


patches=[];

for j=0:10:100

    C=[];

    for i=j+1:j+10



        I=data(:,:,i);


        B = im2col(I,[m n],'distinct');

        C=[C; B];


    end


    patches=[patches, C];



end



save('motion_patches.mat','patches')






load motion_patches.mat



patches=patches/255;




for i=1:10
    
    
    for j=1:100
        
        
        subplot(10,10,j)
        
        I=reshape(patches(:,j),[10 10 10]);
        
        imagesc(I(:,:,i))
        
        
        
    end
    
    pause
    
end




















































I=rand(10,10,10,100);


for j=1:100

    for i=1:10

        subplot(1,10,i)
        imagesc(I(:,:,i,j))


    end
    drawnow
end





































