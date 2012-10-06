function LL = rllik_hybrid(eta1, eta2, beta1, beta2, lambda, w , p, state,choice1,choice2,money)
% LL = rllik(eta,beta,lambda,state,choice1,choice2,money)
%
% output: 
% LL - the log likelihood of the data
% input:
% eta1/2    - learning rate, first level/second level
% beta1/2   - softmax inverse temperature, first level/second level
% lambda    - eligibility trace decay rat (set to 0 to get TD(0) without eligibility traces)
% state     - 1 is the top level, 2 and 3 are the bottom level
% choice1   - the choice at the top level -- 1 or 2 (0 for missed trials)
% choice2   - the choice at the bottom level -- 1 or 2 (0 for missed trials)
% money     - amount won (1 or 0)
% w         - percent model free/model based
% p         - weighting  for consecutive identical first stage choices

NStates = 3;
NActions = 2;
NTrials = length(choice1);

Qfree = zeros(NStates,NActions); % initialize Qfree values to 0
Qbased = zeros(NStates,NActions); % initialize Qbased values to 0
Qhybrid = zeros(NStates,NActions);
LL = 0 ;                      % initialize log likelihood
prev = 0;
% main loop
for t = 1:NTrials
    E = zeros(NStates,NActions); % initialize Eligibility traces
    repa = zeros(1,NActions);
    %first we are in the top level
    S = 1;
    
    % stop if trial was missed
    if (choice1(t) == 0 || choice2(t) == 0)
        continue
    end
    
    other = 0;
    if choice1(t) == 1
        other = 2;
    end
    if choice1(t) == 2
        other =1;
    end
    if other == 0
        fprintf('bad first level choice, choice = %d\n', choice1(t))
        continue
    end

    
    %assign p
    %TODO: how to deal with choices that were zero?
    if t>1 
        if choice1(t-1) ~= 0
            repa(1, choice1(t-1)) = 1;
            %prev = last good choice
            prev = choice1(t-1);
        else
            repa(1, prev) = 1;
        end
    end
    

    % first level choice likelihood
    LL = LL + beta1*(Qhybrid(S,choice1(t)) + p * repa(1, choice1(t))) - logsumexp(beta1*(Qhybrid(S,:) + p * repa ));
        
    %initialize eligibility trace
    E(S,choice1(t)) = 1;
    
    %first level model free
    PE = Qfree(state(t),choice2(t)) - Qfree(S,choice1(t)); %SARSA
    Qfree(S,choice1(t)) = Qfree(S,choice1(t)) + eta1*PE*E(S,choice1(t));
    
    % second level model free
    S = state(t); 
    E = lambda * E;      % first decay all eligibility traces
    E(S,choice2(t)) = 1;  % then update current eligibility trace
    PE = money(t) - Qfree(S,choice2(t));
    
    %Update second level model free
    Qfree(S,choice2(t)) = Qfree(S,choice2(t)) + eta2*PE*E(S,choice2(t));
    
    %Update 1st level again model free
    Qfree(1,choice1(t)) = Qfree(1,choice1(t)) + eta1*PE*E(1,choice1(t));
    
    % learning at second level model based
    S = state(t); 
    PE = money(t) - Qbased(S,choice2(t)) ;
    
    %Update second level model based
    Qbased(S,choice2(t))  = Qbased(S,choice2(t))  + eta2 * PE; 
    
    %initialize count parameters
    left = 0;
    right = 0;
 
    S = 1;  % we are in the top level
     
    %determine which transition occurs more frequently, and thus receives
    %the higher weighting
    for i = 1:t
        if choice1(i) == 1 && state(i) == 2
            left = left + 1;
        end
        if choice1(i) == 2 && state(i) == 3
            left = left + 1;
        end
        if choice1(i) == 1 && state(i) == 3
            right = right + 1;
        end
        if choice1(i) == 2 && state(i) == 2
            right = right + 1;
        end
    end
    
    %assign weighting based on most frequent choice
    if left > right
        weight2 = 0.7;
        weight3 =0.3;
    else
        weight2 = 0.3;
        weight3 = 0.7;
    end
    
    %first level model based
    Qbased(1,1) = weight2 * max(Qbased(2,:)) + weight3 * max(Qbased(3,:));
	Qbased(1,2) = weight3 * max(Qbased(2,:)) + weight2 * max(Qbased(3,:));
    
    %first level hybrid update
    Qhybrid(1,choice1(t)) = (w) * Qbased(1,choice1(t)) + (1-w) * Qfree(1,choice1(t));
    Qhybrid(1,other) = (w) * Qbased(1,other) + (1-w) * Qfree(1,other);
        
    % second level choice likelihood
    LL = LL + (beta2*Qhybrid(S,choice2(t)) - logsumexp(beta2*Qhybrid(S,:)));
    
    %second level hybrid update
    Qhybrid(S,choice2(t))  = Qbased(S,choice2(t));
    
end

% we are minimizing this function, so use minus LL

LL = -LL;