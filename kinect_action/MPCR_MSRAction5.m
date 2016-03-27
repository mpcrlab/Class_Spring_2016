

function MPCR_MSRAction

clear all
close all
clf

Train=load('/Users/williamedwardhahn/Desktop/MSRAction3DSkeleton(20joints)/MSRAction3D_Data_Train.mat');

Test=load('/Users/williamedwardhahn/Desktop/MSRAction3DSkeleton(20joints)/MSRAction3D_Data_Test.mat');


Train=Train.Data;

Test=Test.Data;

% r1=randperm(size(Train,2))

Train=Train(:,randperm(size(Train,2)));

Test=Test(:,randperm(size(Test,2)));

% subplot(121)
% imagesc(Train)
% subplot(122)
% imagesc(Test)

r=[];
cm=zeros(16,16);

D=Train(1:end-3,:);

for i=1:size(Test,2)

y=Test(1:end-3,i);

Dkey=Train((end-2):end,:);
ykey=Test((end-2):end,i);



% a=BP(0.5,D,y);
a=LCA(0.5,D,y);

subplot(311)
bar(abs(a))


b=[];


for i=1:16
    
    b=[b, sum(abs(a(Dkey(1,:)==i)))];
    
   
end

subplot(312)
bar(b)


[b1,b2]=sort(b,'descend');




[b2(1) ykey(1)]
cm(ykey(1),b2(1))=cm(ykey(1),b2(1))+1;


r=[r b2(1)==ykey(1)];
sum(r)/length(r)
drawnow()

subplot(313)
conf_matrix(cm)


end



end







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



d=0.00001;

u = zeros(size(D,2),1);


for i=1:500
    
    
    a = ( u - sign(u).*(lambda) ) .* ( abs(u) > (lambda) );
    
    u =   u + d * ( D' * ( y - D*a ) - u - a  ) ;


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



function conf_matrix(mat)



imagesc(mat);            %# Create a colored plot of the matrix values
% colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

textStrings = num2str(mat(:),'%0.0f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:16);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
% midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
% textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
% set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:16,...                         %# Change the axes tick marks
        'XTickLabel',{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P'},...  %#   and tick labels
        'YTick',1:16,...
        'YTickLabel',{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P'},...
        'TickLength',[0 0]);
    
end
