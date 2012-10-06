function animatebox(stimleft, stimright, pos, unt, window)

global leftpos rightpos boxypos animxpos animypos fposvect

leftposvect = [leftpos boxypos leftpos+200 boxypos+100];
rightposvect = [rightpos boxypos rightpos+200 boxypos+100];

% activate box
  
if pos==1
  Screen('DrawTexture',window,stimleft.act1,[],leftposvect);
  Screen('DrawTexture',window,stimright.deact,[],rightposvect);
elseif pos==2
  Screen('DrawTexture',window,stimleft.deact,[],leftposvect);
  Screen('DrawTexture',window,stimright.act1,[],rightposvect);
end
Screen('Flip',window);

% animate box moving into position ( 90ms)
onset = -0.015;
for i =1:6
  xpos = animxpos(i);
  ypos = animypos(i);
 
  %WaitSecs(0.015);
  if pos==1
    Screen('DrawTexture',window,stimright.deact,[],rightposvect);
    Screen('DrawTexture',window,stimleft.act1,[],leftposvect...
        -[-xpos ypos -xpos ypos]);
  elseif pos==2
    Screen('DrawTexture',window,stimleft.deact,[],leftposvect);
    Screen('DrawTexture',window,stimright.act1,[],rightposvect...
        -[xpos ypos xpos ypos]);
  end;
  onset = Screen('Flip',window,onset+0.015);
end

fposvect = leftposvect -[-animxpos(6) animypos(6) -animxpos(6) animypos(6)];

% then highlight the chosen box for a further fixed action-outcome time
% highlight is rapidly alternating between 2 highlighted slot images

% preload the two alternating frames into two framebuffers

%clearpict(2);
%clearpict(3);
%if pos==1
%  preparepict(stimleft.act2,2,xpos,ypos);
%  preparepict(stimleft.act1,3,xpos,ypos);
%elseif pos==2
%  preparepict(stimright.act2,2,xpos,ypos);
%  preparepict(stimright.act1,3,xpos,ypos);
%end
onset = -0.015;
i = 1;
while slicewrapper < unt
        
    u = [stimleft.act1 stimleft.act2;stimright.act1 stimright.act2];
    Screen('DrawTexture',window,u(pos,i),[],fposvect);
    if pos == 1
        Screen('DrawTexture',window,stimright.deact,[],rightposvect);
    elseif pos == 2
        Screen('DrawTexture',window,stimleft.deact,[],leftposvect);
    end
    onset = Screen('Flip',window,onset+0.025);
    
    if i == 1
        i = 2;
    elseif i == 2
        i = 1;
    end
    
    WaitSecs(0.2);
end

%for i = slicewrapper:unt
%  drawpict(mod(i,2) + 2); % alternate frames
%  waitwrapper(i);
%end

%clearpict(1);

if pos==1
  Screen('DrawTexture',window,stimleft.deact,[],fposvect);
elseif pos==2
  Screen('DrawTexture',window,stimright.deact,[],fposvect);
end
