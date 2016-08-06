%%

%=================================================================
%
% Conduct Multivariate Orthogonal Matching Pursuit (M-OMP)
% Thomas Colestock
% Florida Atlantic University
% BioRobotics Laboratory
% - Department of Ocean and Mechanical Engineering
% Machine Perception and Cognitive Robotics Laboratory
% - Center for Complex Systems and Brain Sciences
% 
% April 18, 2016
% ver 0.01
%
%==================================================================


%% 

clear all; close all; clc; 

cd('~/hdd/Insync/MPCR_Data_Analysis/S001E01R01-03');

Data_Left = load('White_Left_Multivariate.mat','Data');
Data_Left = Data_Left.Data;
% Data_Right = load('White_Right_Multivariate.mat','Data');
% Data_Right = Data_Right.Data;
% Data_Rest = load('White_Rest_Multivariate.mat','Data');
% Data_Rest = Data_Rest.Data;

%% 

% pick the first signal to be analyzed. 
% Use unichannel data for non-multivariate OMP
y = Data_Left(:,1,1); % data from first channel, from first trial.

% Initialize
e = y; % if x = 0, and e=y-DX, then e = y to start. 

% initialize with a random dictionary?? 
m = 2000; % ?? so that n<= m ? overcomplete
D = rand(size(y,1),m);

% initialize x, which we know will be of dimension mx1
% x = zeros(n,1);

% initialize the sparse estimate, k which k < n
k = 900; % ????

% inline update functions (can rewrite later) 
Af  = @(x) D*x;
At  = @(x) D'*x;

% initialize other variables
normE = norm(e); 
Ar = At(e);
N = size(Ar,1);
M = size(e,1);

unitVector = zeros(N,1);
x = zeros(N,1);

indx_set = zeros(k,1);
indx_set_sorted = zeros(k,1);
A_T = zeros(M,k);
A_T_nonorth = zeros(M,k);
residHist = zeros(k,1);
errHist = zeros(k,1);

target_resid = [];

%% 

% run through k iterations first as stopping condition. 
for i = 1:k
    
    % Step 1: find new index and atom to add
    [dummy, ind_new] = max(abs(Ar));
    indx_set(i) = ind_new;
    indx_set_sorted(1:i) = sort(indx_set(1:i));
    
    atom_new = D(:,ind_new);
    A_T_nonorth(:,i) = atom_new; % before orthogonalizing
    
    %---------------------------------------------------
    % Step 2: Update residue
    % 1) Orthogonalize 'atom_new' against all previous atoms. (Use MGS)
    for j = 1:(i-1)
        atom_new = atom_new - (A_T(:,j)'*atom_new)*A_T(:,j);
    end
    % 2) Normalize
    atom_new = atom_new/norm(atom_new);
    A_T(:,i) = atom_new;
    % 3) Solve least-squares problem
    x_T = A_T(:,1:i)'*y;
    x(indx_set(1:i)) = x_T;
    % 4) Update residual
    e = y - A_T(:,1:i)*x_T;
    
    % OR) can be done like this: 
%     x_T = A_T_nonorth(:,1:i)\y;
%     x(indx_set(1:i)) = x_T;
%     e = y - A_T_nonorth(:,1,i)*x_T;
    
    %-----------------------------------------------------
    % Step 3: Check conditions and update for next round
    normE = norm(e);
    residHist(i) = normE;
    
    if normE < target_resid
        fprintf('Residual target reached! (%.2e < %.2e)\n', normE, target_resid);
%         break;
    end
    
    if i < k
        Ar = At(e); % prepare for next loop
    end
    
end % end for loop
fprintf('Final residual error is: %.2e \n', normE);
x_T = A_T_nonorth(:,1:i)\y;
x(indx_set(1:i)) = x_T;
e = y - A_T_nonorth(1:i)*x_T;
normE = norm(e);

   
    
    
    
