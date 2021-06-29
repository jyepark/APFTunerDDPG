clear variables
close all

%%%%% ENVIRONMENT SETUP %%%%%%

%% define observation and action specifications
obsInfo = rlNumericSpec([2 1]);
obsInfo.Name = 'observation';
%obsInfo.Description = 'q1, q2';

actInfo = rlNumericSpec([2 1]);
actInfo.Name = 'torque';
%actInfo.Description = 'tau1, tau2';
%actInfo.UpperLimit = inf;
%actInfo.LowerLimit = -inf;

%% define environment constants
envConstants.alpha = 0.02;
envConstants.epsilon = 0.001;
envConstants.delta = 0.05;
envConstants.R_goal = 1000;
%envConstants.R_nonterminal = -1;
envConstants.R_collision = -2000;
envConstants.qf = [pi/2; pi/2];

%global b of1 of2
%b = [1.2; 0.5]; % single point obstacle coordinate
%[of1, of2] = getDHOrigins(envConstants.qf); % DH coordinate of goal configuration

%% define hyperparameters
%global d rho0
%d = 0.5;    % attractive field radius hyperparameter
%rho0 = 0.5; % repulsive field radius hyperparameter

%% env Step & Reset fn in envStepFn.m & envResetFn.m
StepHandle = @(Action,LoggedSignals) envStepFn(Action,LoggedSignals,envConstants);
ResetHandle = @() envResetFn();

%% create env
env = rlFunctionEnv(obsInfo, actInfo, StepHandle, ResetHandle);

%%%%% AGENT & LEARNING SETUP %%%%%
init_zeta1 = 10.0;
init_zeta2 = 1.0;
init_eta1  = 0.1;
init_eta2  = 0.1;
W0 = [
    init_zeta1   0;
    init_eta1    0;
    init_zeta2   0;
    init_eta2    0;
    0   init_zeta2;
    0   init_eta2
];

%% define actor, critic
%repOpts = rlRepresentationOptions('UseDevice', "gpu");
BasisHandle = @(obsState) genTorqueBasis(obsState);
actor = rlDeterministicActorRepresentation({BasisHandle,W0},obsInfo,actInfo);

Qnet = buildCriticNet();
critic = rlQValueRepresentation(Qnet,obsInfo,actInfo,'Observation',{'observation'},'Action',{'torque'});

%% define agent
agentOpts = rlDDPGAgentOptions;
agentOpts.NoiseOptions.StandardDeviation = [0.4; 0.4];
agentOpts.NoiseOptions.StandardDeviationDecayRate = 1e-4;

agent = rlDDPGAgent(actor, critic, agentOpts);

%simOpts = rlSimulationOptions('MaxSteps',100,'UseParallel', true);
%simEnv = sim(agent, env);

%%%%% LEARNING %%%%%
%% train in main script
trainOpts = rlTrainingOptions;
trainOpts.MaxEpisodes = 10000;
trainOpts.MaxStepsPerEpisode = 1000;
trainOpts.StopTrainingCriteria = "EpisodeReward";
trainOpts.StopTrainingValue = 200;
%trainOpts.UseParallel = true;
%trainOpts.ParallelizationOptions.Mode = "async";

trainStats = train(agent, env, trainOpts);
%trainStats = train(agent, env);

save('initTrain.mat', 'trainStats');

