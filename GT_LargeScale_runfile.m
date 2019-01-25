% Creting a network with 300 neurons in the input layer and 700 neurons in
% the second layer
nNeuron = 1000;
l1Neuron = 300;
Q = createNet(nNeuron,l1Neuron,1);
%Graph functions are used to generate X and Y coordinates from the
%connectivity matrix. The graphs can be examined by commenting out close
%fig commands.
G1 = digraph(Q(1:l1Neuron,1:l1Neuron));
fig1 = figure;
hGraph = plot(G1,'Layout','force');
Xc1 = hGraph.XData;
Yc1 = hGraph.YData;
close(fig1)
G1 = digraph(Q(1+l1Neuron:end,1+l1Neuron:end));
fig2 = figure;
hGraph = plot(G1,'Layout','force');
Xc2 = hGraph.XData;
Yc2 = hGraph.YData;
close(fig2)
X = [Xc1 Xc2+-min(Xc2)+max(Xc1)+2];
Y = [Yc1 Yc2];
GT_LargeScaleGUI(Q,X,Y,l1Neuron)
