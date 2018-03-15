% SHOWRESPONSE - don't end the trial, but show visual feedback after the trial has finished using the recorded data
function [r,params] = showdataresponse(inputParams)

params.name = {'columnsToUse','showPositionType','showPositionColor','showPositionSize',...
    'displayRangeX','displayRangeY','offsetX','offsetY','backgroundImage','waitTime'};
params.type = {'matrix_1_n','string','matrix_1_n','matrix_1_n',...
    'matrix_1_n','matrix_1_n','matrix_1_n','matrix_1_n','number','number'};
params.description = {'which columns from the data to use (same columns as in the csv file produced)',...
    ['If showing position, how to show the current position (either ''dot'',''ellipse'', ''rectangle'' or ''image'' or the name of a function with an @ before it). Note that if showPosition=1, it will always be shown. If showPosition=2 and imagestimulus is used,' ...
    'it will only be shown when in state 1. If showPosition=3, then the fields below will be used to determine the position. If showPosition=4, it is the same as 3, but the position is only shown until the trial starts. If showPosition=5, it is the same as 3, but if using image stimuli, only show position if it is in state 1.',...
    'If using a function, the function will get called ' ...
    'every frame (data can be stored between calls in the thistrial struct): thistrial = yourFunctionName(experimentdata,thistrial,lastpositionVisual,e,frame);' ],...
    'If showing position, the color of the feedback (each number between 0 and 255). Should be a 1*(P*3) array (P= number of dots). If showing image, the imagenumber to show.',...
    'If showing position and showPositionType is a dot, then a 1*P array (with the size of the each dot in pixels. If type is a rectangle, then a 1*(P*2) array (width and height).',...
    'Range of values to show when using showPosition=3 as the dot position on the x axis. Use the first two values to show the x values, next two for y. e.g. [-1 1 0 0 0] to show x values of -1 to 1 as the dot x position. Use the last value to show time, e.g. [0 0 0 0 1] will move across the screen in 1 s. The data points are as saved in the csv file, but only use the columns specified in columnsToUse. To show multiple points, use an 1*(P*(2*N+1)) matrix (N dimensions, P dots)',... 
    'Range of values to show when using showPosition=3 as the dot position on the y axis. Use the first two values to show the x values, next two for y. e.g. [-1 1 0 0 0] to show x values of -1 to 1 as the dot x position. Use the last value to show time, e.g. [0 0 0 0 1] will move across the screen in 1 s. The data points are as saved in the csv file, but only use the columns specified in columnsToUse. To show multiple points, use an 1*(P*(2*N+1)) matrix (N dimensions, P dots)',... 
    'x offset when using showPosition.  This should be a 1*P matrix [P is the number of dots].',...
    'y offset when using showPosition.  This should be a 1*P matrix [P is the number of dots].',...
    'Number of image to show in background (from images listed in setup)','How long to show the feedback (in seconds)'};
params.required = [1 0 0 0 0 0 0 0 0 0];
params.default = {1,'dot',[192 192 192],6,...
    {0 0 0 0 0},{0 0 0 0 0},0.5,0.5,[],5};
params.classdescription = 'This response does not stop the trial, but shows feedback (similar to showPosition).';
params.classname = 'showdataresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'showdataresponse',response(parent));