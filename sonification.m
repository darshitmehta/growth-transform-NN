filename = 's_1000.txt';
[convertMat, delimiterOut] = importdata(filename); % delimeter:comma, convert txt file in to Array
mySpikeMat = zeros(1000,100);                      % 1000: number of Traing Data, 
                                                   % 100: number of iterations from neurons_cblas.c file in gtn.                             
for row_convertMat = 1: size(convertMat,1)
    mySpikeMat(convertMat(row_convertMat,1)+1, convertMat(row_convertMat,2)) = 1;
    % Generating mySpikeMat(Number of Training Data * Number of iterations)
    %
    %   -  Our 1000 neurons are named from 0 to 999, but since Matlab index
    %      start from 1, I have added +1 to the column assign of mySpikeMat
end
%disp(mySpikeMat(699,24));                           % Test of mySpikeMat generation successful


%%%%%%%%%%%%%%%%%%%%%%% Generating Raster plot %%%%%%%%%%%%%%%%%%%%%%

dt=1/1000;                                         % s
tSim = 1;                                          % tSim:length of simulation... another way of representing nBins
tVec = 0:dt:tSim-dt;
logical_mySpikeMat = logical(mySpikeMat);          % Converts mySpikeMat(type:double) into type:logical

plotRaster(logical_mySpikeMat, tVec*1000);
xlabel('Iteration cycle');
ylabel('Neuron Number');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------- Generating Sounds ---------------------------
fr = 1000;
%soundvec = int32(soundvec);
for row = 1:size(mySpikeMat,1)
    fprintf('Current Nueron Number : %d\n', row);
    soundvec = mySpikeMat(row,:);                  % create sound vector for each row (each trials)
    fprintf('Number of Spikes : %d\nCurrent Sound Frequency : %d Hz\n\n', nnz(soundvec==1), fr); %display the number of spikes for each neuron
    soundvec = soundvec';
    for element = 1:size(soundvec)
        if soundvec(element) == 1
            sound(soundvec,fr);                    % play sound of the soundvec
                                                   % fr: sound frequency
        end
        pause(0.02);                               % pause for 0.02 second
    end
    fr = fr + 250;                                 % Increase frequency of sound every trial
    
    %disp(soundvec);                                 % test. uncomment 3 lines to check
    %                                                % if each soundvec is accessed well.
    %break
end

%--------------------------------------------------------------------