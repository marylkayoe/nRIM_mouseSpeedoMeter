function GFtraj = gapFillTrajectory(traj)
% fill gaps - interpolating in a simple way
%more elegant way would be to transform to mesh grid and interpolate in 3D but not now
% nans at the beginning and end of the trajectory are made constant last value
% (this happens when the trace is shorter than requestes trial length )

if (isempty(traj))
    GFtraj = [];
else
    %find missing values
    [nSamples nDIMS] = size(traj);
    % are there nan values in the trajectory?
    nanValsInTraj = isnan(traj(:, 1));
    if isempty(find(~nanValsInTraj)) %no non-NAN values in trajectory
        warning('Empty trajectory');
        GFtraj = traj;
    else
        if (find(nanValsInTraj))
            idx = ~isnan(traj(:, 1));
            
            % removing weird ends due to attempts at interpolating nans:
            % find first and last non-nan values
            firstVal = find(idx, 1, 'first');
            lastVal = find(idx, 1, 'last');
            
            % first and last nans are converted to 0 % REFACTOR Dec21 - not needed
            for d = 1:nDIMS
 
                GFtraj(:, d) = interp1(find(idx),traj(idx,d),(1:numel(traj(:, d)))', 'makima');
            end
            
            % removing weird ends due to attempts at interpolating nans:
            % find first and last non-nan values
            %fill empty ends with  constant values
            gfFirstPad = repmat(GFtraj(firstVal, :), firstVal, 1);
            GFtraj(1:firstVal, :) = gfFirstPad ;
            gfLastPad = repmat(GFtraj(lastVal, :), nSamples-lastVal+1, 1);
            GFtraj(lastVal:end, :) = gfLastPad;
        else
            GFtraj = traj;
        end
    end
end

