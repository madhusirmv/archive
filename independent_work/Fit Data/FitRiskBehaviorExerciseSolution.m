function [lik,derv] = FitRiskBehaviorExercise(TrialType,CSchosen,Rewards,eta,beta,kappa)
% fprintf('Called with eta=%3.4f, beta = %3.4f, kappa = %3.4f \n',eta, beta, kappa) % DEBUG

% Find the log likelihood of the choice data under two different models (TD and RSTD) with learning rate
% eta, softmax temperature(s) beta and risk adjustment k (for TD model this is always 0)
% Outputs: 
% Lik = - log likelihood of the data
% derv = derivatives of the likelihood with respect to the different model parameters;

Nsub  = length(TrialType(:,1)); % number of subjects to fit
Nsess = length(beta);           % number of sessions to fit separately

% initializing the partial derivatives
dLdBeta  = zeros(1,Nsess); 
dLdEta   = 0; 
dLdKappa = 0; 
liks     = zeros(Nsess,Nsub);   % log likelihoods for each subject and each session

CS_num = [1 0;2 0;3 0;4 0;5 0;1 2;2 3;1 3;2 4;5 1;4 5]; % The CSs used for each trial type

if (Nsess == 3)                 % use a different beta for each session
    Sess = [1,71,141,211];      % the first trial of each session
else
    Sess = [1,211];             % treat all as one session
end

for subj = 1:Nsub               % we may be fitting more than one subject
    V = [2 2 4 0 0];                  % start with initial values
    dVdEta   = zeros(1,5);      % partial derivatives
    dVdKappa = zeros(1,5);
    
    for s = 1:Nsess             % s = session number
        for t = Sess(s):Sess(s+1)-1  % t = trial number
            
            % the chosen stimulus (1 or 2 or 3 or 4 or 5)
            c = CSchosen(subj,t);
            
            if ~isnan(c)             % this was a valid trial (missed trials: c = NaN)
                
                if (TrialType(subj,t)>5) % this was a choice trial
                    
                    % the other (nonchosen) stimulus (also 1 to 5)
                    n = sum(CS_num(TrialType(subj,t),:)) - c; 
                    % fprintf('TrialType %d, Chosen %d (value %3.2f), not chosen %d (value %3.2f)\n',TrialType(subj,t),c,V(c),n,V(n));
                    
                    % adding this choice to the log likelihood
                    liks(s,subj) = liks(s,subj) + beta(s)*V(c) - log(sum(exp(beta(s).*V([c,n]))));
                   
                    if (nargout == 2) % we were called by the optimizer and asked for derivatives as well
                        % keeping track of how this would be affected by changing any one of the (relevant) model parms
                        p = exp(beta(s)*V(c))/sum(exp(beta(s).*V([c,n])));
                        dLdBeta(s)     = dLdBeta(s) + (1-p)*(V(c) - V(n));
                        dLdEta         = dLdEta + beta(s)*(1-p)*(dVdEta(c)-dVdEta(n))';
                        dLdKappa       = dLdKappa + beta(s)*(1-p)*(dVdKappa(c)-dVdKappa(n));
                    end
                end
                
                % updating the value of the chosen stimulus according to the reward received (on choice as well as single trials)
                
                PE = Rewards(subj,t) - V(c);
                V(c) = V(c) + eta(1)*PE*(1-sign(PE)*kappa); % using variance adjusted TD if asked
                
                if (nargout == 2)
                    % keeping track of the derivatives of this value wrt model parameters
                    hlp = 1-eta+eta*kappa*sign(PE);
                    dVdEta(c) = dVdEta(c)*hlp + PE - kappa*abs(PE);
                    dVdKappa(c) = dVdKappa(c)*hlp - eta*abs(PE); 
                end
                % sprintf('trial %d, type %d, CS chosen %d, Rewards %d, new value %3.2f',j,TrialType(subj,j),CSchosen(subj,j),Rewards(subj,j),V(CSchosen(subj,j)))
            end
        end
    end
end

lik  = -sum(sum(liks));  % so we can minimize the function rather than maximize

% putting a prior on Beta and Eta (so we are looking for the MAP and not the ML solution)
A = 2; B = 2; % parameters for the beta distribution
lik      = lik - sum(log(betapdf(eta,A,B)));  % the prior on eta is a beta distrbution
dLdEta   = dLdEta + ((A-1)./eta - (B-1)./(1-eta));
C = 2; D = 3; % parameters for the gamma distribution
lik      = lik - sum(log(gampdf(beta,C,D)));  % the prior on beta is a gamma distribution
dLdBeta  = dLdBeta + ((C-1)./beta - 1/D);

% Use either of the below depending on how many parameters are being optimized
derv = -[dLdEta dLdBeta];% dLdKappa];
%derv = -[dLdEta dLdBeta]; 