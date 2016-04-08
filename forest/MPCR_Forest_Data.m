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
function MPCR_Forest_Data



clear all
close all
clc

cd('/Users/williamedwardhahn/Desktop/forest/ForestTypes/')

Data=importdata('training.csv');

Train_Labels1=Data.textdata(2:end,1);

Train_Data=Data.data';


Data=importdata('testing.csv');

Test_Labels1=Data.textdata(2:end,1);

Test_Data=Data.data';



Test_Labels=zeros(size(Test_Labels1,1),1);
Train_Labels=zeros(size(Train_Labels1,1),1);

Train_Labels(strcmp(Train_Labels1,'s '))=1;
Train_Labels(strcmp(Train_Labels1,'h '))=2;
Train_Labels(strcmp(Train_Labels1,'d '))=3;
Train_Labels(strcmp(Train_Labels1,'o '))=4;

Test_Labels(strcmp(Test_Labels1,'s '))=1;
Test_Labels(strcmp(Test_Labels1,'h '))=2;
Test_Labels(strcmp(Test_Labels1,'d '))=3;
Test_Labels(strcmp(Test_Labels1,'o '))=4;


subplot(211)
imagesc(Train_Data)
subplot(212)
imagesc(Test_Data)

pause

Train_Data=whiten_patches(Train_Data);
Test_Data=whiten_patches(Test_Data);

% subplot(211)
% imagesc(Train_Data)
% subplot(212)
% imagesc(Test_Data)


D=Train_Data;

r=[];

for i=1:size(Test_Data,2)
    
    
    y=Test_Data(:,i);
    
    
    a=BP(3,D,y);
    
%     a=LCA(5,D,y);
   
    a=abs(a);
    subplot(411)
    bar(a)
    
    
%     b=[]
%     for j=1:4
%     
%         b=[b sum(abs(a(Train_Labels==j)))];  
%         
%     end    
%     subplot(412)
%     bar(b)
        
    [b1,b2]=max(a);
    
    [Train_Labels(b2) Test_Labels(i)]
    
    r=[r Train_Labels(b2)==Test_Labels(i)];
    
    sum(r)/length(r)
    
    
    
end




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








function [a] = BP(k,D,y)


cvx_begin quiet;

l=size(D);

variable a(l(2));

minimize( norm(D*a-y) );

subject to;

norm(a,1) <= k;

cvx_end;



end



function [a, u] = LCA(lambda,D,y)



d=0.01;

u = zeros(size(D,2),1);
a = u;

for i =1:100
    
    
    a = ( u - sign(u).*(lambda) ) .* ( abs(u) > (lambda) );
    
    u =   u + d * ( D' * ( y - D*a ) - u - a  ) ;
    
    
end




end








function conf_matrix(mat)



imagesc(mat);            %# Create a colored plot of the matrix values
% colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
%#   black and lower values are white)

% textStrings = num2str(mat(:),'%0.0f');  %# Create strings from the matrix values
% textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
% [x,y] = meshgrid(1:16);   %# Create x and y coordinates for the strings
% hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
%     'HorizontalAlignment','center');
% midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
% textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
%#   text color of the strings so
%#   they can be easily seen over
%#   the background color
% set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

% set(gca,'XTick',1:16,...                         %# Change the axes tick marks
%     'XTickLabel',{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P'},...  %#   and tick labels
%     'YTick',1:16,...
%     'YTickLabel',{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P'},...
%     'TickLength',[0 0]);

end
