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
y = Data_Left(:,1,:); % data from first channel, from first trial.

% Initialize
e = y; % if x = 0, and e=y-DX, then e = y to start. 

% initialize with a random dictionary?? 
m = 2000; % ?? so that n<= m ? overcomplete
D = zeros(1000,3526,32);
for i = 1:32
    D(:,:,i) = wmpdictionary(1000);
end


% initialize x, which we know will be of dimension mx1
% x = zeros(n,1);

% initialize the sparse estimate, k which k < n
k = 900; % ????

% inline update functions (can rewrite later) 
Af  = @(x) D*x;
At  = @(x) permute(D,[2 1 3]).*x;

% initialize other variables
normE = norm(squeeze(e)); 
% Ar = At(e);
Dperm = permute(D,[2 1 3]);
for u = 1:32
    Ar(:,1,u) = Dperm(:,:,u)*e(:,:,u);
end
N = size(Ar,1);
M = size(e,1);

unitVector = zeros(N,1);
x = zeros(N,1);

indx_set = zeros(k,1);
indx_set_sorted = zeros(k,1);
A_T = zeros(M,k,32);
A_T_nonorth = zeros(M,k,32);
residHist = zeros(k,1);
errHist = zeros(k,1);

target_resid = [];

%% 

% run through k iterations first as stopping condition. 
for i = 1:k
    
    % Step 1: find new index and atom to add
    
    [dummy, ind_new] = max(sum(abs(Ar),3));
    indx_set(i) = ind_new;
    indx_set_sorted(1:i) = sort(indx_set(1:i));
    
    atom_new = D(:,ind_new,:);
    A_T_nonorth(:,i,:) = atom_new; % before orthogonalizing
    
    %---------------------------------------------------
    % Step 2: Update residue
    % 1) Orthogonalize 'atom_new' against all previous atoms. (Use MGS)
    for j = 1:(i-1)
        for uu = 1:32
        atom_new(uu) = atom_new(uu) - (A_T_perm(j,:,uu)*atom_new(uu))*A_T(:,j,uu);
        end
    end
    % 2) Normalize
    atom_new = atom_new/norm(squeeze(atom_new));
    A_T(:,i,:) = atom_new;
    % 3) Solve least-squares problem
    A_T_tmp = A_T(:,1:i,:);
    A_T_perm = permute(A_T_tmp, [2 1 3]);
%     x_T = A_T_perm*y;
    x_T = zeros(i,1,32);
    for u = 1:32
        x_T(:,1,u) = A_T_perm(:,:,u)*y(:,:,u);
    end
    
    % Figure out the line below!!
%     x(indx_set(1:i)) = x_T;
    x_T_sqz = squeeze(x_T);
    if i == 1
        x_T_sqz = permute(x_T_sqz,[2 1]);
    end
    for uu = 1:size(x_T_sqz,1)
    x_T_norms(uu) = norm(x_T_sqz(uu,:));
    end
    x(indx_set(1:i)) = x_T_norms;
    
    
    % 4) Update residual
    for uu = 1:32
        e(:,:,uu) = y(:,:,uu) - A_T(:,1:i,uu)*x_T_norms(1:i)';
    end
%     e = y - A_T(:,1:i,:)*x_T_norms;
    
    % OR) can be done like this: 
%     x_T = A_T_nonorth(:,1:i)\y;
%     x(indx_set(1:i)) = x_T;
%     e = y - A_T_nonorth(:,1,i)*x_T;
    
    %-----------------------------------------------------
    % Step 3: Check conditions and update for next round
    normE = norm(squeeze(e));
    residHist(i) = normE;
    
    if normE < target_resid
        fprintf('Residual target reached! (%.2e < %.2e)\n', normE, target_resid);
%         break;
    end
    
    if i < k
        %         Ar = At(e); % prepare for next loop
        for u = 1:32
            Ar(:,1,u) = Dperm(:,:,u)*e(:,:,u);
        end
    end
    
end % end for loop
fprintf('Final residual error is: %.2e \n', normE);
% x_T = A_T_nonorth(:,1:i)\y;
% x(indx_set(1:i)) = x_T;
% e = y - A_T_nonorth(1:i)*x_T;
% normE = norm(e);

   
    
    
    
