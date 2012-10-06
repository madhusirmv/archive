rand('state',sum(100*clock));

% generate payoffs

totaltrials = 10000;

dsigma = .025;             % reward drift speed
payoff = .25 + rand(4,1) * .5;

for i = 2:totaltrials
  payoff(:,i) = payoff(:,i-1) + randn(4,1) * dsigma;
  payoff(find(payoff(:,i) > .75),i) = 1.5-payoff(find(payoff(:,i) > .75),i);
  payoff(find(payoff(:,i)  < .25),i) = .5-payoff(find(payoff(:,i) < .25),i);
end

