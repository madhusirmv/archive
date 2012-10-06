% tutorial for sequential choice task
% ND; modified by YN for NEU502
clear all

ptbpath = '/usr/local/matlab-R2011a/toolbox/Psychtoolbox/';

addpath([ptbpath '/PsychBasic']);
addpath([ptbpath '/PsychOneliners']);
addpath([ptbpath '/PsychPriority']);
addpath([ptbpath '/PsychJava']);
addpath([ptbpath '/PsychAlphaBlending']);
addpath([ptbpath '/PsychRects']);

HideCursor;

name=input('Subjects name ? ','s');
ListenChar(2);

% % configure cogent a=settings
% %config_display(1,1,[0.1 0.1 0.1],[1 1 1], 'Arial', 20, 3)
% config_display(1,1,[0.2 0.2 0.2],[1 1 1], 'Arial', 20, 3)
% config_log
% %config_keyboard(100,5,'exclusive' )
% config_keyboard(100,5,'exclusive' )
% cgloadlib

%set random number generator
rand('state',sum(100*clock));
% start_cogent;

%textxpos = 0;
%textypos = [-30, -50, -70, -90, -110, -130, -150, -170];

% specify the task parameters
global leftpos rightpos boxypos moneyxpos moneyypos animxpos animypos moneytime ...
    isitime ititime choicetime moneypic losepic inmri keyleft keyright starttime;

w = Screen('OpenWindow',0,[0 0 0]);

totaltrials= 10;    %total number of trials in the task
transprob = .7;    % probability of 'correct' transition

[xres,yres] = Screen('windowsize',w);
xcenter = xres/2;
ycenter = yres/2;

leftpos = xcenter-125-100;
rightpos = xcenter+125-100;
boxypos = ycenter-50-50;

leftposvect = [leftpos boxypos leftpos+200 boxypos+100];
rightposvect = [rightpos boxypos rightpos+200 boxypos+100];
posvect = [leftposvect; rightposvect];

moneyypos = ycenter-round(75/2);
moneyxpos = xcenter-round(75/2);

animxpos = 0:25:125;
animypos = 0:25:125;

moneytime = round(500 / 90);
isitime = round(500 / 90);
ititime = round(500 / 90);
truechoicetime = round(2000 / 90);

inmri = 0;

keyleft = KbName('u');
keyright = KbName('i');

ytext = round(3*yres/5);

% load payoffs

load tut/masterprob

% Load the figures

t(1,1).norm=imread('tut/stim1.png');
t(1,1).deact=imread('tut/stim1-d.png');
t(1,1).act1=imread('tut/stim1-a1.png');
t(1,1).act2=imread('tut/stim1-a2.png');
t(1,1).spoiled=imread('tut/stim1-s.png');

t(1,2).norm=imread('tut/stim2.png');
t(1,2).deact=imread('tut/stim2-d.png');
t(1,2).act1=imread('tut/stim2-a1.png');
t(1,2).act2=imread('tut/stim2-a2.png');
t(1,2).spoiled=imread('tut/stim2-s.png');

t(2,1).norm=imread('tut/stim3.png');
t(2,1).deact=imread('tut/stim3-d.png');
t(2,1).act1=imread('tut/stim3-a1.png');
t(2,1).act2=imread('tut/stim3-a2.png');
t(2,1).spoiled=imread('tut/stim3-s.png');

t(2,2).norm=imread('tut/stim4.png');
t(2,2).deact=imread('tut/stim4-d.png');
t(2,2).act1=imread('tut/stim4-a1.png');
t(2,2).act2=imread('tut/stim4-a2.png');
t(2,2).spoiled=imread('tut/stim4-s.png');

t(3,1).norm=imread('tut/stim5.png');
t(3,1).deact=imread('tut/stim5-d.png');
t(3,1).act1=imread('tut/stim5-a1.png');
t(3,1).act2=imread('tut/stim5-a2.png');
t(3,1).spoiled=imread('tut/stim5-s.png');

t(3,2).norm=imread('tut/stim6.png');
t(3,2).deact=imread('tut/stim6-d.png');
t(3,2).act1=imread('tut/stim6-a1.png');
t(3,2).act2=imread('tut/stim6-a2.png');
t(3,2).spoiled=imread('tut/stim6-s.png');

t(4,1).norm=imread('tut/stim7.png');
t(4,1).deact=imread('tut/stim7-d.png');
t(4,1).act1=imread('tut/stim7-a1.png');
t(4,1).act2=imread('tut/stim7-a2.png');
t(4,1).spoiled=imread('tut/stim7-s.png');

