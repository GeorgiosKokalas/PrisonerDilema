% Function called by: StartUp.m
% Role of function is to generate all user-inserted parameters
% Parameters: None
% Return Values: in_pars (struct that contains all inserted parameters)
% InsertParams is the function used by StartUp.m to generate all toggleable values. 
% This means that any value that can be safely changed by the user should be done here. 

function in_pars = InsertParams()
    in_pars = struct;
    in_pars.screen = struct;
    in_pars.target = struct;
    in_pars.player = struct;
    in_pars.cross = struct;
    in_pars.trial = struct;
    load('colors.mat','color_list');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % User defined variables below %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % in_pars.screen - Determines the color of the screen the participant will be playing in 
    in_pars.screen.color = color_list.grey;      % RGBA - Determines the color of the screen
    
    % Optional parameters, best left untouched.
    in_pars.screen.screen = max(Screen('Screens'));% Select the Screen you want to use.
    in_pars.screen.start_point = [0, 0];           % Vector - Determines the upmost left corner of the screen. [0,0] is the default 
    in_pars.screen.window_height = 0;              % Integer - Determines the Height of the window. 0 will make the program FullScreen 
    in_pars.screen.window_width = 0;               % Integer - Determines the Width of the window. 0 will make the program FullScreen
    in_pars.screen.default_text_size = 40;         % Integer - Determines the default text size
    in_pars.screen.score_text_size = 50;           % Integer - Determines the font of the text size announcing the total score


    %in_pars.target - Determines the parameters of the targets
    in_pars.target.radius = 200;                           % Integer - The radius of the targets

    %in_pars.cross - Determines the parameters for the cross (best left alone)
    in_pars.cross.color = color_list.white;         % RGBA - Determines the color of the cross
    in_pars.cross.thickness = 3;                    % Positive Integer - Determines the thickness of the cross lines
    in_pars.cross.width = 30;                       % Positive Integer - Determines the thickness of the cross lines

    %in_pars.player - Determines the parameters of the player
    in_pars.player.radius = 30;                          % Positive Number - Determines the radius of the player
    in_pars.player.color = color_list.green;             % RGBA - Determines the color of the player
    in_pars.player.speed_percent = 500;                  % Percentage - Determines how fast the player will be. 100 is normal 
    in_pars.player.start_pos = ["center", "center"];     % Vector of 2 strings: 1st argument is position on x-axis, 2nd is position on y-axis


    %in_pars.trial - Variables that will affect the experiment as a whole
    in_pars.trial.num_trials = 100;                      % Natural Number - Determines the amount of trials that will run
    in_pars.trial.duration_s = 60;                       % Natural Number - Determines the duration of each trial
    in_pars.trial.output_dir = "LM";                  % String - The name of the directory in which the output will be stored.
    in_pars.trial.show_intro = true;                     % Logical - Whether or not we want to show the intro to the player

    in_pars = ValidateInsertParams(in_pars);
end

