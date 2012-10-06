function [sl,ms] = waitwrapper(unt)

global inmri starttime

if inmri
	[sl,ms] = waitslice(1,unt);
else
	while (GetSecs*1000 - starttime) < unt*90;
    end
	[sl,ms] = slicewrapper;
end