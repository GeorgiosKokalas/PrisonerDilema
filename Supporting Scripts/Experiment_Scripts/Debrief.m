% Function called by: Experiment.m
% Role of function is to debrief the participant after finishing
% Parameters: screen (screen parameters
% Return Values: None

function Debrief(screen)
    load('colors.mat','color_list');

    message = 'Thank you for participating!';

    DrawFormattedText(screen.window, message, 'center', 'center', color_list.white);

    Screen('Flip', screen.window);
end

