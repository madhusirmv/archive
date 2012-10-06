function [ rewards choice ] = TestBandit_k( ntrials )
% Simple TD agent with softmax exploration playing a k-armed bandit.
%   Returns choices.

    armprobs = [0.8 0.1 0.1 0.1];
    k=length(armprobs);
    
    choice = zeros(1,ntrials);
    rewards = zeros(1,ntrials);
    
    beta=10; % Softmax temperature
    eta=0.1; % learning rate
    %gamma=0.95;
    
    Q = zeros(k,1);
    for t = 1:ntrials
        % Choose action
        p=exp(Q*beta) / sum(exp(Q*beta));
        ch = sum(mnrnd(1,p).*(1:k)); % ugly trick to get action number from multinomial
        choice(1,t)=ch;
        obs_pay = (rand()<armprobs(ch));
        rewards(1,t)=obs_pay;
        
        PE = obs_pay - Q(ch);
        Q(ch) = Q(ch) + eta * PE;
    end
    
end

