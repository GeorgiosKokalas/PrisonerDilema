% Function called by: Experiment.m
% Role of function is to run a trial of the experiment
% Parameters: 
%   - parameters (Things to be used for the experiment)
%   - trial_idx (the index of the current trial)
%   - score_total (the total score so far)
%   - prev_score (the most recent score)
%   - prev_pl_coop (whether or not the player previously cooperated)
% Return Values: 
%   - score (the score the player just earned)
%   - pl_coop (whether or not the player cooperated)

function [score, pl_coop] = RunTrial(parameters, trial_idx, score_total, prev_score, prev_pl_coop)
    trial_name = append("/trial", int2str(trial_idx));
    trial_dir = append(parameters.trial.output_dir, trial_name);
    mkdir(trial_dir);
    load('colors.mat','color_list');

    % PRE STAGE - Before the timer of the activity starts
    % Draw the cross for the person to prepare
    % Screen('DrawLines', parameters.screen.window, parameters.cross.coords, ...
    %     parameters.cross.thickness, parameters.cross.color, parameters.screen.center);
    
    Screen('TextSize', parameters.screen.window, parameters.screen.default_text_size);
    cross_message =['Score: ', num2str(prev_score)];
    DrawFormattedText(parameters.screen.window, cross_message, 'center', 'center', color_list.white);
    
    Screen('TextSize', parameters.screen.window, parameters.screen.score_text_size);
    score_total_msg = ['Total Score: ', num2str(score_total)];
    DrawFormattedText(parameters.screen.window, score_total_msg, 20, 50, [200, 200, 200, 255]);

    Screen('Flip', parameters.screen.window);

    % % Wait a bit
    % pause(2.75);
    % 
    % % Erase the score
    % Screen('DrawLines', parameters.screen.window, parameters.cross.coords, ...
    %     parameters.cross.thickness, parameters.cross.color, parameters.screen.center);
    
    % Screen('Flip', parameters.screen.window);
    pause(2);


    % Generate the positions of all the targets
    num_targets = 2;
    targets = repmat(struct('cooperative', false,'color', [], 'position', [], 'radius', 0, 'angle', 0, 'rect', []), num_targets, 1); 

    % %Create the center all targets will be dependent on
    % center_point = [parameters.screen.window_width / 2, ...
    %     parameters.screen.window_height - parameters.target.radius - 10];
    % 
    % % Choose the target distance so targets are within screen (dependent on height OR width)  
    % center_target_distance = min(parameters.screen.window_width / 2 - max(parameters.target.radius) - 10, ...
    %     parameters.screen.window_height - 2*parameters.target.radius + 10);

    % Find the main increment for the angle
    angles = [45, 135];  % If the num_targets was odd, it's even now, thanks to the decrement
    % current_angle = base_angle;
    for target_idx = 1:num_targets
        targets(target_idx).angle = angles(target_idx);
        targets(target_idx).radius = parameters.target.radius;
        % targets(target_idx).position = [round((cosd(angles(target_idx)) * center_target_distance) + center_point(1)), ...
        %     round(center_point(2) - (sind(angles(target_idx)) * center_target_distance))];
        targets(target_idx).position = [parameters.screen.window_width*(target_idx/2 - 0.25), parameters.screen.window_height/2];
        targets(target_idx).rect = [targets(target_idx).position(1) - targets(target_idx).radius, ...
            targets(target_idx).position(2) - targets(target_idx).radius, ...
            targets(target_idx).position(1) + targets(target_idx).radius, ...
            targets(target_idx).position(2) + targets(target_idx).radius];
        
        if target_idx == 1 
            targets(target_idx).color = color_list.blue;
            targets(target_idx).cooperative = true;
        else
            targets(target_idx).color = color_list.red;
            targets(target_idx).cooperative = false;
        end
    end
    
    % Measure the Dilema
    score = 0;

    % See if the computer cooperates or not
    % cpu_coop = false;   % Cooperation value of the CPU (computer)
    pl_coop = -1;    % Cooperation value of the player
    % if rand() < 0.5     % 50-50 chance for the computer to cooperate
    %     cpu_coop = true;
    % end
    cpu_coop = prev_pl_coop;
    clear prev_pl_coop;
    
    disp(['Trial ', num2str(trial_idx)]);
    disp(['Does the cpu cooperate? ', num2str(cpu_coop)]);
    disp('   1 = Yes, 0 = No');

    % Starts a timer to track how long till the experiment ends
    tic;
    elapsed_time = toc;

    % parameters.player.pos = [parameters.screen.window_width/2, ...
    %     parameters.screen.window_height - parameters.player.radius - 20];
    % LOOP STAGE
    while elapsed_time < parameters.trial.duration_s
        % Calculate the player movements
        [parameters.player.pos, player_rect] = MovePlayer(parameters.player.pos, parameters.player.speed, ...
            parameters.player.radius, parameters.screen.window_dims);

        % Detect collisions between objects
        [player_target_collision, pl_coop] = DetectCollision(parameters.player, targets);

        % If player has collided with target, end trial
        if player_target_collision
            break;
        end

        % Draw all the targets
        for target_idx=1:length(targets)
            Screen('FillOval', parameters.screen.window, targets(target_idx).color, targets(target_idx).rect);
        end

        % Draw the score again
    DrawFormattedText(parameters.screen.window, score_total_msg, 20, 50, [200, 200, 200, 255]);

        % Draw the playable character in the new position
        Screen('FillOval', parameters.screen.window, parameters.player.color, player_rect);

        % Update the Screen
        Screen('Flip', parameters.screen.window);

        % Update the timer
        elapsed_time = toc;
    end

    if pl_coop == -1
        disp("Something has gone wrong. Neither option is stored");
        return;
    end
    
    pl_coop = logical(pl_coop);   % Make the decisions logical/boolean values
    % If they both cooperated, give 3
    % If only the second cooperated, give 5
    % If only the first cooperated, keep 0
    % If both defected, give 1
    if pl_coop && cpu_coop
        score = 3;
    elseif ~pl_coop && cpu_coop
        score = 5;
    elseif ~pl_coop && ~cpu_coop
        score = 1;
    end
    
    % Reset font size to its default
    Screen('TextSize', parameters.screen.window, parameters.screen.default_text_size);
end

