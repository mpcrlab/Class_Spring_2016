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
% 
% Oscillator Network Demo
% 
% See:
% Yu, Guoshen, and J-J. Slotine. 
% Visual grouping by neural oscillator networks. 
% Neural Networks, IEEE Transactions on 20.12 (2009): 1871-1884.
%  
% Wang, DeLiang, and D. Termani. 
% Locally excitatory globally inhibitory oscillator networks. 
% Neural Networks, IEEE Transactions on 6.1 (1995): 283-286.
%
%------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[]=MPCR_Oscillator_Network()

clc
clear all
close all

N=2;

k=-0.01.*ones(N);

t0=0;
tf=40;

numpts=10000;

h=(tf-t0)/(numpts-1); %define step size

t=t0:h:tf; %build time vector

v=zeros(N,numpts);
w=zeros(N,numpts);

index=1;

v(:,index)=2*(rand(1,N)-rand(1,N))';
w(:,index)=4*(rand(1,N)-rand(1,N))';

for index=1:numpts-1
      
  v(:,index+1)=v(:,index)+h*dv_dt(v(:,index),w(:,index),k);
  w(:,index+1)=w(:,index)+h*dw_dt(v(:,index),w(:,index),k);
 
end


%********************************************************************%
%Plot
%********************************************************************%
% 
% 
figure(1)
plot(t,v(1:N,:),'LineWidth',1.25);

figure(2)
hold on
plot(v(1,:),w(1,:),'r','LineWidth',1.25);
plot(v(2,:),w(2,:),'g','LineWidth',1.25);
% plot(v(3,:),w(3,:),'b','LineWidth',1.25);
hold off






function[slope]=dv_dt(v,w,k)

slope=3.*v-v.^3-v.^7+2-w;

slope=slope+sum(k.*(repmat(v,1,size(v,1))'-repmat(v,1,size(v,1))),2);



function[slope]=dw_dt(v,w,k)

alpha=12;
c=0.04;
rho=4;

slope=c.*(alpha.*(tanh(rho.*v))-w);

slope=slope+sum(k.*(repmat(w,1,size(w,1))'-repmat(w,1,size(w,1))),2);







