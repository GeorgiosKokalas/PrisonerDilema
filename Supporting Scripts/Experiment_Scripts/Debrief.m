% Function called by: Experiment.m
% Role of function is to debrief the participant after finishing
% Parameters: 
%   - screen (screen parameters)
%   - total _score (total score)
% Return Values: None

function Debrief(screen, score_total)
    load('colors.mat','color_list');

    score_total_msg = ['Total Score: ', num2str(score_total)];
    DrawFormattedText(screen.window, score_total_msg, 'center', screen.window_height/2 - 100, color_list.white);
    
    message = 'Thank you for participating!';
    DrawFormattedText(screen.window, message, 'center', 'center', color_list.white);

    Screen('Flip', screen.window);
end

