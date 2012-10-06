% Model-Fitting Based on rewards when some trials are forced choices
% Carlos Diuk - July 2010, October 2011

function [] = CasinoModelFitWithForcedChoices(restart, isfMRI, EXPT)

% set iterations
iterations = 4;

% boundaries of the variables (eta and beta)
low = 1E-06;
lebeb = [low, low];
uebeb = [1-low, Inf];

% upper boundaries of inits
iuebeb = [1-low, 20];

% set random seed
rand('twister', sum(100*clock));

% retrieve data filenames
basedir = '../behData/';
if(~isfMRI)
    data = dir(strcat(basedir, 'behaviorCAS2_1*.mat'));
    nsubs = length(data);
    files = cell(nsubs, 1);
    for i = 1:nsubs
        files(i, :) = cellstr(data(i).name);
    end
else
    nsubs = length(EXPT.subjs);
    files = cell(nsubs, 1);
    for i = 1:nsubs
        fname=EXPT.SubjectName{EXPT.subjs(i)}(1:13);
        files(i, :) = cellstr(['behavior' fname '.mat']);
    end
end

target = strcat(basedir, 'fits_fmri/');
fn_fitsrew = 'fits-rew-forcedtrials_cas_ll.mat';
fn_fitsbet = 'fits-bet-forcedtrials.mat';
fn_fitsslots = 'fits-slots.mat';
fn_fitsslotpairs = 'fits-slotpairs.mat';
fn_fitstotalpoints = 'fits-totalpoints.mat';

if(restart)
%     delete(strcat(target, fn_fitsrew));
%     delete(strcat(target, fn_fitsbet));
%     delete(strcat(target, fn_fitsslots));
     delete(strcat(target, fn_fitsslotpairs));
%     delete(strcat(target, fn_fitstotalpoints));
end

% analyze each subject individually
for iter = 1:iterations
    
    % load previous bestfits matrix
    try
%         load(strcat(target, fn_fitsslots));
        load(strcat(target, fn_fitsslotpairs));
