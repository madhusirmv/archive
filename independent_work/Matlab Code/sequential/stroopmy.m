%%% stroop AS september 2009


close all
clear all

m= 2; %% practice trials proportion
n = 4; %%% trials proportion 
totaltrials = n*30*2; %%% 30*n 'times' trials, 2 blocks
practicetrials =12*m; %m*12;

HideCursor;

% initialise data vectors
trialtypepractice = zeros(practicetrials,1);
allanswers = zeros(totaltrials,1);         % response
answer = zeros(totaltrials,1);
RT = zeros (totaltrials,1);
trialtype = zeros(totaltrials,1);
errors = zeros(totaltrials,1);
RTs = zeros(totaltrials,1);
%data = [];


% load the functions
KbCheck;
WaitSecs(0.1);
GetSecs;

%enter subject details
name=input('Subjects initials? ','s');
number=input('Subjects number? ');

%% set up the screen

w = Screen('OpenWindow',0,[0 0 0],[0 0 1000 480]); %% [0 0 0] is black color
[xres,yres] = Screen('windowsize',w);
xcenter = xres/2; %%% set up the center of the screen
ycenter = yres/2;

Screen('TextFont',w,'Helvetica');
Screen('TextStyle',w,1);
wrap = 100;


%%%%timing
fixtime = 0.2; %%%%%%%% fixation cross time
ittime = 0.25; %%%%%%%%%%%intertrial time
feedbacktime = 0.5; %%%%%%%%feedback time (only for practice trials)

%response key codes

redkey = zeros(1,256); % coded letter b
redkey (1,57) = 1;% coded letter b, which is 5
bluekey = zeros(1,256); % coded letter n
bluekey (1,58) = 1;% coded letter n, which is 17
greenkey = zeros(1,256); % coded letter b
greenkey (1,59) = 1;% coded letter m, which is 16

%%%break
b = totaltrials/2;

%%%%%%%%%%%%%%%%%%%% create the matrix for the practice trial types, then randomize the order (shuffle) 

%%% wtih 9 simuli (three colors) - 50% congruent + 50% incongruent trials

trialtypepractice = [(ones(m*1,1));(2*ones(m*1,1));(3*ones(m*1,1));(4*ones(m*1,1));(5*ones(m*1,1));(6*ones(m*1,1));(7*ones(m*2,1));(8*ones(m*2,1));(9*ones(m*2,1))];

%%% with four stimuli (two colors)

%trialtypepractice =[(4*ones(4,1));(6*ones(4,1));(8*ones(4,1));(9*ones(4,1))];

%trialtypepractice = shuffle(trialtypepractice);   



%%%%%%%%%%% block 1&2 create the matrix for the trial types, then randomize the order (shuffle) 


%%%%%%%block 1 - 80%incongruent 20% congruent
%
%
%%% with 9 stimuli (three colors)
trialtypeb1 = [(ones(4*n,1));(2*ones(4*n,1));(3*ones(4*n,1));(4*ones(4*n,1));(5*ones(4*n,1));(6*ones(4*n,1));(7*ones(2*n,1));(8*ones(2*n,1));(9*ones(2*n,1))];


%% with fours stimuli (two colors)
%
%trialtypeb1 = [(4*ones(3*n,1));(6*ones(3*n,1));(8*ones(n,1));(9*ones(n,1))];



%%%%%%%block 2 - 20%congruent 80% incongruent    
%
%% with 9 stimuli (three colors)
trialtypeb2 = [(ones(n,1));(2*ones(n,1));(3*ones(n,1));(4*ones(n,1));(5*ones(n,1));(6*ones(n,1));(7*ones(8*n,1));(8*ones(8*n,1));(9*ones(8*n,1))];

%% with four stimuli (two colors)
%
%trialtypeb2 = [(4*ones(n,1));(6*ones(n,1));(8*ones(3*n,1));(9*ones(3*n,1))];

trialtypepractice = trialtypepractice(randperm(length(trialtypepractice)));
trialtypeb1 = trialtypeb1(randperm(length(trialtypeb1)));
trialtypeb2 = trialtypeb2(randperm(length(trialtypeb2)));

%%condition

condition = randi(2); 


  if condition == 1; trialtype = [trialtypeb1;trialtypeb2];
      
  elseif condition ==2; trialtype = [trialtypeb2;trialtypeb1];
  end

  
 %%%Practice trials & instructions

