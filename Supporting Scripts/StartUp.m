% Function called by: main.m
% Role of function is to initialize StartUp all that is needed for the experiment
% Parameters: None
% Return Values: parameters (paramters to be used for the experiment)
% Begins the program, initiates parameters, starts the Screen and Audio  
% Returns all the parameters that might be needed for the program to run the trials  

function parameters = StartUp()
    % Clear the workspace and the screen
    sca;
    close all;
    clear;
    clc;
    
    parameters = InsertParams();
    
    % Initialize the Screen
    parameters.screen = SetUpScreen(parameters.screen);

    % Initialize the Sound
    % parameters.audio = struct;
    % parameters.audio = SetUpAudio(parameters.audio);

end