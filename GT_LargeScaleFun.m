function [y, yInit, spk,dp] = GT_LargeScaleFun(Q,I_input,nIter,yInit,dp)
%GROWTHTRANSFORMNEURONS Growth Transform Neuron Model
% 	This function creates a GUI for simulating large network of Neuron
% 	Models based on
% growth transforms (Ref. 1, 2). More details about the model and its
% applications can be found in Ref. 3. In brief, the Growth Transform (GT)
% Neuron Network generates spiking activity while minimizing an objective
% function. The GUI simulates a network of neurons with inhibitory and
% excitatory connections. Inputs to the function are:
% 
% Q - connectivity matrix square matrix of size = number of neurons with 
% diagnoal elements = 0
% I_input - input current 
% nIter - number of iterations 
% yInit - the initial state

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

nNeuron = size(Q,1);
% Set synaptic weight matrix
% Uncoupled case

% Spike parameters
thr = 0;

% Initialize iteration variables

% Convergence hyperparameters
C = 0*ones(nNeuron,1);  %Regularization hyper-parameter
Fac = 10;
%spikecount = zeros(nNeuron,1);
exp_ad = 9.99*ones(nNeuron,1);
y = zeros(nNeuron,nIter);
y(:,1) = yInit;

for c1 = 2:nIter
     % External stimuli current
     I = I_input-0.007+0.005*randn(size(I_input));  
 
     ind = (dp > thr);        
     C = exp_ad/10.*C + 1*ind;                               
     TotInp = 1*Q*C - 0.1*C;
     a_iter = 0.5*(1+0.95*tanh(2*TotInp));

     a_iter(ind,:) = 1;

     dpprev = dp; 
%        quant = sec.*(ind) - dec.*(dp <= thr);
     quant = 3*(ind) - 0*(dp <= thr);        
     G = 1*I - Q*dp - 1*dp - quant; % Gradient - self-inhibitory  
     dp = (G + Fac.*dp)./(dp.*G + Fac);
     if any(abs(dp))> 1
        fprintf('No growth\n')
     end
     dp = a_iter.*dp + (1-a_iter).*dpprev;
     y(:,c1) = dp + 0.5*(ind);
end
yInit = y(:,end);
spk = y(:,2:end)>0;