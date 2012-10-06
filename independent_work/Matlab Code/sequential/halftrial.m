function [choice, rt, ons_sl, ons_ms, ch_sl, ch_ms, pos, stimleft,stimright] = halftrial(pix,swap,window,unt)

global leftpos rightpos boxypos choicetime isitime moneytime ititime;

% run half a trial, ie one state

% set up pictures, swapping sides accoridng to swap

stimleft = pix(swap+1);
stimright = pix(~swap+1);

% prepare pictures - old & busted

%preparepict(stimleft.norm,1,leftpos,boxypos);

%preparepict(stimright.norm,1,rightpos,boxypos);

% prepare pictures - new hotness

Screen('DrawTexture',window,stimleft.norm,[],[leftpos boxypos leftpos+200 boxypos+100]);
Screen('DrawTexture',window,stimright.norm,[],[rightpos boxypos rightpos+200 boxypos+100]);

[ons_sl, ons_ms] = slicewrapper;

if (nargin > 3)
  % wait out ITI or initial slicewait  
  [ons_sl, ons_ms] = waitwrapper(ons_sl + ititime);
%else
%  [ons_sl, ons_ms] = slicewrapper;
end

%display boxes, and record the time as t0

%t0 = drawpict(1);

t0 = screen('Flip',window);

% get a keystroke

[pos,t1] = selectbox(ons_sl + choicetime);  

% timed out

if ~pos
  % spoiled trial

  Screen('DrawTexture',window,stimleft.spoiled,[],[leftpos boxypos leftpos+200 boxypos+100]);
  Screen('DrawTexture',window,stimright.spoiled,[],[rightpos boxypos rightpos+200 boxypos+100]);
  Screen('Flip',window);
  waitwrapper(ons_sl + choicetime + moneytime);

  rt = 0;
  choice = 0;
  ch_sl = 0;
  ch_ms = 0;
else
  rt = t1 - t0;
  choice = xor((pos-1), swap)+1; % record choice accounting for side swap
  [ch_sl, ch_ms] = slicewrapper; % get slice onset times for choice

  % animate the box
  
  animatebox(stimleft, stimright, pos, ch_sl + isitime,window);
end
