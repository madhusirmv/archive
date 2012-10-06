function [m_ll] = DrawLikelihoodSurface(ntrials)

eta_params=0.1:0.1:0.9;
beta_params=0.1:0.5:5.1;

m_ll=zeros(length(eta_params), length(beta_params));

%ntrials=1000;

[r c]=TestBandit(ntrials);

i=1;
for eta=eta_params
    j=1;
    for beta=beta_params
        m_ll(i,j)=loglike_bandit(c,r,ntrials,eta,beta,0);
        j=j+1;
    end
    i=i+1;
end
    
end