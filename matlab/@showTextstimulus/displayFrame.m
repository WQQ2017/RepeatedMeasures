% DISPLAYFRAME - draw a frame (just the text)
% Do not call directly, will be called by runexperiment

function [thistrial,experimentdata,breakfromloop,thisstimulus] = displayFrame(thisstimulus,e,frame,thistrial,experimentdata)

breakfromloop = 0;
thetext = thisstimulus.text;

if ~isempty(experimentdata.vr) && experimentdata.vr.stereomode>0
    for k=0:1
        Screen('SelectStereoDrawBuffer', experimentdata.screenInfo.curWindow, k);
        drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thetext,1,[],thisstimulus.color);
    end
else
    % This is necessary because sometimes, randomly, the textsize jumps
    % (don't know why this is!!!). This forces it to be the same within the trial
    if ~isfield(thistrial,'textsize')
        thistrial.textsize = drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thetext,1,[],thisstimulus.color);
    else
        drawText(thistrial,experimentdata.screenInfo,'Courier',100,0,thetext,1,thistrial.textsize,thisstimulus.color);
    end
end
