function [ ] = plotModelFits( ntrials, reps, trueEta, trueBeta )
% Repeats a Model fit 'reps' times and plots results against true values
    
    hold off;
    avg = zeros(2);
    plot(trueEta, trueBeta, 'rx');
    for i = 1:reps
        fit = ModelFitDriverBandit(ntrials);
        hold on
        avg(1) = avg(1) + fit(2);
        avg(2) = avg(2) + fit(3);
        plot(fit(2), fit(3), 'bo');
    end
    plot(avg(1)/reps, avg(2)/reps, 'gx');

end

