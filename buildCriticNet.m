function Net = buildCriticNet()
    obsPath = [
        featureInputLayer(2, 'Normalization','none','Name','observation')
        fullyConnectedLayer(4,'Name','QobsFC1')
        reluLayer('Name','QobsReLU1')
        fullyConnectedLayer(4,'Name','QobsFC2')
    ];

    actPath = [
        featureInputLayer(2, 'Normalization','none','Name','torque')
        fullyConnectedLayer(4,'Name','QactFC1')
    ];
    
    comPath = [
        additionLayer(2,'Name', 'add')
        reluLayer('Name','QcomReLU1')
        fullyConnectedLayer(4, 'Name', 'QcomFC1')
        reluLayer('Name','QcomReLU2')
        fullyConnectedLayer(1, 'Name', 'output')
    ];
    
    tempNet = layerGraph(obsPath);
    tempNet = addLayers(tempNet, actPath);
    tempNet = addLayers(tempNet, comPath);
    tempNet = connectLayers(tempNet, 'QobsFC2', 'add/in1');
    Net = connectLayers(tempNet, 'QactFC1', 'add/in2');
end