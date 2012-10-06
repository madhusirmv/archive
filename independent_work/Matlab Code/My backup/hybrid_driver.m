%clear all; clc; 

Subjects = [17];
Nsubjects = 17;

C1 = []; C2 = []; R = []; S = []; subj = [];
SubjFile = dir('dawdatatrans.mat');
%SubjFile = dir(sprintf('Subj%d_*',Subjects(s)));
load (SubjFile(end).name);  % loading the subject's behavioral data
for s = 1:Nsubjects
     offset = ((s-1) * 201) + 1;
     endoffset = offset + 200;
     C1 = [C1; ch1(offset:endoffset)]; % the choices at level 1
     C2 = [C2; ch2(offset:endoffset)]; % the choices at level 2
     R  = [R; mn(offset:endoffset)];    % the rewards
     S  = [S; st(offset:endoffset)];    % the states at level 2
     subj = [subj; sub(offset:endoffset)];
end
[Nsubjects,Ntrials] = size(S); 
optset = optimset('maxfunevals',5000,'maxiter',2000,'GradObj','off','DerivativeCheck','off','LargeScale','off','Algorithm','active-set','Hessian','off','Display', 'off');
Fit = {}; 
clear Eta1 Eta2 Beta1 Beta2 Lambda w p
for iter = 1:3;   % run 1 times from random initial conditions, to get best fit
    for i = 1:Nsubjects;
        fprintf('%d...',i)
        
        LB = [1e-6 1e-6 1e-6 1e-6 1e-6 1e-6 -30];
        UB = [1-(1e-6) 1-(1e-6) 30 30 1-(1e-6) 1-(1e-6) 30];
        init = rand(1,length(LB)).*(UB-LB)+LB; % random initialization within the bounds
        
        % finding the minimum of the function rllik
        [res lik] = fmincon(@(x) rllik_hybrid(x(1),x(2),x(3),x(4),x(5), x(6), x(7), S(i,:),C1(i,:),C2(i,:),R(i,:)),init,[],[],[],[],LB,UB,[],...
            optset);
        
        % gathering results
        Eta1(i) = res(1); 
        Eta2(i) = res(2); 
        Beta1(i) = res(3);
        Beta2(i) = res(4);
        Lambda(i) = res(5);
        w(i) = res(6);
        p(i) = res(7);
        Lik(i) = lik;
    end
    fprintf('\n')
    
    Fit{iter} = [[1:Nsubjects]' Eta1' Eta2' Beta1' Beta2' Lambda' w' p' Lik'];
    L(:,iter) = Lik';  % Check this to see the likelihoods from the different runs (to check how stable the fits were to different starting points)
end

% find the best fit of all 5 runs
clear BestFit
[a,b] = min(L');
for i = 1:Nsubjects
    BestFit(i,:) = Fit{b(i)}(i,:);
end

% print the results
fprintf('Sub\t eta1\t eta2\t beta1\t beta2\t lambda\t w\t p\t LL\n')
fprintf('%d\t %3.3f\t %3.3f\t %3.3f\t %3.3f\t %3.3f\t %3.3f\t%3.3f\t %3.3f\t\n',BestFit')

