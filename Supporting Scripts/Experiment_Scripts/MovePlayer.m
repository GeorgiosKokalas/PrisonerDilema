% Function called by:
%   - Introduction.m
%   - RunTrial.m
% Role of function is to introduce the participant to the experiment
% Parameters: 
%   - start_pos (position before movement)
%   - speed (the speed multiplier of the player)
%   - radius (the radius of the player)
%   - win_dims (the dimensions of the window in which the experiment takes place)
% Return Values: 
%   - end_pos (vector of 2 | position after movement)
%   - player_rect (vector of 4 | used by Screen to draw the player)

function [end_pos, player_rect] = MovePlayer(start_pos, speed, radius, win_dims)
    %---jst is not written by me, it was the only script I found that could successfully get gamepad input---%
    %don't amplitfy small movements
    % joystick = jst;
    % joystick(abs(joystick) < 0.05) = 0;
    joystick = GetXBox().LMovement;
        
    % Calculate the new Position based on the previous one and the joystick movement
    % end_pos, start_pos and joystick are vectors of 2
    end_pos = floor(start_pos + joystick*speed);
    % end_pos = start_pos;
    % end_pos(1) = floor(start_pos(1) + joystick(2) * speed);
    % end_pos(2) = floor(start_pos(2) + joystick(1) * speed);

    % Check if the player is going out of bounds
    for idx = 1:numel(end_pos)
        out_of_bounds = end_pos(idx) < radius || ...
            end_pos(idx) > win_dims(idx) - radius;
        if out_of_bounds
            end_pos(idx) = start_pos(idx);
        end
    end
    
    % Calculate the values Screen needs to draw the player
    player_rect = [end_pos(1) - radius, end_pos(2) - radius, ...
        end_pos(1) + radius, end_pos(2) + radius];
end

