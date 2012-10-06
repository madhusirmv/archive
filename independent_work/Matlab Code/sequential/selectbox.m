function [pos,buttontime] = selectbox(unt)

global keyleft keyright

if nargin == 0
  unt = Inf;
end

buttontime=0;

%clearkeys;
choices = [keyleft keyright];

pos=0; %the variable 'pos' specifies which slot has been selected
    
while KbCheck && (slicewrapper < unt);
end
  
while pos == 0 && (slicewrapper < unt)
	%WaitSecs(0.005);
	[key buttontime keycode] = KbCheck;
if (key & find(choices == find(keycode)))
		pos = find(choices==find(keycode));
end
end

end
