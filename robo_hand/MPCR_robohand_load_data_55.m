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
function MPCR_robohand_load_data_55

clear all; close all; clc;

cd('~/hdd/Insync/MPCR_Data_Analysis/S001E01R01-03');
% cd('/Users/williamedwardhahn/Desktop/robohand')

Data_Left=load('Robohand_EEG_Data_Left.mat');
Data_Right=load('Robohand_EEG_Data_Right.mat');
% Data_Left=load('Raw_Left_Vect.mat');
% Data_Right=load('Raw_Right_Vect.mat');


Data_Left_0=Data_Left.Data;
Data_Right_0=Data_Right.Data;

r=[];
cm=zeros(2,2);


for j=1:100
    
    Data_Left=Data_Left_0(:,randperm(size(Data_Left_0,2)));
    Data_Right=Data_Right_0(:,randperm(size(Data_Right_0,2)));
    
    y1=Data_Left(:,1);
    y2=Data_Right(:,1);
      
    D=double([Data_Left(:,2:end) Data_Right(:,2:end)]);
    
    for i=[1 2]
        
        
        if i ==1
            y=double(y1);
        else
            y=double(y2);
        end
        

%         a=BP(0.15,D,y);
        
        a=LCA(0.5,D,y);
        a=abs(a);
        subplot(411)
        bar(a)
        
        
%         b1=[sum(a(1:end/2)) sum(a(end/2+1:end))];
        
%         b=[max(a(1:end/2)) max(a(end/2+1:end))];
        b=[max(a(1:60)) max(a(61:end))];
        
%         b3=[sum(a(1:end/2)>0) sum(a(end/2+1:end)>0)];
        

        subplot(412)
        bar(b)
        
%         pause
%         continue
%         
        [b1,b2]=sort(b,'descend');
        

%         [b2(1) i]
        
         
        cm(i,b2(1))=cm(i,b2(1))+1;
        
        
        r=[r b2(1)==i];
%         sum(r)/length(r)
%         [sum(r) length(r)]
        
        
        subplot(413)
        conf_matrix(cm)
        
        subplot(414)
        hist(r,[0 1])
        drawnow()
        
        
        
        
    end
    
    
    
    
    
    
end
sum(r)/length(r)
cm
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



d=0.001;

u = zeros(size(D,2),1);
a = u;

while norm(a,1)<2*lambda %sum(a>0)<3 %
    
    
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
