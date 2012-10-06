% make sure screen is working for sequential choice expt
% ND, October 2006

clear all

% specify the task parameters
global leftpos rightpos boxypos moneyypos animxpos animypos moneytime ...
    isitime ititime choicetime moneypic losepic inmri keyleft keyright;

totaltrials=20;    %total number of trials in the task
transprob = .7;    % probability of 'correct' transition

leftpos = -125;
rightpos = 125;
boxypos = 0;

moneyypos = 0;

animxpos = 100:-20:0;
animypos = 20:20:150;

moneytime = round(1500 / 90);
isitime = round(3000 / 90);
ititime = 0;
choicetime = Inf;

inmri = 0;  % set to 1 to time everything to slices

% right handed button box
keyleft = 80; %[5]
keyright = 81;%[6]

% create iti jitter matrix, mean 18 slices

% configure cogent a=settings
config_display(1,1,[0.4 0.4 0.4],[1 1 1], 'Arial', 20, 3)
config_keyboard(100,5,'exclusive' )
if (inmri)
    config_serial(1);
end
cgloadlib

start_cogent;

% Load the figures

s(1,1).norm=loadpict('tut/stim1.png');
s(1,1).deact=loadpict('tut/stim1-d.png');
s(1,1).act1=loadpict('tut/stim1-a1.png');
s(1,1).act2=loadpict('tut/stim1-a2.png');
s(1,1).spoiled=loadpict('tut/stim1-s.png');

s(1,2).norm=loadpict('tut/stim2.png');
s(1,2).deact=loadpict('tut/stim2-d.png');
s(1,2).act1=loadpict('tut/stim2-a1.png');
s(1,2).act2=loadpict('tut/stim2-a2.png');
s(1,2).spoiled=loadpict('tut/stim2-s.png');

moneypic = loadpict('behav/money.png');
losepic = loadpict('behav/nothing.png');

slicewait = time / 90;

for trial = 1:5
  clearpict(1);
  drawpict(1);

  halftrial(s(1,:), mod(trial,2));
    
  drawoutcome(mod(trial,2));

  clearpict(1);
  drawpict(1);
  wait(2000);
end

stop_cogent
