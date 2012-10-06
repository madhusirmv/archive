function [ rewards choice ] = TestBandit( ntrials )
% Simple TD agent with softmax exploration playing a 2-armed bandit.
%   Returns choices.

    armprobs = [0.8 0.4];
    payoffs = zeros(2,ntrials);
    payoffs(1,:)=rand(1,ntrials)<armprobs(1);
    payoffs(2,:)=rand(1,ntrials)<armprobs(2);    
    
    choice = zeros(1,ntrials);
    rewards = zeros(1,ntrials);
    
    beta=2; % Softmax temperature
    eta=0.1; % learning rate
    %gamma=0.95;
    
    Q = zeros(2,1);
    for t = 1:ntrials
        % Choose action
        a = exp(Q(1)*beta) / (exp(Q(1)*beta) + exp(Q(2)*beta));
        if(rand() < a)
            ch=1;
        else
            ch=2;
        end
        choice(1,t)=ch;
        obs_pay = payoffs(ch,t);
        rewards(1,t)=obs_pay;

        PE = obs_pay - Q(ch);
        Q(ch) = Q(ch) + eta * PE;
    end

end