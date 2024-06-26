% Function called by: Experiment.m
% Role of function is to run a trial of the experiment
% Parameters: 
%   - parameters (Things to be used for the experiment)
%   - trial_idx (the index of the current trial)
%   - score_total (the total score so far)
%   - cpu (the handle to the cpu player)
%   - type (the type of trial [prison or hunt])
%   - layout (the layout type for the options)
% Return Values: 
%   - score (the score the player just earned)
%   - pl_coop (whether or not the player cooperated)

function [score, outcome] = RunTrial(parameters, trial_idx, score_total, cpu, type, layout)
    load('colors.mat','color_list');

    % PRE STAGE - Before the timer of the activity starts
    % Generate the positions of all the targets
    num_targets = 2;
    score_total_msg_prior = ['Task Total Score: ', num2str(score_total)];
    targets = repmat(struct('cooperative', false,'color', [], 'position', [], 'radius', 0, 'angle', 0, 'rect', []), num_targets, 1); 

    % Find the main increment for the angle
    angles = [45, 135];  % If the num_targets was odd, it's even now, thanks to the decrement

    % Create some sources base on the type of experiment
        % source_text is what each circle has in it 
        % source_color is the color of the circle
        % source_scores is the list of available scoresdd
    [source_text, source_colors, source_title] = deal(NaN);
    if strcmpi(parameters.types.prison, type)
        source_text = ["Cooperate", "Defect"];
        source_colors = [parameters.target.prison.cooperate; parameters.target.prison.defect];
        source_title = 'Prisoner Task';
    elseif strcmpi(parameters.types.hunt, type)
        source_text = ["Stag", "Rabbit"];
        source_colors = [parameters.target.hunt.stag; parameters.target.hunt.rabbit];
        source_title = 'Hunting Trip';
    end
    
    % A list of all behavioral options; you either cooperate or not
    source_cooperative = [true, false];

    % current_angle = base_angle;
    for target_idx = 1:num_targets
        % create the placement of each target
        targets(target_idx).angle = angles(target_idx);
        targets(target_idx).radius = parameters.target.radius;
        % targets(target_idx).position = [round((cosd(angles(target_idx)) * center_target_distance) + center_point(1)), ...
        %     round(center_point(2) - (sind(angles(target_idx)) * center_target_distance))];
        targets(target_idx).position = [parameters.screen.window_width*(target_idx/2 - 0.25), parameters.screen.window_height/2];
        targets(target_idx).rect = [targets(target_idx).position(1) - targets(target_idx).radius, ...
            targets(target_idx).position(2) - targets(target_idx).radius, ...
            targets(target_idx).position(1) + targets(target_idx).radius, ...
            targets(target_idx).position(2) + targets(target_idx).radius];
        
        % Based on the layout, you select the items from the source lists in different order    
        layout_selection = NaN;
        if layout == 1                      % First layout is following the flow    
            layout_selection = target_idx;
        elseif layout == 2                  % Seconf layout attempts to go in reverse
            layout_selection = num_targets-target_idx + 1;
        end 
        
        % Put in the type of text that we need using the correct source text and the correct layout order    
        targets(target_idx).text = char(source_text(layout_selection));
        text_length = length(targets(target_idx).text)*25;
        targets(target_idx).text_sx = targets(target_idx).position(1) - floor(text_length/2);
        targets(target_idx).text_sy = targets(target_idx).position(2)+10;
        
        % Using the correct layout order put in cooperative values and the 
        targets(target_idx).color = source_colors(layout_selection, :);
        targets(target_idx).cooperative = source_cooperative(layout_selection);
    end
    
    % Measure the Dilema's outcomes
    score = 0;

    % See if the computer cooperates or not
    pl_coop = -1;    % Cooperation value of the player
    cpu_coop = cpu.getResponce();
    
    disp([source_title, ' ' , num2str(trial_idx)]);
    disp(['Does the cpu cooperate? ', num2str(cpu_coop)]);
    disp('   1 = Yes, 0 = No');

    % Starts a timer to track how long till the experiment ends
    tic;
    elapsed_time = toc;

    % parameters.player.pos = [parameters.screen.window_width/2, ...
    %     parameters.screen.window_height - parameters.player.radius - 20];
    % LOOP STAGE
    while elapsed_time < parameters.trial.duration_s
        % Print the name of the task
        Screen('TextSize', parameters.screen.window, 70);
        DrawFormattedText(parameters.screen.window, source_title, 'center');
        Screen('TextSize', parameters.screen.window, parameters.screen.default_text_size);
        
        % Print the total score
        DrawFormattedText(parameters.screen.window, score_total_msg_prior, 'center', 120, [200, 200, 200, 255]);
        
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
            DrawFormattedText(parameters.screen.window,targets(target_idx).text,...
                targets(target_idx).text_sx ,targets(target_idx).text_sy, 252:255);
        end

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
    % If only the cpu cooperated, give 5
    % If only the player cooperated, give 0
    % If both defected, give 1
    if pl_coop && cpu_coop
        score = parameters.scores.(type).cc;
    elseif ~pl_coop && cpu_coop
        score = parameters.scores.(type).dc;
    elseif ~pl_coop && ~cpu_coop
        score = parameters.scores.(type).dd;
    elseif pl_coop && ~cpu_coop
        score = parameters.scores.(type).cd;
    end


    % Let the participant know what they scored 
    Screen('TextSize', parameters.screen.window, parameters.screen.default_text_size);
    cross_message =['You just scored: ', num2str(score), ' points!'];
    DrawFormattedText(parameters.screen.window, cross_message, 'center', 'center', color_list.white);
    Screen('Flip', parameters.screen.window);
    pause(2);
    
    % Let the participant know what their total score is
    Screen('TextSize', parameters.screen.window, parameters.screen.default_text_size);
    score_total_msg_after = [source_title, ' total score: ', num2str(score_total + score)];
    DrawFormattedText(parameters.screen.window, score_total_msg_after, 'center', 'center', color_list.white);

    Screen('Flip', parameters.screen.window);
    pause(2);

    cpu.changeBehavior(pl_coop);

    outcome = struct('player_cooperated', pl_coop, 'cpu_cooperated', cpu_coop, 'time', elapsed_time,...
        'trial_score', score, 'total_score', score_total + score);
end