t(4,2).norm=imread('tut/stim8.png');
t(4,2).deact=imread('tut/stim8-d.png');
t(4,2).act1=imread('tut/stim8-a1.png');
t(4,2).act2=imread('tut/stim8-a2.png');
t(4,2).spoiled=imread('tut/stim8-s.png');

t(5,1).norm=imread('tut/stim9.png');
t(5,1).deact=imread('tut/stim9-d.png');
t(5,1).act1=imread('tut/stim9-a1.png');
t(5,1).act2=imread('tut/stim9-a2.png');
t(5,1).spoiled=imread('tut/stim9-s.png');

moneypic = imread('behav/money.png');
losepic = imread('behav/nothing.png');


for i = 1:5
     for j = 1:2 - (i==5)
         s(i,j).norm = Screen(w,'MakeTexture',t(i,j).norm);
         s(i,j).deact = Screen(w,'MakeTexture',t(i,j).deact);
         s(i,j).act1 = Screen(w,'MakeTexture',t(i,j).act1);
         s(i,j).act2 = Screen(w,'MakeTexture',t(i,j).act2);
         s(i,j).spoiled = Screen(w,'MakeTexture',t(i,j).spoiled);
     end
end
 
moneypic = Screen(w,'MakeTexture',moneypic);
losepic = Screen(w,'MakeTexture',losepic);

% initialise data vectors
choice1 = zeros(1,totaltrials);         % first level choice
choice2 = zeros(1,totaltrials);         % second level choice
state = zeros(1,totaltrials);           % second level state
pos1 = rand(1,totaltrials) > .5;        % positioning of first level boxes
pos2 = rand(1,totaltrials) > .5;        % positioning of second level boxes
rts1 = zeros(1,totaltrials);            % first level RT
rts2 = zeros(1,totaltrials);            % second level RT
money = zeros(1,totaltrials);           % win

Screen('TextFont',w,'Helvetica');
Screen('TextSize',w,20);
Screen('TextStyle',w,1);
Screen('TextColor',w,[255 255 255]);
wrap = 100;

starttime = GetSecs*1000;

% screen 1
DrawFormattedText(w,'Press any key to start the tutorial, and to continue from page to page.',...
    'center','center');
Screen('Flip',w);
KbWait([],2);

% screen 2
DrawFormattedText(w,'Your goal in this experiment is to win as much money as possible.','center','center');
Screen('Flip',w);
KbWait([],2);

