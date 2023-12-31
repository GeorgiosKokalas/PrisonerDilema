% Function called by Experiment.m
% Role of function is to introduce the participant to the experiment
% Parameters: 
%   - screen_pars (parameters for the screen used by the Program)
%   - cross_pars  (paramteres for the cross)
%   - player_pars (parameters for the player)
% Return Values: None

function Introduction(screen_pars, cross_pars, player_pars)
    % Load the colors
    load('colors.mat','color_list');

    % % Create the Introductory Message for the Cross 
    % % Draw the message
    % cross_message = ['In this experiment, when you see the cross below, you need to wait and focus on the cross.\n', ...
    %     'It signals an intermediate stage to allow you to prepare for each trial of this experiment.\n', ...
    %     'Also every trial stage will be signaled by a characteristic beep, like the one next.\n', ...
    %     'Please press any key to proceed.'];
    % DrawFormattedText(screen_pars.window, cross_message, 'center', screen_pars.center(2)-cross_pars.width-130, color_list.white);
    % 
    % % Draw the cross
    % Screen('DrawLines', screen_pars.window, cross_pars.coords, cross_pars.thickness, cross_pars.color, screen_pars.center);
    % 
    % % Update the screen
    % Screen('Flip',screen_pars.window);
    % 
    % % Wait for player input
    % KbStrokeWait();


    % Create the Introductory Message for the Target
    target_message_1 = ['You will need to either cooperate (choose blue) or work against (choose red) the CPU.\n' ...
        'Cooperating will net you 3 points, if the CPU cooperates, but 0 points if it does not.\n' ...
        'Not cooperating will net you 5 points if the CPU cooperates, but only 1 if the CPU does not\n' ...
        'This is how the choices look: blue is cooperation, red is betrayal.'];
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
    DrawFormattedText(screen_pars.window, target_message_1, 'center', screen_pars.center(2)-100, color_list.white);
    DrawFormattedText(screen_pars.window, target_message_2, 'center', screen_pars.center(2)+180, color_list.white);
    
    % Draw the targets
    Screen('FillOval',screen_pars.window, color_list.blue, circle_coords1);
    Screen('FillOval',screen_pars.window, color_list.red, circle_coords2);
    
    % Update the Screen
    Screen('Flip',screen_pars.window);
    
    % Wait for player input
    KbStrokeWait();
    

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

