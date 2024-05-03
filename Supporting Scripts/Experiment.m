% Function called by: main.m
% Role of function is to run the experiment, start to finish 
% Parameters: parameters (Things to be used for the experiment)
% Return Values: None

function [prison_score_table, hunt_score_table] = Experiment(parameters)

    % Carry out the Introduction to the task
    if parameters.trial.show_intro
        Introduction(parameters.screen, parameters.player, parameters.scores,parameters.target);
    end
    
    % Get some data for the prison experiment
    % prison_score = 0;
    prison_score_table = zeros(1,parameters.trial.num_trials);
    prison_option_placement = [zeros(1, floor(parameters.trial.num_trials/2)), ones(1, parameters.trial.num_trials - floor(parameters.trial.num_trials/2))] + 1;
    prison_option_placement = prison_option_placement(randperm(length(prison_option_placement)));

    % Generate data for the hunt experiment
    % hunt_score = 0;
    hunt_score_table = zeros(1,parameters.trial.num_trials);
    hunt_option_placement = [zeros(1, floor(parameters.trial.num_trials/2)), ones(1, parameters.trial.num_trials - floor(parameters.trial.num_trials/2))] + 1;
    hunt_option_placement = hunt_option_placement(randperm(length(hunt_option_placement)));
    
    %The CPU assumes the player is cooperative
    prisoner = CpuPlayer(1,100, 100, 100);
    hunter = CpuPlayer(11, 100, 100, 100);

    prison_results = [];
    hunt_results = [];
    for trial_idx = 1:parameters.trial.num_trials
        [prison_score, outcome] = RunTrial(parameters, trial_idx, sum(prison_score_table), ...
                                        prisoner, parameters.types.prison, prison_option_placement(trial_idx));
        prison_score_table(trial_idx) = prison_score;
        prison_results = [prison_results; outcome];

        [hunt_score, outcome] = RunTrial(parameters, trial_idx, sum(hunt_score_table), ...
                                        hunter, parameters.types.hunt, hunt_option_placement(trial_idx));
        hunt_score_table(trial_idx) = hunt_score;
        hunt_results = [hunt_results; outcome];
    end
    delete(prisoner);
    delete(hunter);
    directory = pwd();
    cd(parameters.trial.output_dir);
    save("results.mat", "prison_results", "hunt_results");
    cd(directory);

    Debrief(parameters.screen, [sum(prison_score_table), sum(hunt_score_table)], ["Prisoner Task", "Hunting Trip"]);

end