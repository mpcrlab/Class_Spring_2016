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
%https://en.wikipedia.org/wiki/Cellular_neural_network
%------------------------------------------------------%
function MPCR_SBFSEM_Cell_NN3

clear all
close all
clc

fname = 'train-volume.tif';
info = imfinfo(fname);
num_images = numel(info);
Y1=zeros(512,512,num_images);

for k = 1:num_images
    
    Y1(:,:,k) = imread(fname, k);
    
end



fname = 'train-labels.tif';
info = imfinfo(fname);
num_images = numel(info);
Y2=zeros(512,512,num_images);

for k = 1:num_images
    
    Y2(:,:,k) = imread(fname, k);
    
end



I1=Y1(:,:,1);
I2=Y2(:,:,1);
I3=CellNN(im2double(I1));


I1=I1/norm(I1);
I2=I2/norm(I2);
I3=I3/norm(I3);

subplot(141)
imagesc(I1);
colormap gray

subplot(142)
imagesc(I3);
colormap gray

subplot(143)
imagesc(I2);
colormap gray

subplot(144)
imagesc(abs(I3-I2));
colormap gray







error=norm(abs(I3-I2))


end









function x=CellNN(x)

uu = (max(max(x)));
ul = (min(min(x)));
x = (x-ul)/(uu-ul)*2-1;

x0=0.*x;

A=[0 0 0;6 3 1;0 0 0];
B=[0 -1 0; -1 8 -1;0 -1 0];
Z=0.1;

dt = 0.1;

B0=conv2(x0,B,'same');

for j=1:25
       
    dx = -x + conv2(f(x),A,'same') + B0 + Z ;
    
    x=x+dx.*dt;
    
end;




end





function y = f(x)

y=(abs(x+1)/2 - abs(x-1)/2);

end








