%%%%%draw a cross function 

function draw_a_cross(w)
[xres,yres] = Screen('windowsize',w);
xcenter = xres/2;
ycenter = yres/2;
Screen('DrawLine', w, [256 256 256],xcenter+20,ycenter,xcenter+20,ycenter+40,2); 
    Screen('DrawLine', w, [256 256 256],xcenter,ycenter+20,xcenter+40,ycenter+20,2);
    Screen('Flip',w);
    
end

