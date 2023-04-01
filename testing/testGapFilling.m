function testGapFilling(nSamples, N, gapLength)
    % a function to be used to check how well the gap filling function works
    % with an artificial 3D trajectory that has nans randomly inserted in the middle and and at the ends

    % input parameters:
    % nSamples = how long the test trajectory should be
    % N = how many gaps we add
    % gapLength = how long the gaps should be

    % Generate a complex 3D trajectory
    t = linspace(0, 4 * pi, nSamples)';
    x = (t .* cos(t) + sin(2 * t)) / 2;
    y = (t .* sin(t) + cos(3 * t)) / 2;
    z = t / 5 + sin(4 * t);

    traj = [x, y, z];

    % Introduce N NaN gaps with specified gapLength at random positions
    for i = 1:N
        gapStart = randi([1, nSamples - gapLength], 1);
        traj(gapStart:gapStart + gapLength - 1, :) = NaN;
    end

    % Use the gapFillTrajectory function to fill the gaps
    % replace with any function you want to try
    gapFilledTrajectory = gapFillTrajectory(traj);

    % Plot the original and gap-filled trajectories
    figure;

    % Plot the 3D trajectories
    figure;
    hold on;
    plot3(gapFilledTrajectory(:, 1), gapFilledTrajectory(:, 2), gapFilledTrajectory(:, 3), 'DisplayName', 'Gap-filled', 'LineWidth', 2);
    plot3(traj(:, 1), traj(:, 2), traj(:, 3), 'DisplayName', 'Original', 'LineWidth', 4);
    hold off;
    legend;
    title('3D Trajectories');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on;
end
