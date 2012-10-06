function [sl,ms] = slicewrapper()

global inmri starttime

if inmri
	[sl,ms] = getslice(1);
else
	ms = 1000*GetSecs-starttime;
	sl = floor((1000*GetSecs-starttime) / 90);
end
end	