% screen 3
Screen('DrawTexture',w,s(4,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(4,2).norm,[],rightposvect);
DrawFormattedText(w,'In the game, you will see pairs of boxes.  They are identified by a symbol and a color.  Your job is to choose one of them.','center',...
    round(ytext),[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 4
Screen('DrawTexture',w,s(4,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(4,2).norm,[],rightposvect);
DrawFormattedText(w,'Each of the first type of box we will consider has a certain chance of containing one quarter.  The aim is to find a box with a high chance of money, and choose it.'...
    ,'center',ytext,[],wrap);
Screen('Flip',w,[]);
KbWait([],2);

% screen 5
Screen('DrawTexture',w,s(4,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(4,2).norm,[],rightposvect);
DrawFormattedText(w,'You will select the box you want using the keyboard.  You select the left box by pressing U, and the right box by pressing I.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 6
Screen('DrawTexture',w,s(4,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(4,2).norm,[],rightposvect);
DrawFormattedText(w,['Practice selecting them now, using the U and I keys.  When you select a box, it will highlight.'...
    '\n\n' 'The tutorial will continue after 3 presses.'],'center',ytext,[],wrap);
Screen('Flip',w);


for t =1:3
   pos = selectbox(inf);
   xander = find((pos==[1 2])==0);
  for i = 1:5
    Screen('DrawTexture',w,s(4,pos).act1,[],posvect(pos,1:4));
    Screen('DrawTexture',w,s(4,xander).deact,[],posvect(xander,1:4));
    Screen('Flip',w);
    WaitSecs(0.1);
    Screen('DrawTexture',w,s(4,pos).act2,[],posvect(pos,1:4));
    Screen('DrawTexture',w,s(4,xander).deact,[],posvect(xander,1:4));
    Screen('Flip',w);
    WaitSecs(0.1);
  end
  if t ~= 4
  Screen('DrawTexture',w,s(4,1).norm,[],leftposvect);
  Screen('DrawTexture',w,s(4,2).norm,[],rightposvect);
  DrawFormattedText(w,'When you select a box, it will highlight.  Try another box.','center',ytext,[],wrap);          
  Screen('Flip',w);
  end
end

% screen 8
DrawFormattedText(w,'After a box is selected, you will find out whether you won a quarter or not.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 10
Screen('DrawTexture',w,s(5,1).norm,[],(leftposvect+rightposvect)/2 - [0 125 0 125]);
DrawFormattedText(w,'This is how wins are determined: Each time you select a box the computer flips a weighted coin to decide if you win.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(5,1).norm,[],(leftposvect+rightposvect)/2 - [0 125 0 125]);
DrawFormattedText(w,'For this box, you have a 60% chance of winning. Other boxes may be more or less, and you normally have to figure it out for yourself.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 15
Screen('DrawTexture',w,s(4,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(4,2).norm,[],rightposvect);
DrawFormattedText(w,'Each box is identified by its symbol and its color.  Each box will sometimes come up on the right...','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(4,2).norm,[],leftposvect);
Screen('DrawTexture',w,s(4,1).norm,[],rightposvect);
DrawFormattedText(w,'...and sometimes come up on the left.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(4,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(4,2).norm,[],rightposvect);
DrawFormattedText(w,'Which side a box appears on does not influence your chance of winning.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 15
DrawFormattedText(w,['Also, the chance a box contains money can change slowly over time.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 16
DrawFormattedText(w,'Because the boxes can slowly change, a box that starts out better, can turn worse later, or a worse one can turn better. So finding the box that is best requires continual learning.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 17
DrawFormattedText(w,'Boxes can also stay more or less the same, or change back and forth, or many other patterns.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
DrawFormattedText(w,'In fact, the change is completely unpredictable. But it is also slow.  So a box that is good now will probably be pretty good for a while.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 15
Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
Screen('DrawTexture',w,s(3,1).norm,[],leftposvect - [0 120 0 120]);
Screen('DrawTexture',w,s(3,2).norm,[],rightposvect - [0 120 0 120]);
DrawFormattedText(w,['You are almost ready to start the game.' '\n\n' 'But there is one more complication: more boxes.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
Screen('DrawTexture',w,s(3,1).norm,[],leftposvect - [0 120 0 120]);
Screen('DrawTexture',w,s(3,2).norm,[],rightposvect - [0 120 0 120]);
DrawFormattedText(w,'In particular, there are two pairs of boxes containing money.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 16
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,['There is also a third pair of boxes.  In the game, you start each trial by choosing between these two.' '\n\n'...
    'Rather than having some chance of giving you money, these have a chance of giving you either of the two pairs of money boxes...'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,'... which you then choose between to win money as before.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

choicetime = inf;

% screen 16
DrawFormattedText(w,'Try it now: Select a box with U or I','center',ytext,[],wrap);
halftrial(s(1,:),0,w);
DrawFormattedText(w,'These are boxes with a chance of containing money. Try selecting one.','center',ytext,[],wrap);
[choice a b c d e pos stimleft stimright] = halftrial(s(2,:),0,w);
drawoutcome(1,w,pos,stimleft,stimright);
DrawFormattedText(w,['You found a quarter.' '\n\n' 'Press any key to continue.'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 16
Screen('DrawTexture',w,s(1,1).act1,[],leftposvect);
Screen('DrawTexture',w,s(1,2).deact,[],rightposvect);
DrawFormattedText(w,['Just like the money boxes, these boxes are a bit unpredictable.' '\n\n'  'For instance, this one might give you the purple boxes about 7 times out of 10, and give you the turquoise boxes about 3 times out of 10.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 16
Screen('DrawTexture',w,s(1,1).deact,[],leftposvect);
Screen('DrawTexture',w,s(1,2).act1,[],rightposvect);
DrawFormattedText(w,'Whereas this one might give you the purple boxes about 3 times out of 10, and give you the turquoise boxes about 7 times out of 10.',...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(1,1).deact,[],leftposvect);
Screen('DrawTexture',w,s(1,2).act1,[],rightposvect);
DrawFormattedText(w,'If these were the chances and if the box with the most money were a turquoise one, then this box would be a better choice.'...
    ,'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(1,1).deact,[],leftposvect);
Screen('DrawTexture',w,s(1,2).act1,[],rightposvect);
DrawFormattedText(w,'Again, what matters is the box color and symbol, not what side it appears on.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 16
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,['Unlike the chances of finding money in the other boxes, the chances of these boxes leading to different colored money boxes do not change over time.' '\n\n' 'Of course, you will still have to figure out what they are.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 17
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,['Note that when you choose a purple or turquoise box, your chance of winning money depends only on its color and symbol, not which orange box you chose to get it.' '\n\n'...
    'The choice you make between the orange boxes is still important because it can help you get whichever pair of money boxes contains more money.  Of course, which boxes those are may change.'],...
'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 16
Screen('DrawTexture',w,s(2,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(2,2).norm,[],rightposvect);
Screen('DrawTexture',w,s(3,1).norm,[],leftposvect - [0 120 0 120]);
Screen('DrawTexture',w,s(3,2).norm,[],rightposvect - [0 120 0 120]);
DrawFormattedText(w,['This may all sound complicated, so lets review:' '\n\n' 'These boxes are two games of figuring out which one has a better chance of money.  And the chance of money is constantly changing.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,['On top of that game is another one of figuring out which box is better.  Except with these boxes you dont win money directly: you win the chance to win money in the other game.' '\n\n'...
    'A better box will take you to a game with a better chance of winning money.']...
    ,'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% screen 22
DrawFormattedText(w,['Lets put it all together into an example game.' '\n\n' 'In this practice, you won''t be winning real money.  You will do the task for 10 trials, which is about 2 minutes.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

% another screen
Screen('DrawTexture',w,s(1,1).norm,[],leftposvect);
Screen('DrawTexture',w,s(1,2).norm,[],rightposvect);
DrawFormattedText(w,'If you take too long making a choice, the trial will abort.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture',w,s(1,1).spoiled,[],leftposvect);
Screen('DrawTexture',w,s(1,2).spoiled,[],rightposvect);
DrawFormattedText(w,'In this case, you will see red Xs on the screen and a new trial will start.  Dont feel rushed, but please try to enter a choice on every trial.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);
DrawFormattedText(w,'Good luck! Remember that U selects left and I selects right.','center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

choicetime = truechoicetime;
% animypos = 20:20:150;
% boxypos = 0;

% main experimental loop

for trial = 1:totaltrials

  % first level

  [choice1(trial), rts1(trial)] = halftrial(s(1,:), pos1(trial),w);
  
  if ~choice1(trial) % spoiled
    Screen('Flip',w);
    WaitSecs(ititime * 90/1000); 
    continue;
  end
  
  % determine where we transition
  
  state(trial) = 2 + xor((rand > transprob),(choice1(trial)-1));

  % second level

  [choice2(trial), rts2(trial), c, d, e, pos, leftstim, rightstim] = halftrial(s(state(trial),:), pos2(trial),w);

  if ~choice2(trial) % spoiled
      Screen('Flip',w);
      WaitSecs(ititime * 90/1000); 
      continue;
  end
  
  % outcome
  money(trial) = rand < payoff(state(trial)-1,choice2(trial),trial);

  drawoutcome(money(trial),w,pos,leftstim,rightstim);
  
  Screen('Flip',w);
  WaitSecs(ititime * 90/1000);
end

DrawFormattedText(w,['That is the end of the practice game.' '\n\n'  'Press a key to see how you did...'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['You got '  num2str(sum(money)*0.25) ' dollars.'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['Okay, that is nearly the end of the tutorial!'...
    '\n\n' 'Here are a few helpful hints on how to play the game.'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['Hints:' '\n\n' 'The game is hard, so you will need to concentrate, but dont be afraid to trust your instincts.' '\n\n'...
    'Remember from which boxes you got money, because the boxes only change gradually they will probably stay similar in the short term, even though they will probably change in the long term.'...
    '\n\n' 'This is how the game involves skill as well as luck:  finding which boxes are currently best and following when they change.'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['Hints:' '\n\n' 'The first choice in the trial is also important, because it influences which color of money boxes you get and often one color will be better than the other.  So you can earn more money by figuring out which initial choices work better.'],...
    'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['Hints:' '\n\n' 'Remember, none of the boxes know what the others are doing.  Just because one box is poor does not mean any others have to be rich.' '\n\n' ...
    'Also, the way they change is not synchronized or patterned.  You dont have to bother looking for patterns such as:' '\n\n'...
    '* win-lose-win-lose' '\n' '* wins on turquoise following wins on purple' '\n' '* the best box moving predictably from one color to the next' '\n\n'...
    'The computer is not trying to catch you out or trick you.  Remember, it is a game of both skill and chance, so good luck!'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,['Finally:' '\n\n' 'You are playing against your classmates... Good luck in earning the most money!'],'center',ytext,[],wrap);
Screen('Flip',w);
KbWait([],2);

eval(['save ' [name '_' num2str(now*1000,9)] '_tutorial choice1 choice2 state pos1 pos2 money rts1 rts2'])
ShowCursor
ListenChar(0)
Screen('Close',w);
