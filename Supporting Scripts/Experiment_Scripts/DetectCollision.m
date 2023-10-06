% Function called by: RunTrial.m
% Role of function is to detect collisions between entities
% Parameters: 
%   - player (data from the player)
%   - targets (data from the targets)
% Return Values: 
%   - player_target_collision (vector of logicals - shows if and
%       with which targets the player has collided)

function [player_target_collision, cooperated] = DetectCollision(player, targets)
    cooperated = -1;
    player_target_collision = false;

    % Detect if player has collided with each of the targets
    for target_idx=1:length(targets)
        p_t_dist = sqrt((player.pos(1) - targets(target_idx).position(1))^2 + ...
            (player.pos(2) - targets(target_idx).position(2))^2); % The screen is like a grid. thus I use the Pythagorean Theorem to get the distance between the 2 centers
        player_target_collision = p_t_dist <= (player.radius + targets(target_idx).radius);

        if player_target_collision
            cooperated = double(targets(target_idx).cooperative);
            return;
        end
    end
end