Screen('TextSize', w, 20); %% font size

DrawFormattedText (w, ['Press any key to start.'],'center', 'center',[256 256 256]);% [window, text, horizontal, vertical, color white]
Screen('Flip',w);
KbWait([],2);

DrawFormattedText (w, ['Task 1. Instructions. ' '\n\n'...
'Please focus on the cross in the middle of the screen. When the coloured word appears, you will need to press the key on the keyboard that corresponds to the colour of the word ignoring its meaning. You need to respond as accurate and quickly as you can.'...
'\n\n' 'In the practise trials you will receive the feedback if youve given a correct response.' '\n\n' 'Press any key to start the practise trials.'],'center', 'center',[256 256 256],wrap);% [window, text, horizontal, vertical, color white]
Screen('Flip',w);
KbWait([],2);



%%% practice trials


for trial = 1:practicetrials;
    
    Screen('TextSize', w, 34); %% font size
    
    %FIXATION CROSS
    
    draw_a_cross(w);
    
 Waitsecs(fixtime); 
 Screen('Flip',w);
  
   
 
   
   %% words that are presented - stimuli
    
 i = trialtypepractice(trial);
 
   if i == 1; 
       DrawFormattedText (w, ['RED'],'center', ycenter,[0 256 0]);% [window, text, horizontal, vertical, color green]

     elseif i == 2;  
      
      DrawFormattedText (w, ['RED'],'center', ycenter,[0 0 256]);%%%%%%%% color blue
         
      elseif i == 3;
       
        DrawFormattedText (w, ['BLUE'],'center', ycenter,[256 0 0]);%%%%%%% color red
    
   elseif  i == 4;
        DrawFormattedText (w, ['BLUE'],'center', ycenter,[0 256 0]);%%%%% green
    
    
    elseif i == 5;
        DrawFormattedText (w, ['GREEN'],'center', ycenter,[256 0 0]);%%%%%%% color red
    
    
    elseif i == 6;
        DrawFormattedText (w, ['GREEN'],'center', ycenter,[0 0 256]);%%%%%%%% color blue
    
 
    elseif i == 7;
        DrawFormattedText (w, ['RED'],'center', ycenter,[256 0 0]);%%%%%%% color red
        
    elseif i == 8;
        DrawFormattedText (w, ['GREEN'],'center', ycenter,[0 256 0]);%%%%% green
    
   
    elseif i == 9;
        DrawFormattedText (w, ['BLUE'],'center', ycenter,[0 0 256]);%%%%%%%% color blue
    
   else
       DrawFormattedText (w, ['error'],'center', ycenter,[256 0 0]);%%%%%%% color red  
       
   end
  Screen('Flip',w);       
   
   KbWait([], 2);
   
    %% record the response of the participant


  [keyIsDown, secs, keyCode] = KbCheck;  %%% get keyresponse and time of the response (is not recorded here)
  
Screen('Flip',w); 

if keyCode==redkey; %%%%%% identify correct response
    
    answer = 1;

elseif keyCode==bluekey;
    
    answer = 2;
    
elseif keyCode==greenkey;
    
    answer=3;
    
else
    answer=0;

end


%%% check if the answer is correct

if answer==1 && i==3;
    error=0;
elseif answer==1 && i==5;
    error=0;
elseif answer==1 && i==7;
    error=0;
elseif answer==2 && i==2;
    error=0;
elseif answer==2 && i==6;
    error=0;
elseif answer==2 && i==9;
    error=0;
elseif answer==3 && i==1;
    error=0;
elseif answer==3 && i==4;
    error=0;
elseif answer==3 && i==8;
    error=0;
    
else
    
    error=1;
    
end
  

%%% show feedback



%% correct!!! incorrect!!!

if error==0;
    
Screen('TextSize', w, 20); %% font size    
DrawFormattedText (w, ['CORRECT!'],'center', ycenter,[256 256 256]);%%%%%%% white

else 
    Screen('TextSize', w, 20); %% font size
    DrawFormattedText (w, ['INCORRECT!'],'center', ycenter,[256 256 256]);%%%%%%% white
end
    Screen('Flip',w);

  WaitSecs(feedbacktime); %% time of showing the feedback

  Screen('Flip',w);

