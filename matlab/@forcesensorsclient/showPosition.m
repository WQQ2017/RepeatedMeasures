% SHOWPOSITION - show the position for the force sensors (as a dot)

function [lastposition,thistrial] = showPosition(m,thistrial,experimentdata,e,frame)

% get the current position
lastsample = getsample(m);

if thistrial.showPosition<3
    lastposition(1) = m.offsetX(1);
    lastposition(2) = m.offsetY(1);
else
    lastposition(1) = 0;
    lastposition(2) = 0;
end

 tofilter(1) = 0;
 tofilter(2) = 0;

for k=1:get(m,'numchannels')   
    if thistrial.showPosition==2
        if numel(m.offsetX)>1
            lastposition(1) = m.offsetX(k);
            lastposition(2) = m.offsetY(k);
        else
            lastposition(1) = m.offsetX;
            lastposition(2) = m.offsetY;
        end
    elseif thistrial.showPosition==4 || thistrial.showPosition==6
        lastposition(1) = 0;
        lastposition(2) = 0;
    end
    
    thisval = lastsample(k+1);
    
    if m.displayRangeX(k,1) ~= m.displayRangeX(k,2)
        lastposition(1) = lastposition(1) + (thisval - m.displayRangeX(k,1)) / (m.displayRangeX(k,2) - m.displayRangeX(k,1));
        tofilter(1) = 1;
    end
    if m.displayRangeY(k,1) ~= m.displayRangeY(k,2)
        lastposition(2) = lastposition(2) + (thisval - m.displayRangeY(k,1)) / (m.displayRangeY(k,2) - m.displayRangeY(k,1));
        tofilter(2) = 1;
    end
       
    if m.displayRangeX(k,3) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(1) = lastposition(1) + m.displayRangeX(k,3) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end
    if m.displayRangeY(k,3) ~= 0
        if isfield(thistrial,'StimulusOnsetTime')
            lastposition(2) = lastposition(2) + m.displayRangeY(k,3) * (GetSecs - thistrial.StimulusOnsetTime(1));
        end
    end

    % i.e. one dot per sensor
    if thistrial.showPosition==2 || thistrial.showPosition==4 || thistrial.showPosition==6
        positions(1,k) = lastposition(1);
        positions(2,k) = lastposition(2);
    end
    
end

if thistrial.showPosition==1 || thistrial.showPosition==5
    if ~isfield(thistrial,'combined')
        thistrial.combined = [];
    end
    thistrial.combined = [thistrial.combined lastposition'];
   % filter the data 
   Wn = m.filterCutoff ./ (m.samplerate / 2);
   if numel(Wn)==2
       [B,A] = butter(m.filterOrder/2,Wn);
   else
       [B,A] = butter(m.filterOrder,Wn);
   end
   
   if tofilter(2)
       output(2,:) = filter(B,A,thistrial.combined(2,:));
       lastposition(2) = output(2,end);
   end
   if tofilter(1)
       output(1,:) = filter(B,A,thistrial.combined(1,:));
       lastposition(1) = output(1,end);
   end
   
end

% i.e. one dot for all sensors
if thistrial.showPosition==1
    lastposition(1) = lastposition(1) * experimentdata.screenInfo.screenRect(3);
    lastposition(2) = lastposition(2) * experimentdata.screenInfo.screenRect(4);
    Screen('DrawDots', experimentdata.screenInfo.curWindow, lastposition, 6, m.showPositionColor,[],1);
elseif thistrial.showPosition==2 % multiple dots
    for k=1:get(m,'numchannels')
        positions(1,k) = positions(1,k) .* experimentdata.screenInfo.screenRect(3);
        positions(2,k) = positions(2,k) * experimentdata.screenInfo.screenRect(4);
        if size(m.showPositionColor,1)>1
            thecolor = m.showPositionColor(k,:);
        else
            thecolor = m.showPositionColor;
        end
        Screen('DrawDots', experimentdata.screenInfo.curWindow, positions(:,k), 6, thecolor,[],1);
    end
elseif thistrial.showPosition==3 % draw the force as a circle (combined)
    halfradius = 0.5 * lastposition(2) * experimentdata.screenInfo.screenRect(3);
    if halfradius > 0
        circleleft = 0.5 * experimentdata.screenInfo.screenRect(3) - halfradius;
        circleright = 0.5 * experimentdata.screenInfo.screenRect(3) + halfradius;
        circletop = 0.5 * experimentdata.screenInfo.screenRect(4) + halfradius;
        circlebottom = 0.5 * experimentdata.screenInfo.screenRect(4) - halfradius;
        rect = [circleleft circlebottom circleright circletop];
        Screen('FrameOval', experimentdata.screenInfo.curWindow, m.showPositionColor, rect);
    end
elseif thistrial.showPosition==4 % draw the force as a circle (one per sensor)
    for k=1:get(m,'numchannels')
        halfradius = 0.5 * positions(2,k) * experimentdata.screenInfo.screenRect(3);
        if halfradius > 0
            circleleft = 0.5 * experimentdata.screenInfo.screenRect(3) - halfradius;
            circleright = 0.5 * experimentdata.screenInfo.screenRect(3) + halfradius;
            circletop = 0.5 * experimentdata.screenInfo.screenRect(4) + halfradius;
            circlebottom = 0.5 * experimentdata.screenInfo.screenRect(4) - halfradius;
            rect = [circleleft circlebottom circleright circletop];
            if size(m.showPositionColor,1)>1
                thecolor = m.showPositionColor(k,:);
            else
                thecolor = m.showPositionColor;
            end    
            Screen('FrameOval', experimentdata.screenInfo.curWindow, thecolor, rect);
        end
    end
elseif thistrial.showPosition==5 % draw the force as a rectangle (combined)
    height = lastposition(2) * experimentdata.screenInfo.screenRect(4);
    if height > 0
        left = 0.55 * experimentdata.screenInfo.screenRect(3);
        top = 0.9 * experimentdata.screenInfo.screenRect(4) - height;
        if top<0
            top = 0;
        end
        width = 0.15 * experimentdata.screenInfo.screenRect(3);
        rect = [left top left+width top+height];
        Screen('FillRect', experimentdata.screenInfo.curWindow, m.showPositionColor, rect);
    end
elseif thistrial.showPosition==6 % draw the force as a rectangle (one per sensor)
    for k=1:get(m,'numchannels')
        height = positions(2,k) * experimentdata.screenInfo.screenRect(3);
        if height > 0
            if k==1
                left = 0.3  * experimentdata.screenInfo.screenRect(3);
            else
                left = 0.55 * experimentdata.screenInfo.screenRect(3);
            end
            top = 0.9 * experimentdata.screenInfo.screenRect(4) - height;
            if top<0
                top = 0;
            end
            width = 0.15 * experimentdata.screenInfo.screenRect(3);
            rect = [left top left+width top+height];
            if size(m.showPositionColor,1)>1
                thecolor = m.showPositionColor(k,:);
            else
                thecolor = m.showPositionColor;
            end
            Screen('FillRect', experimentdata.screenInfo.curWindow, thecolor, rect);
        end
    end
end