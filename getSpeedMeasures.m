function [meanSpeed, maxSpeed, locoTime, totalDistance, totalDistanceLocomoting, meanSpeedLocomoting, instSpeeds] = getSpeedMeasures(mouseTrajectory, FRAMERATE, dataDescriptor)

%inputs: 


    % Set the default locomotion threshold
    LOCOTHRESHOLD = 40;

    % Validate the input trajectory
    [nRows, nCols] = size(mouseTrajectory);

    if nCols > nRows || nCols < 1 || nCols > 3
        error('Invalid trajectory matrix: should have more rows than columns and 1-3 columns for 1-3D movement');
    end

    % Gap-fill the trajectory
    gapFilledTrajectory = gapFillTrajectory(mouseTrajectory);

    % Calculate instantaneous speeds using getMouseSpeedFromTraj
    instSpeeds = getMouseSpeedFromTraj(gapFilledTrajectory, FRAMERATE);
    [locoFrames, isLocomoting] = getLocoFrames(instSpeeds, LOCOTHRESHOLD);
    % Compute mean and max speeds
    meanSpeed = nanmean(instSpeeds);
    meanSpeedLocomoting = nanmean(instSpeeds(isLocomoting));

    maxSpeed = max(instSpeeds);

    % advanced measures from the speed array
    % Calculate total distance moved in the trial, 
    % and distance traveled while locomoting 

    totalDistance = nansum(instSpeeds) * (1/FRAMERATE);
    totalDistanceLocomoting = nansum(instSpeeds(isLocomoting)) * (1/FRAMERATE);
    % Get locomotion frames and logical array
    [locoFrames, isLocomoting] = getLocoFrames(instSpeeds, LOCOTHRESHOLD);

    % Compute time spent locomoting
    locoTime = sum(isLocomoting) / FRAMERATE;

    % Placeholder for plotting the data
    infoString = sprintf('Mean Speed: %.2f mm/s\nMax Speed: %.2f mm/s\nLoco Time: %.2f s\nTotal Distance: %.2f mm\nTotal Distance Locomoting: %.2f mm\nMean Speed Locomoting: %.2f mm/s', meanSpeed, maxSpeed, locoTime, totalDistance, totalDistanceLocomoting, meanSpeedLocomoting);
    plotTrialSpeedData(instSpeeds, LOCOTHRESHOLD, FRAMERATE, infoString, dataDescriptor);


end