% intertrial interval
w;
WaitSecs(ittime); 
Screen('Flip',w);

%%%%%%%%%%%%%

 %RTs(trial,1) = RT;
    
%errors(trial,1) = error;

%allanswers(trial,1) = answer;

end


Screen('TextSize', w, 20); %% font size

DrawFormattedText (w, ['The practice trials are over.' '\n\n' 'Now you will take part in the experimental task. It will be the same as the practice trials except that you will receive no feedback. There will be two sessions and you will have an opportunity to take a break in the middle.' '\n\n'  'Remember, you need to respond only to the color of the word, as accurate and quick as you can.' '\n\n' 'If you have any questions about the task, you need to ask the experimenter now.' '\n\n' 'Press any key when you are ready to start the main task.'],'center', 'center',[256 256 256],wrap);% [window, text, horizontal, vertical, color white]
Screen('Flip',w);
KbWait([],2);
Screen('Flip',w);

%%% experimental loop

for trial = 1:totaltrials
   
%%%%%break%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if find(trial==b);
Screen('TextSize', w, 20); %% font size
DrawFormattedText (w, ['You can take a break now. Press any key when you are ready to continue the task.'],'center', 'center',[256 256 256]);%%%%%%% white
Screen('Flip',w);   
KbWait([], 2);
Screen('Flip',w);       
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   Screen('TextSize', w, 34); %% font size
    
   %FIXATION CROSS
    
   draw_a_cross(w); %%  function

     Waitsecs(fixtime); 

   Screen('Flip',w); 
   
  %% words that are presented - stimuli
   
    
 i = trialtype(trial);
 
   if i == 1;
     
    DrawFormattedText (w, ['RED'],'center', ycenter,[0 256 0]);% [window, text, horizontal, vertical, color green]

   elseif i == 2;
         
      DrawFormattedText (w, ['RED'],'center', ycenter,[0 0 256]);%%%%%%%% color blue
    
    elseif i == 3;
       
        DrawFormattedText (w, ['BLUE'],'center', ycenter,[256 0 0]);%%%%%%% color red
    
   elseif    i == 4;
        DrawFormattedText (w, ['BLUE'],'center', ycenter,[0 256 0]);%%%%% green
    
    
    elseif i == 5;
        DrawFormattedText (w, ['GREEN'],'center', ycenter,[256 0 0]);%%%%%%% color red
    
    
    elseif i == 6;
        DrawFormattedText (w, ['GREEN'],'center', ycenter,[0 0 256]);%%%%%%%% color blue
    
 
    elseif i == 7;
       DrawFormattedText (w, ['RED'],'center', ycenter,[256 0 0]);%%%%%%% color red
        
    elseif i == 8;
        DrawFormattedText (w, ['GREEN'],'center', ycenter,[0 256 0]);%%%%% green
    
   
    elseif i == 9;
        DrawFormattedText (w, ['BLUE'],'center', ycenter,[0 0 256]);%%%%%%%% color blue
    
   else
       DrawFormattedText (w, ['error'],'center', ycenter,[256 0 0]);%%%%%%% color red
       
    
       
   end
  [vtime startp]=Screen('Flip',w);   %%%%get the time when the stimuli is presented = startp
  
  
 
   [endp KeyCode] = KbWait([], 2);   %%%%%%%%%%% get time when the button was pressed plus the keycode
  
    %% record the response of the participant

  RT = endp-startp;  %%% calculate the RT


Screen('Flip',w);

  
if keyCode==redkey;
    
    answer = 1;

elseif keyCode==bluekey;
    
    answer = 2;
    
elseif keyCode==greenkey;
    
    answer=3;
    
else
    answer=0;

end;

%%% check if the answer is correct

if answer==1 && i==3;
    error=0;
elseif answer==1 && i==5;
    error=0;
elseif answer==1 && i==7;
    error=0;
elseif answer==2 && i==2;
    error=0;
elseif answer==2 && i==6;
    error=0;
elseif answer==2 && i==9;
    error=0;
elseif answer==3 && i==1;
    error=0;
elseif answer==3 && i==4;
    error=0;
elseif answer==3 && i==8;
    error=0;
    
else
    
    error=1;
    
end
   % intertrial interval
  w;