%         load(strcat(target, fn_fitsrew));
%         load(strcat(target, fn_fitsbet));
%         load(strcat(target, fn_fitstotalpoints));
    catch exception
        disp('Initializing rew to 0s');
        reweb = zeros(nsubs,3);
        rewebp = zeros(nsubs,3);
        beteb = zeros(nsubs,3);
        betebp = zeros(nsubs,3);
        slotseb = zeros(nsubs,3);
        slotpairseb_6arms = zeros(nsubs,3);
        slotpairseb_values = zeros(nsubs,3);
        totalpointseb = zeros(nsubs,3);
    end
    
    for i = 1:nsubs
        % random starting points
        initebeb = rand(1, length(lebeb)).*(iuebeb-lebeb) + lebeb;
        
        % load data file
        s = char(files(i));
        load(sprintf(strcat(basedir,'%s'), s));
        doorchoicetrial=is_instrumental;

        % rewebeb
        [params, likelihood] = fmincon(@(x) loglikrew(x(1), x(2), ...
            n, doorchoices, doorrewards, 0, doorchoicetrial), ...
            initebeb, [], [], [], [], lebeb, uebeb, [], optimset('maxfunevals', 10000, ...
            'maxiter', 10000, 'LargeScale', 'on', 'GradObj', 'on'));
        if (likelihood < reweb(i, 1) || reweb(i, 1)==0)
            fprintf(sprintf('Iteration %d - Changed - rewebeb, subject %d from %2.4f to %2.4f\n', ...
                iter, i, reweb(i, 1), likelihood));
            reweb(i, 1) = likelihood;
            reweb(i, 2) = params(1);
            reweb(i, 3) = params(2);
        end
        
        % rewebeb-p
        [params, likelihood] = fmincon(@(x) loglikrew(x(1), x(2), ...
            n, doorchoices, doorrewards, 1, doorchoicetrial), ...
            initebeb, [], [], [], [], lebeb, uebeb, [], optimset('maxfunevals', 10000, ...
            'maxiter', 10000, 'LargeScale', 'on', 'GradObj', 'on'));
        if (likelihood < rewebp(i, 1) || rewebp(i, 1)==0)
            fprintf(sprintf('Iteration %d - Changed - rewebebp, subject %d from %2.4f to %2.4f\n', ...
                iter, i, rewebp(i, 1), likelihood));
            rewebp(i, 1) = likelihood;
            rewebp(i, 2) = params(1);
            rewebp(i, 3) = params(2);
        end

        % slots
        [params, likelihood] = fmincon(@(x) loglik_slots(x(1), x(2), ...
            n, nslots, doorchoices, slotchoices, slotrewards, 0), ...
            initebeb, [], [], [], [], lebeb, uebeb, [], optimset('maxfunevals', 10000, ...
            'maxiter', 10000, 'LargeScale', 'on', 'GradObj', 'on'));
        if (likelihood < slotseb(i, 1) || slotseb(i, 1)==0)
            fprintf(sprintf('Iteration %d - Changed - Slots, subject %d from %2.4f to %2.4f\n', ...
                iter, i, slotseb(i, 1), likelihood));
            slotseb(i, 1) = likelihood;
            slotseb(i, 2) = params(1);
            slotseb(i, 3) = params(2);
        end

        % slot pairs 1: model where each casino has 6 pairs of slots, and
        % it's a 6-armed bandit with reward +/- 1 depending on casino
        % outcome.
        [params, likelihood] = fmincon(@(x) loglik_slotpairs_6arms(x(1), x(2), ...
            n, doorchoices, slotchoices, doorrewards, true), ...
            initebeb, [], [], [], [], lebeb, uebeb, [], optimset('maxfunevals', 10000, ...
            'maxiter', 10000, 'LargeScale', 'on', 'GradObj', 'on'));
        if (likelihood < slotpairseb_6arms(i, 1) || slotpairseb_6arms(i, 1)==0)
            fprintf(sprintf('Iteration %d - Changed - Slots 6arms, subject %d from %2.4f to %2.4f\n', ...
                iter, i, slotpairseb_6arms(i, 1), likelihood));
            slotpairseb_6arms(i, 1) = likelihood;
            slotpairseb_6arms(i, 2) = params(1);
            slotpairseb_6arms(i, 3) = params(2);
        end
        
        % slot pairs 2: model where each casino has 6 pairs of slots, but
        % the value of the pairs is computed as the sum of the values of
        % the slots. It is a TD-model, but easier to compare against 6-arms
        % model
        [params, likelihood] = fmincon(@(x) loglik_slotpairs_values(x(1), x(2), ...
            n, doorchoices, slotchoices, slotrewards, true), ...
            initebeb, [], [], [], [], lebeb, uebeb, [], optimset('maxfunevals', 10000, ...
            'maxiter', 10000, 'LargeScale', 'on', 'GradObj', 'on'));
        if (likelihood < slotpairseb_values(i, 1) || slotpairseb_values(i, 1)==0)
            fprintf(sprintf('Iteration %d - Changed - Slots values, subject %d from %2.4f to %2.4f\n', ...
                iter, i, slotpairseb_values(i, 1), likelihood));
            slotpairseb_values(i, 1) = likelihood;
            slotpairseb_values(i, 2) = params(1);
            slotpairseb_values(i, 3) = params(2);
        end
        
        % beteb
        [params, likelihood] = fmincon(@(x) loglikbet(x(1), x(2), ...
            n, doorchoices, betsoffered, 0, doorchoicetrial), ...
            initebeb, [], [], [], [], lebeb, uebeb, [], optimset('maxfunevals', 10000, ...
            'maxiter', 10000, 'LargeScale', 'on', 'GradObj', 'on'));
        if (likelihood < beteb(i, 1) || beteb(i, 1)==0)
            fprintf(sprintf('Iteration %d - Changed - betebeb, subject %d from %2.4f to %2.4f\n', ...
                iter, i, beteb(i, 1), likelihood));
            beteb(i, 1) = likelihood;
            beteb(i, 2) = params(1);
            beteb(i, 3) = params(2);
        end
        
        % beteb-p
        [params, likelihood] = fmincon(@(x) loglikbet(x(1), x(2), ...
            n, doorchoices, betsoffered, 1, doorchoicetrial), ...
            initebeb, [], [], [], [], lebeb, uebeb, [], optimset('maxfunevals', 10000, ...
            'maxiter', 10000, 'LargeScale', 'on', 'GradObj', 'on'));
        if (likelihood < betebp(i, 1) || betebp(i, 1)==0)
            fprintf(sprintf('Iteration %d - Changed - betebebp, subject %d from %2.4f to %2.4f\n', ...
                iter, i, betebp(i, 1), likelihood));
            betebp(i, 1) = likelihood;
            betebp(i, 2) = params(1);
            betebp(i, 3) = params(2);
        end

        % totalpointseb
        [params, likelihood] = fmincon(@(x) logliktotalpoints(x(1), x(2), ...
            n, doorchoices, slotrewards, 0, doorchoicetrial), ...
            initebeb, [], [], [], [], lebeb, uebeb, [], optimset('maxfunevals', 10000, ...
            'maxiter', 10000, 'LargeScale', 'on', 'GradObj', 'on'));
        if (likelihood < totalpointseb(i, 1) || totalpointseb(i, 1)==0)
            fprintf(sprintf('Iteration %d - Changed - totalpointseb, subject %d from %2.4f to %2.4f\n', ...
                iter, i, beteb(i, 1), likelihood));
            totalpointseb(i, 1) = likelihood;
            totalpointseb(i, 2) = params(1);
            totalpointseb(i, 3) = params(2);
        end
        
%         save(strcat(target, fn_fitsslots), 'slotseb');
        save(strcat(target, fn_fitsslotpairs), 'slotpairseb_6arms', 'slotpairseb_values');
%         save(strcat(target, fn_fitsrew), 'reweb', 'rewebp');
%         save(strcat(target, fn_fitsbet), 'beteb', 'betebp');
%         save(strcat(target, fn_fitstotalpoints), 'totalpointseb');
        
    end
end

end