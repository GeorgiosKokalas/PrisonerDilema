% Function called by: main.m
% Role of function is to run the experiment, start to finish 
% Parameters: parameters (Things to be used for the experiment)
% Return Values: None

function score_table = Experiment(parameters)

    % Carry out the Introduction to the task
    if parameters.trial.show_intro
        Introduction(parameters.screen, parameters.cross, parameters.player);
    end
    
    score = 0;
    score_table = zeros(1,parameters.trial.num_trials);
    for trial_idx = 1:parameters.trial.num_trials
        score = RunTrial(parameters, trial_idx, sum(score_table), score);
        score_table(trial_idx) = score;
    end

    Debrief(parameters.screen);

end