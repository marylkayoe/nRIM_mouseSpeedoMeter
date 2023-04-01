function xAx = makexAxisFromFrames(nSamples, FRAMERATE)
% make array to be used as xAxis for plotting a trace with given framerate

xAx = [1:nSamples];
xAx = xAx ./ FRAMERATE;