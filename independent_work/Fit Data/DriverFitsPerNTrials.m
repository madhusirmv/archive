simulated=true;

if(simulated)
    n=500;
    [rew ch]=TestBandit(n);
else
    load '/Volumes/niv/carlos/casino/behavior/Subject05 (2009-8-7 11.14.8).mat'
    n=length(doorchoices);
    rew=doorrewards;
    ch=doorchoices;
end
step=10;
from=10;
to=n;
reps=1;

nk=length(from:step:to);

ll=zeros(nk,reps);
eta=zeros(nk,reps);
beta=zeros(nk,reps);
hess=cell(nk,reps);

i=1;
for k=from:step:to;
    for r=1:reps;
        [fit hessian]=ModelFitDriver(ch(1:k),rew(1:k),3);
        eta(i,r)=fit{2};
        beta(i,r)=fit{3};
        ll(i,r)=fit{4};
        hess{i,r}=hessian;
    end
    i=i+1;
end

mean_ll=mean(ll,2);
numtrials=from:step:to;
ll_per_trial = mean_ll./numtrials';

invhess=zeros(1,length(hess));
for i=1:length(hess)
    invhess(i)=norm((inv(hess{i})));
end

figure;
plot(numtrials, ll_per_trial);
title('Log likelihood per trial');

figure
plot(numtrials, invhess, 'r');
title('Norm of Inverse Hessian per trial');

% figure;
% plot(numtrials, std(eta'));
% title('Standard Deviation of Eta');
% 
% figure;
% plot(numtrials, mean(eta,2));
% hold on;
% plot(numtrials, ones(size(numtrials))*0.1, '--');
% title('Eta');
% hold off;