WaitSecs(ittime); 
Screen('Flip',w);

RTs(trial,1) = RT;
    
errors(trial,1) = error;

allanswers(trial,1) = answer; 

end

Screen('Flip',w);  

Screen('TextSize', w, 20); %% font size
DrawFormattedText (w, ['You have completed the first task. Thank you!' '\n\n' 'Press any key to continue.'],'center', 'center',[256 256 256]);%%%%%%% white
   
Screen('Flip',w);       
   
KbWait([], 2); 

Screen('Close',w);

% record the data into the file

rawdata = [trialtype, errors, RTs, allanswers]; %%% the data in the order of trials as they were presented to a participant
data = [];
datab1 = [];
datab2 = [];

if condition ==1; 
    datab1 = rawdata(1:totaltrials/2,:); 
    datab2 = rawdata((totaltrials/2+1):totaltrials,:);
   
    
elseif condition ==2;
    datab1 = rawdata((totaltrials/2+1):totaltrials,:); 
    datab2 =  rawdata(1:totaltrials/2,:);

    
end

data = [datab1; datab2];  %%% data reorderd, first half of trials is first block, second half of trials is second block


%% get the  results - mean RT and percent/correct for each block and type
%% of trials. last var is the percentage of "spoiled" trials, button pressed either less
%% then 100ms, or more then 5 sec  - discarded from all other results. 

RTb1incongt= [];
RTb1congt= [];
RTb2incongt= [];
RTb2congt= [];

correctb1incongt= [];%%% proportion of correct responses
correctb1congt= [];
correctb2incongt= [];
correctb2congt= [];

for j=1:length(datab1(:,1));
   if datab1(j,1)<7 && datab1(j,2)==0 && datab1(j,3)<5 && datab1(j,3)>0.1; %%% block 1 incongruent trials, spoiled excluded
       RTb1incongt = [RTb1incongt datab1(j,3)];
       correctb1incongt= [correctb1incongt datab1(j,2)];
      
   end
end
        
    for j=1:length(datab1(:,1));
   if datab1(j,1)>6 && datab1(j,2)==0 && datab1(j,3)<5 && datab1(j,3)>0.1; %%% block 1 congruent trials, spoiled excluded
       RTb1congt = [RTb1congt datab1(j,3)];
       correctb1congt= [correctb1congt datab1(j,2)];
     
   end
    end


for j=1:length(datab2(:,1));
   if datab2(j,1)<7 && datab2(j,2)==0 && datab2(j,3)<5 && datab2(j,3)>0.1; %%% block 2 incongruent trials, spoiled excluded
       RTb2incongt = [RTb2incongt datab2(j,3)];
       correctb2incongt= [correctb2incongt datab2(j,2)];
        
   end
end

     
   for j=1:length(datab2(:,1));
   if datab2(j,1)>6 && datab2(j,2)==0 && datab2(j,3)<5 && datab2(j,3)>0.1; %%% block 2 congruent trials, spoiled excluded
       RTb2congt = [RTb2congt datab2(j,3)];
       correctb2congt= [correctb2congt datab2(j,2)];
        
   end
   end
 
  for j=1:length(data(:,1));   %%%% percent of spoiled trials
      if data(j,3)<5 && data(j,3)>0.1;
          spoiledtrials = data(:,1); 
          spoiledtrials = length(spoiledtrials); 
          spoiledtrials = (spoiledtrials*100)*totaltrials;
      end
  end
  %%%  
%%  proportion of correct of each type of trial

 correctb1incongt = length(correctb1incongt);   
 correctb1incongt = (correctb1incongt*100)/(24*n);
 correctb1congt = length(correctb1congt);
 correctb1congt = (correctb1congt*100)/(6*n);
 correctb2incongt = length(correctb2incongt);
 correctb2incongt = (correctb2incongt*100)/(6*n);
 correctb2congt = length(correctb2congt);
 correctb2congt = (correctb2congt*100)/(24*n);
   
results = [number mean(RTb1congt) mean(RTb1incongt) mean(RTb2congt) mean(RTb2incongt) correctb1incongt correctb1congt correctb2incongt correctb2congt spoiledtrials];


%% write the files

dlmwrite ('stroopresults.txt', results, '-append') 
dlmwrite (['_',num2str(number), name,'_',num2str(condition)], rawdata) 






