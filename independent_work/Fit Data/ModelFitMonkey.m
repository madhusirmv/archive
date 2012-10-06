function [BestFit] = ModelFitMonkey(data)
% data file is the matrix as sent by Jen. This function converts it to the
% right choice+rewards format and calls ModelFitDriver

% Expected format:
%   Fourth column indicates combined casino/slot choice.
%   40 = Bad casino, bad slot, rew=0
%   41 = Bad casino, good slot, rew=800
%   42 = Good casino, bad slot, rew = 0
%   43 = Good casino, good slot, rew = 2400

CSs = data(:,4)';
CSs = CSs(1:end-1); % There seems to be an extra row at the end.
CSs = CSs-39; % Convert choices to 1-4
Rew = Replace(CSs, 1, 0);
Rew = Replace(Rew, 2, (1/3));
Rew = Replace(Rew, 3, 0);
Rew = Replace(Rew, 4, 1.0);

BestFit=ModelFitDriver(CSs,Rew);
