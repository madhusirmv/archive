% Negative Log Likelihood Function - Door Reward Based
% Karin Tsai - August 2009
% Carlos Diuk - July 2010

function [cas_ll, deriv] = loglikrew(dooreta, doorbeta, ...
    n, doorchoices, doorrewards, prior, doorchoicetrial)

    cas_ll = 0;

    % initialize derivatives
    dDoorEta = 0;
    dDoorBeta = 0;
    dDoorV = zeros(2, 1);

    doorvals = zeros(2, 1);

    for j = 1:n

        % door updates
        if (~isnan(doorchoices(j)))

            % term for organizing
            ebv = exp(doorbeta.*doorvals);

            % likelihood of door choice
            if(doorchoicetrial(j))
                cas_ll=cas_ll + doorbeta*doorvals(doorchoices(j)) - ...
                    log(sum(ebv));
                
                if (nargout == 2)
                    % update door beta derivative
                    dDoorBeta = dDoorBeta + doorvals(doorchoices(j)) - ...
                        sum(doorvals.*ebv)/sum(ebv);
                    
                    % update door eta derivative
                    dDoorEta = dDoorEta + doorbeta*dDoorV(doorchoices(j)) - ...
                        sum(doorbeta.*ebv.*dDoorV)/sum(ebv);
                    
                    % update derivative value wrt eta
                    dDoorV(doorchoices(j)) = (1-dooreta)*dDoorV(doorchoices(j)) + ...
                        doorrewards(j) - doorvals(doorchoices(j));
                end
            end
            
            % update door
            doorvals(doorchoices(j)) = doorvals(doorchoices(j)) + ...
                dooreta*(doorrewards(j) - doorvals(doorchoices(j)));
        end
    end

    if (prior)
        b1 = 2; b2 = 2;
        g1 = 2; g2 = 3;
        dep = log(betapdf(dooreta, b1, b2)); % log door eta prior using beta distribution
        dbp = log(gampdf(doorbeta, g1, g2)); % log beta prior using gamma distribution
        cas_ll = -(cas_ll + dep + dbp);
        
        % alter derivatives accordingly
        dDoorEta = dDoorEta + ((b1-1)./dooreta - (b2-1)./(1-dooreta));
        dDoorBeta = dDoorBeta + ((g1-1)./doorbeta - 1/g2);
    else
        cas_ll = -cas_ll;
    end

    dDoorEta = -dDoorEta;
    dDoorBeta = -dDoorBeta;

    deriv = [dDoorEta, dDoorBeta];

end