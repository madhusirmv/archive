function LL = rllik_hybrid(eta1, eta2, beta1, beta2, lambda, w , p, state,choice1,choice2,money)
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

Qfree = zeros(NStates,NActions); % initialize Qfree values to 0
Qbased = zeros(NStates,NActions); % initialize Qbased values to 0
Qhybrid = zeros(NStates,NActions);
LL = 0 ;                      % initialize log likelihood
repa = 0;
prev = -1;
% main loop
for t = 1:NTrials
    E = zeros(NStates,NActions); % initialize Eligibility traces
    S = 1;  % first we are in the top level
     
    % stop if trial was missed
    if (choice1(t) == 0 || choice2(t) == 0)
        continue
    end
    
    if (choice1(t) == prev)
        repa = 1;
    else
        repa = 0;
    end
    
    prev = choice1(t);

    % first level choice likelihood
    
    LL = LL + beta1*(Qhybrid(S,choice1(t)) + p * repa) - logsumexp(beta1*(Qhybrid(S,:) + p * repa ));
  
    % learning at first level
    
    if choice1(t) == 1
        weight2 = 0.7;
        weight3 =0.3;
    else
        weight2 = 0.3;
        weight3 = 0.7;
    end
    
    PE = weight2 * max(Qbased(2,:)) + weight3 * max(Qbased(3,:)); % - Qbased(S,choice1(t));
    %TODO: split up action column based on weight2/weight3. check against
    %bellman equation from supplement
    Qbased = Qbased + eta1 * PE;
    
    E(S,choice1(t)) = 1;  % eligibility trace
    
    PE = Qfree(state(t),choice2(t)) - Qfree(S,choice1(t)); %SARSA

    Qfree(S,choice1(t)) = Qfree(S,choice1(t)) + eta1*PE*E(S,choice1(t));
    
    Qhybrid = (w) * Qbased + (1-w) * Qfree;
    % second level choice likelihood
    S = state(t);
    % stop if trial was missed
    if (choice2(t) == 0)
        continue
    end
    LL = LL + (beta2*Qhybrid(S,choice2(t)) - logsumexp(beta2*Qhybrid(S,:)));
    % learning at second level
    PE = money(t) - Qbased(S,choice2(t)) ;

    Qbased(S,choice2(t))  = Qbased(S,choice2(t))  + eta2 * PE; 
     
    
    E = lambda * E;      % first decay all eligibility traces
    E(S,choice2(t)) = 1;  % then update current eligibility trace
    
    PE = money(t) - Qfree(S,choice2(t));
    
    %Update 2nd level
    Qfree(S,choice2(t)) = Qfree(S,choice2(t)) + eta2*PE*E(S,choice2(t));
    

    %Update 1st level again
    Qfree(1,choice1(t)) = Qfree(1,choice1(t)) + eta1*PE*E(1,choice1(t));
    Qhybrid(S,choice2(t))  = Qfree(S,choice2(t));
end

% we are minimizing this function, so use minus LL

LL = -LL;
