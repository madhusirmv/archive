function [sl,ms] = drawoutcome(win,window,pos,stimleft,stimright)

global moneytime moneypic losepic moneyypos moneyxpos fposvect 

if pos==1
  Screen('DrawTexture',window,stimleft.deact,[],fposvect);
elseif pos==2
  Screen('DrawTexture',window,stimright.deact,[],fposvect);
end

if win
  Screen('DrawTexture',window,moneypic,[],[moneyxpos moneyypos moneyxpos+75 moneyypos+75]);
else
  Screen('DrawTexture',window,losepic,[],[moneyxpos moneyypos moneyxpos+75 moneyypos+75]);
end

[sl,ms] = slicewrapper;

Screen('Flip',window);
waitwrapper(sl + moneytime);
