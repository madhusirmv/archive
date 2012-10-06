function LL = rllik(eta,beta,lambda,state,choice1,choice2,money)
% LL = rllik(eta,beta,lambda,state,choice1,choice2,money)
%
% output: LL - the log likelihood of the data
% input:
% eta     - learning rate
% beta    - softmax inverse temperature
% lambda  - eligibility trace decay rat (set to 0 to get TD(0) without eligibility traces)
% state   - 1 is the top level, 2 and 3 are the bottom level
% choice1 - the choice at the top level -- 1 or 2 (0 for missed trials)
% choice2 - the choice at the bottom level -- 1 or 2 (0 for missed trials)
% money   - amount won (1 or 0)

NStates = 3;
NActions = 2;
NTrials = length(choice1);

Q = zeros(NStates,NActions); % initialize Q values to 0
LL = 0;                       % initialize log likelihood

% main loop
for t = 1:NTrials
    
    E = zeros(NStates,NActions); % initialize Eligibility traces

    S = 1;  % first we are in the top level
     
    % stop if trial was missed
    if (choice1(t) == 0)
        continue
    end

    % first level choice likelihood
    
    h = exp(beta*Q(S,1)) + exp(beta*Q(S,2));
    LL = LL + beta*Q(S,choice1(t)) - log(sum(h));

    % learning at first level
    
    E(S,choice1(t)) = 1;  % eligibility trace
    PE = max(Q(state, 1), Q(state, 2)) - Q(S,choice1(t)); 
    Q(S,choice1(t)) = Q(S,choice1(t)) + PE * eta * E(S,choice1(t));
    
    % second level choice likelihood
    
    S = state(t);
    
    % stop if trial was missed
    if (choice2(t) == 0)
        continue
    end
    
    h = exp(beta*Q(S,1)) + exp(beta*Q(S,2));
    LL = LL + beta*Q(S,choice2(t)) - log(sum(h));
    

    % learning at second level
    
    E = lambda * E;      % first decay all eligibility traces
    E(S,choice2(t)) = 1;  % then update current eligibility trace
    
    PE = money(t)- Q(S,choice2(t)) ;

    Q(S,choice2(t)) = Q(S,choice2(t)) + PE * eta * E;
    
    %Update again 1st level
    Q(S,choice1(t)) = Q(S,choice1(t)) + PE * eta * E;
          
end

% we are minimizing this function, so use minus LL

LL = -LL;