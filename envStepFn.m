function [NextObs,Reward,IsDone,LoggedSignals] = envStepFn(Action,LoggedSignals,EnvConstants)
    %global b
    b = [1.2; 0.5];
    % check if given action is valid
    %if ~ismember(Action, [-EnvConstants.MaxForce EnvConstants.MaxForce])
    %    error('Action out of range');
    %end
    % unpack action vector
    tau = Action;
    
    % unpack state vector
    q = LoggedSignals.State;

    % apply GD step
    amin = min(EnvConstants.alpha, 1/2*max(abs(q-EnvConstants.qf)));
    q = q + amin*tau/norm(tau);
    % TODO: random walk can be done later?

    % update logged state
    LoggedSignals.State = q;

    % update observation
    %[o1, o2] = getDHOrigins(q);
    %[p1, p2] = getFloatRepPts(o1, o2, b);
    NextObs = q;

    % check terminal condition
    IsDone = (max(abs(q-EnvConstants.qf)) < EnvConstants.epsilon);
    if ~IsDone
        Reward = -norm(q-EnvConstants.qf);
        %Reward = EnvConstants.R_nonterminal
    else
        Reward = EnvConstants.R_goal;
    end

%     collided = checkCollision(p1, p2, b, EnvConstants.delta);
%     if collided
%         Reward = EnvConstants.R_collision;
%         IsDone = true;
%     else
%         IsDone = (max(abs(q-EnvConstants.qf)) < EnvConstants.epsilon);
%         if ~IsDone
%             Reward = -norm(q-EnvConstants.qf);
%             %Reward = EnvConstants.R_nonterminal
%         else
%             Reward = EnvConstants.R_goal;
%         end
%     end
end