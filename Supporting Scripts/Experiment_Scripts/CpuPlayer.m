classdef CpuPlayer < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Behavior_Mode   % Mode of Behavior, each mode interprets and reacts to the player's actions differently    
        Cooperation     % How likely the cpu is to cooperate with the player overall

        % Personality Profile
        Benevolence     % How benevolent the cpu is to the player (may not be needed based on Mode)
        Trust           % How much the cpu trusts the player (may not be needed based on Mode)
    end

    methods
        % Constructor
        function obj = CpuPlayer(behavior_mode,cooperation,benevolence, trust)
            if ~exist("behavior_mode", "var"); behavior_mode = 1; end
            if ~exist("cooperation","var"); cooperation = 100; end
            if ~exist("benevolence", "var"); benevolence = 100; end
            if ~exist("trust", "var"); trust = 100; end
            
            obj.Behavior_Mode = behavior_mode;
            obj.Cooperation = cooperation;
            obj.Benevolence = benevolence;
            obj.Trust = trust;
        end
        
        % Method that changes the behavior of the cpu based on the
        % participant's prior choices.
        function changeBehavior(obj, player_nice)
            if ~islogical(player_nice) || ~isscalar(player_nice)
                error("Wrong value for player choice")
            end

            switch obj.Behavior_Mode
                % cases 1-9 are for the Prisoner's Dilema experiment
                case 1
                    if player_nice; obj.Cooperation = 100; 
                    else; obj.Cooperation = 0;
                    end
                % cases 11-19 are for the Stag Hunt experiment
                case 11
                    if player_nice; obj.Cooperation = 100;
                    else; obj.Cooperation = 0;
                    end
            end
        end

        % Method that gives the cpu's responce
        function will_cooperate = getResponce(obj)
            switch obj.Behavior_Mode
                % cases 1-9 are for the Prisoner's Dilema experiment
                case 1
                    will_cooperate = obj.Cooperation >= 50;
                % cases 11-19 are for the Stag Hunt experiment
                case 11
                    will_cooperate = obj.Cooperation >= 50;
            end
        end
    end
end