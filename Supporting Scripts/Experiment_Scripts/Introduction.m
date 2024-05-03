% Function called by Experiment.m
% Role of function is to introduce the participant to the experiment
% Parameters: 
%   - screen_pars (parameters for the screen used by the Program)
%   - player_pars (parameters for the player)
%   - score_pars  (parameters for the scores)
%   - target_pars (parameters for the targets)
% Return Values: None

function Introduction(screen_pars, player_pars, score_pars, target_pars)
    % Load the colors
    load('colors.mat','color_list');

    % % Create the Introductory Message for the Experiment 
    greeting_message = ['Hello, in this experiment, you will be using a controller to move around.\n',...
                        'You have to choose between 2 given options at a time, represented as big coloured circles.\n',...
                        'This experiments includes 2 tasks, which you will alternate back and forth for:\n',...
                        'A Prisoner Task, and a Hunting Trip Task. You will be given more directions about each one.\n\n\n',...
                        'Press any key on the keyboard to proceed.'];
    DrawFormattedText(screen_pars.window, greeting_message, 'center', screen_pars.center(2)-150, color_list.white);

    % Update the Screen
    Screen('Flip',screen_pars.window);

    % Wait for player input
    KbStrokeWait();

    % Create the text explaining each task.
    explanation_text = ...
        [string(['In the prisoner task scenario, you are completing a task with a felow inmate.\n',...
        'You will be given the chance to either cooperate with the other prisoner, or defect.\n',...
        'Based on your decision you will be given a score:\n', ...
        '- If both you and the other prisoner cooperate, you get ', int2str(score_pars.prison.cc), ' points each.\n',...
        '- If you cooperate, but the other prisoner defects, you get ', int2str(score_pars.prison.cd),...
                ' points and the other prisoner gets ', int2str(score_pars.prison.dc), ' points.\n',...
        '- Similarly, if you defect, but the other prisoner cooperates, you get ', int2str(score_pars.prison.dc), ...
                ' points and the other prisoner gets ', int2str(score_pars.prison.cd), '.\n' ...
        '- If both you and the other prisoner defect, you get ', int2str(score_pars.prison.dd), ' point each.\n',...
        'To cooperate move your avatar to the blue circle. To defect move your avatar to the red circle']),...
        string(['In the hunting trip scenario, you are hunting with a partner.\n',... 
        ' You can hunt a stag, which requires 2 people to capture, or a rabbit which you can do by yourself.\n',...
        'Based on your decision you will earn catch a certain amount of meat portions:\n', ...
        '- If both you and your partner hunt the stag, you get ', int2str(score_pars.hunt.cc), ' portions.\n',...
        '- If you hunt the stag, but your partner hunts rabbits, you get ', int2str(score_pars.hunt.cd),...
                ' portions and your partner gets ', int2str(score_pars.hunt.dc), ' portions.\n',...
        '- Similarly, if you hunt rabbits, but your partner hunts a stag, you get ', int2str(score_pars.hunt.dc), ...
                ' portions and your partner gets ', int2str(score_pars.hunt.cd), '.\n' ...
        '- If both you and your partner hunt rabbits, you get ', int2str(score_pars.hunt.dd), ' meat portions each.\n',...
        'The total number of meat portions you catch functions as your score.\n'...
        'To hunt a stag move your avatar to the green circle. To hunt a rabbit move your avatar to the purple circle'])];
    target_colors = [target_pars.prison.cooperate; target_pars.prison.defect;...
                      target_pars.hunt.stag; target_pars.hunt.rabbit];

    for taskIdx = 1:2
        % Create the Introductory Message for the Target
        % target_message_1 = ['You will need to either cooperate (choose blue) or work against (choose red) the CPU.\n' ...
        %     'Cooperating will net you 3 points, if the CPU cooperates, but 0 points if it does not.\n' ...
        %     'Not cooperating will net you 5 points if the CPU cooperates, but only 1 if the CPU does not\n' ...
        %     'This is how the choices look: blue is cooperation, red is betrayal.'];
        target_message_1 = char(explanation_text(taskIdx));
        target_message_2 = 'Press any key to proceed';
        circle_coords1 = [screen_pars.window_width/2 - 120, ...      % Left-Top Edge X: Middle of screen - radius (40)
            screen_pars.window_height/2 + 40, ...                  % Left-Top Edge Y: Middle of screen - radius (40) + Offset for text
            screen_pars.window_width/2 - 40, ...                   % Right-Bottom X: Middle of screen + radius (40)
            screen_pars.window_height/2 + 120];                    % Right-Bottom Y: Middle of screen + radius (40) + Offset for text

        circle_coords2 = [screen_pars.window_width/2 + 40, ...      % Left-Top Edge X: Middle of screen - radius (40)
            screen_pars.window_height/2 + 40, ...                  % Left-Top Edge Y: Middle of screen - radius (40) + Offset for text
            screen_pars.window_width/2 + 120, ...                   % Right-Bottom X: Middle of screen + radius (40)
            screen_pars.window_height/2 + 120];                    % Right-Bottom Y: Middle of screen + radius (40) + Offset for text

        % Present 2 texts (above and below the circle)
        DrawFormattedText2(target_message_1, 'win', screen_pars.window, 'xalign', 'left', 'baseColor', color_list.white, ...
            'sx', 20, 'sy', screen_pars.center(2) - count(target_message_1,'\n')*46);
        DrawFormattedText(screen_pars.window, target_message_2, 'center', screen_pars.center(2)+180, color_list.white);

        % Draw the targets
        Screen('FillOval', screen_pars.window, target_colors(2*taskIdx - 1,:), circle_coords1);
        Screen('FillOval', screen_pars.window, target_colors(2*taskIdx,:), circle_coords2);

        % Update the Screen
        Screen('Flip',screen_pars.window);

        % Wait for player input
        KbStrokeWait();
    end

    

    % Let the player play with their 'character'
    % Set the starting position for the player
    player_pos = screen_pars.center;

    % Loops as longs as the player doesn't press any keyboard buttons
    while ~KbCheck
        % Draw out the messages 
        player_message_1 = 'This is you. Feel free to move around to get used to the controls.';
        player_message_2 = 'Press any button on the keyboard once you are ready.';
        DrawFormattedText(screen_pars.window, player_message_1, 'center', screen_pars.center(2)-player_pars.radius-20, color_list.white);
        DrawFormattedText(screen_pars.window, player_message_2, 'center', screen_pars.center(2)+player_pars.radius+50, color_list.white);
        
        [player_pos, player_rect] = MovePlayer(player_pos, player_pars.speed, player_pars.radius, screen_pars.window_dims);
        
        % Draw the playable character in the new position
        Screen('FillOval', screen_pars.window, player_pars.color, player_rect);

        % Update the Screen
        Screen('Flip', screen_pars.window);
    end
end

