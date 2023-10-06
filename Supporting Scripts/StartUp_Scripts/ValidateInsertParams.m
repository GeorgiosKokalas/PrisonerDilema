% Function called by: InsertParams.m
% Role of function is to validate all user-inserted parameters
% Parameters: in_pars (struct that contains all inserted parameters)
% Return Values: in_pars (in_pars after validation)
% Function that is aimed to validate all inserted parameters by the user. 
%   If values are invalid they are updated. More parameters are also added.

function in_pars = ValidateInsertParams(in_pars)
    load('colors.mat','color_list');
    
    %in_pars.screen extra variables (dependent on user-defined variables)
    in_pars.screen.custom_screen_ = false;         % dependent on start_point, height and width
    in_pars.screen.window = -1;                    % will be used to hold the window (-1 is a placeholder)
    in_pars.screen.center = [0,0];                 % will be used to represent the center of the window
    in_pars.screen.screen_width = 0;               % the width of the screen in which the window will be housed 
    in_pars.screen.screen_height = 0;              % the height of the screen in which the window will be housed 
    in_pars.screen.window_dims = [0,0];            % the dimensions of the window (combines width and height)    

    % in_pars.screen - VALUE EVALUATION
    % Evaluating color
    if ~isrgba(in_pars.screen.color)
        disp("Inoperable value provided for in_pars.screen.color. Applying default...");
        in_pars.screen.color = color_list.grey;
    end
    
    % Evaluating screen (must be within the acceptable range of the available Screens
    if ~isnat(in_pars.screen.screen) || in_pars.screen.screen > max(Screen('Screens'))
        disp("Inoperable value provided for in_pars.screen.screen. Applying default...");
        in_pars.screen.screen = max(Screen('Screens'));
    end

    % Evaluating default_text_size (must be a positive integer)
    if ~ispos(in_pars.screen.default_text_size)
        disp("Inoperable value provided for in_pars.screen.default_text_size. Applying default...");
        in_pars.screen.default_text_size = 40;
    end

    % Evaluating score_text_size (must be a positive integer)
    if ~ispos(in_pars.screen.score_text_size)
        disp("Inoperable value provided for in_pars.screen.score_text_size. Applying default...");
        in_pars.screen.score_text_size = 80;
    end

    % change the value of screen_width and screen_height based on the screen
    [in_pars.screen.screen_width, in_pars.screen.screen_height] = Screen('WindowSize', in_pars.screen.screen);
    
    % change the value of custom_screen_ based on the value of start_point 
    dims = [in_pars.screen.screen_width, in_pars.screen.screen_height];
    if ~isloc(in_pars.screen.start_point, dims)
        disp("Inoperable value provided for in_pars.screen.start_point. Applying default...");
        in_pars.screen.start_point = [0, 0];
    end
    
    % change the value of custom_screen_ based on the value of height and width
    make_custom_screen = ispos(in_pars.screen.window_height) && ...          & too long for 1 line 
        ispos(in_pars.screen.window_width) && ...
        in_pars.screen.window_height <= in_pars.screen.screen_height && ...
        in_pars.screen.window_width <= in_pars.screen.screen_width;
    if make_custom_screen   
        disp("Custom Valus provided for Width and Length. Abandoning FullScreen Mode...");
        in_pars.screen.custom_screen_ = true;
    else 
        disp("Assuming FullScreen Mode.");
        [in_pars.screen.window_width, in_pars.screen.window_height] = Screen('WindowSize', in_pars.screen.screen);
    end

    % change the value of in_pars.screen.center, based on screen width and height
    in_pars.screen.center = [in_pars.screen.window_width / 2, in_pars.screen.window_height / 2];

    % change the value of in_pars.screen.window_dims
    in_pars.screen.window_dims = [in_pars.screen.window_width, in_pars.screen.window_height];



    %in_pars.target - VALUE EVALUATION
    %Evaluating possible_radii (must be a vector containing natural numbers)
    if ~ispos(in_pars.target.radius)
        disp("Inoperable value provided for in_pars.target.radius. Applying default...");
        in_pars.target.radius = 80;
    end

    
    % Extra values for in_pars.player
    in_pars.player.speed = 0;
    in_pars.player.pos = [0,0];

    %in_pars.player - VALUE EVALUATION
    % Evaluating radius (must be a positive number)
    if ~ispos(in_pars.player.radius)
        disp("Inoperable value provided for in_pars.player.radius. Applying default...");
        in_pars.player.radius = 10;
    end
    
    %Evaluating color (must be an rgba value)
    if ~isrgba(in_pars.player.color)
        disp("Inoperable value provided for in_pars.player.color. Applying default...");
        in_pars.player.color = color_list.blue;
    end

    % Evaluating speed_percent (must be a natural number)
    if ~isnat(in_pars.player.speed_percent)
        disp("Inoperable value provided for in_pars.player.speed_percent. Applying default...");
        in_pars.player.speed_percent = 100;
    end

    % Evaluating start_pos (must be a vector of 2 strings) and changing the value of pos 
    win_dims = [in_pars.screen.window_width, in_pars.screen.window_height];
    if length(in_pars.player.start_pos) ~= 2
        disp("Inoperable value provided for in_pars.player.start_pos. Applying default...");
        in_pars.player.start_pos = ["bottom", "center"];
    end
    for idx=1:numel(win_dims)
        switch in_pars.player.start_pos(idx)
            case "top"
                in_pars.player.pos(idx) = in_pars.player.radius + 20;
            case "center"
                in_pars.player.pos(idx) = win_dims(idx) / 2;
            case "bottom"
                in_pars.player.pos(idx) = win_dims(idx) - (in_pars.player.radius + 20);
            otherwise
                disp("Inoperable value provided for one of in_pars.player.start_pos. Applying default...")
                in_pars.player.pos(idx) = win_dims(idx) / 2;
        end
    end

    % change the value of speed (dependent on speed percent)
    in_pars.player.speed = (in_pars.player.speed_percent / 100) + 1; 



    %inin_pars.cross - VALUE EVALUATION
    %Evaluating in_pars.cross.color (must be a rgba value)
    if ~isrgba(in_pars.cross.color)
        disp("Inoperable value provided for in_pars.cross.color. Applying default...");
        in_pars.cross.color = color_list.white;
    end

    % Evaluating in_pars.cross.thickness
    if ~ispos(in_pars.cross.thickness)
        disp("Inoperable value provided for in_pars.cross.thickness. Applying default...");
        in_pars.cross.thickness = 3;
    end

    % Evaluating in_pars.cross.width
    if ~ispos(in_pars.cross.width)
        disp("Inoperable value provided for in_pars.cross.width. Applying default...");
        in_pars.cross.width = 30;
    end

    % Extra Values for in_pars.cross
    in_pars.cross.coords = [-in_pars.cross.width / 2, in_pars.cross.width / 2, 0, 0; ...
        0, 0, -in_pars.cross.width / 2, in_pars.cross.width / 2];



    %in_pars.trial - VALUE EVALUATION
    % Evaluating num_trials (must be a natural number)
    if ~isnat(in_pars.trial.num_trials)
        disp("Inoperable value provided for in_pars.trial.num_trials. Applying default...");
        in_pars.trial.num_trials = 100;
    end
    
    % Evaluating duration_s (must be a natural number)
    if ~isnat(in_pars.trial.duration_s)
        disp("Inoperable value provided for in_pars.trial.duration_s. Applying default...");
        in_pars.trial.duration_s = 20;
    end

    %Evaluating and creating output_dir (must be a single string and able to create a directory)
    % Make sure we have an actual string
    if ~isscalar(in_pars.trial.output_dir) || ~isstring(in_pars.trial.output_dir)
        disp("Inoperable value provided for in_pars.trial.output_dir. Applying default...");
        in_pars.trial.output_dir = 'Default_Dir';
    end
    % Ask the user where the string will be stored
    while true
        get_dir = uigetdir('.', 'Please select where the output directory will be created');
        if get_dir
            break
        end
        waitfor(msgbox("Please select a valid directory to store the output of the experiment.", "Invalid Output Directory"));
    end
    if mkdir(append(get_dir, "/",in_pars.trial.output_dir)) == 1
        in_pars.trial.output_dir = append(get_dir, "/",in_pars.trial.output_dir, "/");
    else
        in_pars.trial.output_dir = "Output/Default_Dir";
        disp("Unable to create directory. Creating Default_dir...");
        mkdir(in_pars.trial.output_dir);
    end

    % Evaluating show_intro
    if ~islogical(in_pars.trial.show_intro) || ~isscalar(in_pars.trial.show_intro)
        disp("Inoperable value provided for in_pars.trial.show_intro. Applying default...");
        in_pars.trial.show_intro = true;
    end

end




% Custom functions to make the code above more readable
%Checks if a value is a single number
function result = isnum(input)
    result = isscalar(input) && isnumeric(input);
end


%Checks if a value is a natural number (including 0, ...and decimals)
function result = isnat(input)
    % I define naturals as any number equal to or above 0
    result = isnum(input) && input >= 0;
end


%Checks if a value is a positive integer (excluding 0)
function result = ispos(input)
    %Check if this is a number above 0
    result = isnum(input) && input > 0;
end


% Checks if a value is a vector pretaining to a specific color
function result = isrgba(input)
    % RGBA values are represented as vectors of 4 elements (numbers)
    result = isvector(input) && numel(input) == 4;

    % If this is a vector, check if every element is a natural no greater than 255 
    if result
        for idx = 1:numel(input)
            if ~isnat(input(idx)) || input(idx) > 255
                result = false;
            end
        end
    end
end


function result = isloc(input, Dimensions)
    % Locations are vectors of x and y axes
    result = isvector(input) && numel(input) == 2;

    %Check if the values of the x and y axis are within the acceptable value for our screen  
    % [screen_width, screen_height] = Screen('WindowSize', Screen_Number);
    if result
        result = isnat(input(1)) && input(1)<Dimensions(1) && isnat(input(2)) && input(2)<Dimensions(2);
    end
end