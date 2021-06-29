function [InitialObservation, LoggedSignal] = envResetFn()
    LoggedSignal.State = [0.0; 0.0];
    InitialObservation = [0.0; 0.0];
end
