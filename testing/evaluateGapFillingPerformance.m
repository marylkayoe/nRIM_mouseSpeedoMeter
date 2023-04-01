function [rmse, mae, relativeRMSE] = evaluateGapFillingPerformance(traj, N, gapLength)
    % use this function to get an estimate how well or badly the gapfilling works with your data
    % it will take the original trajectory, add N gaps of gapLength length
    % and return RMSE and MAE values for comparing the gap-added and gap-filled signals.

    hiddenValues = cell(N, 1);
    gapStarts = zeros(N, 1);

    for i = 1:N
        gap_start = randi([1, size(traj, 1) - gapLength], 1);
        gapStarts(i) = gap_start;
        hiddenValues{i} = traj(gap_start:gap_start + gapLength - 1, :);
        traj(gap_start:gap_start + gapLength - 1, :) = NaN;
    end

    % Use the gapFillTrajectory function to fill the gaps
    gapFilledTrajectory = gapFillTrajectory(traj);

    % Calculate RMSE and MAE between the true values and the gap-filled values
    squaredErrors = cellfun(@(x, y) (x - y) .^ 2, hiddenValues, ...
        mat2cell(gapFilledTrajectory(gapStarts, :), ones(N, 1), size(traj, 2)), ...
        'UniformOutput', false);
    absErrors = cellfun(@(x, y) abs(x - y), hiddenValues, ...
        mat2cell(gapFilledTrajectory(gapStarts, :), ones(N, 1), size(traj, 2)), ...
        'UniformOutput', false);

    rmse = sqrt(mean(mean(cell2mat(squaredErrors), 'omitnan')));
    mae = mean(mean(cell2mat(absErrors), 'omitnan'));

     % Calculate the data range for each dimension
     dataRange = range(traj, 'all');

     % Calculate the relative RMSE as a percentage of the data range
     relativeRMSE = (rmse / dataRange) * 100;
end
