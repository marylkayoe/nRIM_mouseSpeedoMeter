
function [vels] = getVelocityFromTraj(trajMat, USENAN, velWin, REMOVEOL, FRAMERATE)
% input : gap-filled 3D trajectory from which we want velocity (single step,single marker)

% returns a vector with instantaneous velocities (mm/sec) calculated per
% velWin

% NOTE: when dealing with single-step-trajectories, stepTrajMat is padded
% at the end with NANs that should not be part of velocity computation. THe
% resulting velocity vector will be populated only with values from the
% non-nan trajectory, rest of it will remain nan.

% extreme outliers are removed, default should be to use nans and gap-fill(USENAN = 1)
% but for plotting it's more pleasant to use just a low value (0.1)
% note: this should be called SPEED not VELOCITY as it does not have
% direction ...

if isempty(trajMat)
    warning ('empty trajectory used for velocity calculation');
    vels = [];
else
    
    if ~exist('USENAN','var')
        USENAN = 1;
    end
    
    % do we want to strip the outlier values
    if ~exist('REMOVEOL','var')
        REMOVEOL = 1;
    end
    
  
    if ~exist('FRAMERATE','var')
        FRAMERATE = 300;
    end
    % when calculating overall animal speed, using window of 300 (1s) is better
    % default 1 frame
    
    % for finer speed measurements:
    % the amount of movement per frame is likely largely noise, tried out
    % if larger window would work better - results no much dif between 1 and 10
    % frames, larger windows just result in loss of signal so stick to 1
    
    if ~exist('velWin','var')
        velWin = 1;
    end
    
    %  size of output vector
    [nFrames nDIMs] = size (trajMat);
    vels = nan(nFrames, 1);
    
    % removing spurious nans at the end
    % the trace must be gap-filled before attempting this
    lastFrame = find(isnan(trajMat(:, nDIMs)), 1, 'first');
    if isempty(lastFrame)
        lastFrame = length(trajMat(:, nDIMs));
    else
        lastFrame = lastFrame - 1;
    end
    % %euclidean distances between all points in the trajectory
    [frameDisplacements ] = pdist2(trajMat(1:lastFrame, :), trajMat(1:lastFrame, :), 'euclidean'); 
    % use distances velWin frames apart
%    winDisplacements = diag(frameDisplacements, -velWin);
    winDisplacements = diag(frameDisplacements, -1);
  % note: next line is commented out for backwards compatible numerical values, but should be uncommented in the future 
   winDisplacements = movsum(winDisplacements, velWin);

    
    % replace them with a low value or nan; use low value when plotting
    if (REMOVEOL)
        % find  extreme values
  %      OL = isoutlier(winDisplacements, 'quartiles');
  % outliers taken from a window equal to the measurement window times 4 (equal to velWin which does not make sense for 1 frame windows)
  % could be defined also as one second... 
        OL = isoutlier(winDisplacements,'movmedian', velWin*4);
         %             OL = isoutlier(winDisplacements,'movmedian',10);
        if (find(OL))

            if (USENAN)
                winDisplacements(OL) = nan;
                winDisplacements = gapFillTrajectory(winDisplacements);
            else
                winDisplacements(OL) = 0.1; % note that estimated max precision of mocap is 0.2mm
            end
        end
    end
     % displacement mm per (velWin/FRAMERATE) sec
    % to convert to mm per sec multiply by fraction that velWin is of
    %FRAMERATE
    
    vels(1:length(winDisplacements)) = winDisplacements * (FRAMERATE/velWin);
end