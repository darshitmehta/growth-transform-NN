% This code is a sample script for running the growth transform neural
% network on a GPU supported by MATLAB.

% Copyright (c) [2018] Washington University  in St. Louis Created by:
% [Darshit Mehta, Ahana Gangopadhyay, Kenji Aono, Shantanu Chakrabartty] 1.
% Gangopadhyay, A., and Chakrabartty, S. (2017). Spiking, bursting, and
% population dynamics in a network of growth transform neurons. 2.
% Gangopadhyay, A., Chatterjee, O., and Chakrabartty, S. (2017). Extended
% polynomial growth transforms for design and training of generalized
% support vector machines. IEEE Transactions on Neural Networks and
% Learning Systems 3.  Gangopadhyay, A., Aono, K.  Mehta, D., and
% Chakrabartty, S. (in Review). A Coupled Network of Growth Transform
% Neurons for Spike-Encoded Auditory Feature Extraction
% 
% Washington University hereby grants to you a non-transferable,
% non-exclusive, royalty-free, non-commercial, research license to use and
% copy the computer code provided here (the “Software”).  You agree to
% include this license and the above copyright notice in all copies of the
% Software.  The Software may not be distributed, shared, or transferred to
% any third party.  This license does not grant any rights or licenses to
% any other patents, copyrights, or other forms of intellectual property
% owned or controlled by Washington University.  If interested in obtaining
% a commercial license, please contact Washington University's Office of
% Technology Management (otm@dom.wustl.edu).
% 
% YOU AGREE THAT THE SOFTWARE PROVIDED HEREUNDER IS EXPERIMENTAL AND IS
% PROVIDED “AS IS”, WITHOUT ANY WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED,
% INCLUDING WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY OR FITNESS FOR
% ANY PARTICULAR PURPOSE, OR NON-INFRINGEMENT OF ANY THIRD-PARTY PATENT,
% COPYRIGHT, OR ANY OTHER THIRD-PARTY RIGHT.  IN NO EVENT SHALL THE
% CREATORS OF THE SOFTWARE OR WASHINGTON UNIVERSITY BE LIABLE FOR ANY
% DIRECT, INDIRECT, SPECIAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN
% ANY WAY CONNECTED WITH THE SOFTWARE, THE USE OF THE SOFTWARE, OR THIS
% AGREEMENT, WHETHER IN BREACH OF CONTRACT, TORT OR OTHERWISE, EVEN IF SUCH
% PARTY IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. YOU ALSO AGREE THAT
% THIS SOFTWARE WILL NOT BE USED FOR CLINICAL PURPOSES.

%% Setup parameters
profile clear
profile -memory on
nNeuron = 1e3;
nIter = 1000;
nInput = min(25,nNeuron/10);
parallel.gpu.rng(1234, 'MRG32K3A');
% Q = zeros(nNeuron);
% Q = Q-diag(diag(Q));
% Q = gpuArray(Q);

Q = gpuArray.sprandn(nNeuron,nNeuron,0.005);

iInput = sparse(nNeuron,1,zeros);
iInput(randperm(nNeuron,nInput),:) = 0.025*randn(nInput,1);
bias = gpuArray([0.6-0.5*iInput -0.6+0.5*iInput]);
% clear iInput

epsilon = 0.1;
u = 0.5 + epsilon;
l = 0.5 - epsilon;
P(:,1) = l -0.001;
P(:,2) = u +0.001;
P = gpuArray(P);
weight = gpuArray(5);
epTh = gpuArray(epsilon+0.5);
epSub = gpuArray(2*epsilon);
clear epsilon
Fac = gpuArray(12);
outFile = 'y.bin';
fHandle = fopen(outFile,'w');
%% Core computation
for c1 = 1:nIter
    G = Q*[P(:,1) P(:,2)-epSub]; % Gradient
    P = P.*(Fac-bias-P-G-weight*(0.5<P & P<=epTh)+(P<0.5)); % Growth Transform
    P = P./sum(P,2); % Normalize
    fwrite(fHandle,gather(diff(P,1,2)<0));
    fprintf(fHandle,'\n');
end
fclose(fHandle);
profile viewer

%% Show results
fHandle = fopen(outFile,'r');
y = fread(fHandle,[nNeuron+1 nIter],'*logical');
fclose(fHandle);
y(end,:) = [];
figure;
imagesc(y);