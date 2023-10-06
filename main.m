% Central Function and point of origin for the program
% It is the function that needs to be called to start the experiment and the one that ends with the experiment  
% The program allows the user to insert variables. This happens in 'InsertParams.m' 

function scores = main()
    parameters = StartUp();
    
    scores = Experiment(parameters);
    
    KbStrokeWait();
    sca;  

    ShutDown(parameters);
end 