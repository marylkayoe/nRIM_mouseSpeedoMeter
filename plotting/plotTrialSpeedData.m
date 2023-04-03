function plotTrialSpeedData(instSpeeds, LOCOTHRESHOLD, FRAMERATE, infoString, dataDescriptor)
% This function plots the instantaneous speeds over time, along with
% the locomotion threshold as a horizontal dashed line.
%
% Inputs:
% - instSpeeds: a single-column vector containing the instantaneous speeds
% - LOCOTHRESHOLD: a scalar value representing the threshold for locomotion
% - FRAMERATE: the framerate of the data
% - dataDescriptor (optional): a string with additional information for the title, e.g., filename

% Create the time axis using the makexAxisFromFrames function
xAx = makexAxisFromFrames(length(instSpeeds), FRAMERATE);

% Create a new figure and plot the instantaneous speeds
figure;
plot(xAx, instSpeeds, 'LineWidth', 1);
hold on;

% Plot the locomotion threshold as a horizontal dashed line
h = yline(LOCOTHRESHOLD, '--', 'LOCOTHRESHOLD');

% Add a text box with mean speed and locomotion time information

if ~isempty(infoString)
    annotation('textbox', [0.65, 0.7, 0.2, 0.15], 'String', infoString, 'EdgeColor', 'none', 'BackgroundColor', 'none');
end
% Customize the plot appearance
xlabel('Time (s)');
ylabel('Speed (mm/sec)');

if exist('dataDescriptor', 'var')
    title(['Instantaneous Speeds and Locomotion Threshold - ', dataDescriptor]);
else
    title('Instantaneous Speeds and Locomotion Threshold');
end
grid on;

% Release the hold on the current figure
hold off;
end
