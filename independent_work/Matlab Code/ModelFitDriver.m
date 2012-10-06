clear all; clc; 

Subjects = [8];
Nsubjects = length(Subjects);

C1 = []; C2 = []; R = []; S = [];
for s = 1:Nsubjects
     SubjFile = dir('Subj117.mat');
     %SubjFile = dir(sprintf('Subj%d_*',Subjects(s)));
     load (SubjFile(end).name);  % loading the subject's behavioral data
     C1 = [C1; choice1]; % the choices at level 1
     C2 = [C2; choice2]; % the choices at level 2
     R  = [R; money];    % the rewards
     S  = [S; state];    % the states at level 2
end
[Nsubjects,Ntrials] = size(S); 

Fit = {}; 
clear Eta Beta Lambda
for iter = 1:15;   % run 15 times from random initial conditions, to get best fit
    for i = 1:Nsubjects;
        fprintf('%d...',i)
        
        LB = [1e-6 1e-6 1e-6]; 
        UB = [1-(1e-6) 30 1-(1e-6)];
        init = rand(1,length(LB)).*(UB-LB)+LB; % random initialization within the bounds

        % finding the minimum of the function rllik
        [res lik] = fmincon(@(x) rllik_Modelfree(x(1),x(2),x(3),S(i,:),C1(i,:),C2(i,:),R(i,:)),init,[],[],[],[],LB,UB,[],...
            optimset('maxfunevals',5000,'maxiter',2000,'GradObj','off','DerivativeCheck','off','LargeScale','off','Algorithm','active-set','Hessian','off'));
        
        % gathering results
        Eta(i) = res(1); 
        Beta(i) = res(2);
        Lambda(i) = res(3);
        Lik(i) = lik;
    end
    fprintf('\n')
    
    Fit{iter} = [[1:Nsubjects]' Eta' Beta' Lambda' Lik'];
    L(:,iter) = Lik';  % Check this to see the likelihoods from the different runs (to check how stable the fits were to different starting points)
end

% find the best fit of all 5 runs
clear BestFit
[a,b] = min(L');
for i = 1:Nsubjects
    BestFit(i,:) = Fit{b(i)}(i,:);
end

% print the results
fprintf('Subject\t eta\t beta\t lambda\t likelihood\n')
fprintf('%d\t %3.4f\t %3.4f\t %3.4f\t %3.4f\n',BestFit')

