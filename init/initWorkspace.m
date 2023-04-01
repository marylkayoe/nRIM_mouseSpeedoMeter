% Main script to set up the workspace

% Clear the workspace and command window and close open figures
clear; clc; close all

% Define the root directory of the project
root_dir = fileparts(mfilename('fullpath'));

% Add subdirectories to the path, e.g. data storage root
%addpath(fullfile(root_dir, 'subfolder1'));
%addpath(fullfile(root_dir, 'subfolder2'));

% Add any additional paths here

% Load any necessary data or variables
% standard workspace file name convention: PRJNAME-WS.mat
load('PRJNAME-WS.mat');

% Set any desired default settings or preferences
set(0, 'DefaultFigureWindowStyle', 'docked');

% Display a message to indicate that the workspace has been set up
disp('Workspace has been set up successfully.');
