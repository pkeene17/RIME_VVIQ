function [preStudyOrder preTestOrder retrievalOrder baselineOrder relatedOrder testedOrder] = conIDgenerator(preStudyOrder, preTestOrder, retrievalOrder, preStudyRounds, preTestRounds, retrievalBlocks)


%baselineOrder, relatedOrder, testedOrder are not randomized. The script will randomize them later when they are assigned places within the first/second half of the final test 

%Variables
preStudyTrials = length(preStudyOrder);
preTestTrials = length(preTestOrder);
retrievalTrials = length(retrievalOrder);

trialperblockPS = preStudyTrials/preStudyRounds;
trialperblockPT = preTestTrials/preTestRounds;
trialperblockR = retrievalTrials/retrievalBlocks;

%Conditions
conditions = {'WFS-CW-NR' 'WFO-CW-NR' 'WSF-CW-NR' 'WSO-CW-NR' 'WOS-CW-NR' 'WOF-CW-NR' 'WFS-CW-R1' 'WFO-CW-R1' 'WSF-CW-R1' 'WSO-CW-R1' 'WOS-CW-R1' 'WOF-CW-R1' 'WFS-CW-R2' 'WFO-CW-R2' 'WSF-CW-R2' 'WSO-CW-R2' 'WOS-CW-R2' 'WOF-CW-R2' 'WFS-CC-NR' 'WFO-CC-NR' 'WSF-CC-NR' 'WSO-CC-NR' 'WOS-CC-NR' 'WOF-CC-NR' 'WFS-CC-R1' 'WFO-CC-R1' 'WSF-CC-R1' 'WSO-CC-R1' 'WOS-CC-R1' 'WOF-CC-R1' 'WFS-CC-R2' 'WFO-CC-R2' 'WSF-CC-R2' 'WSO-CC-R2' 'WOS-CC-R2' 'WOF-CC-R2'}; %put in your list of conditions here
% NR = Not Retrieved, R1 = Retrieved first item,  R2 = Retrieved second item, CW =
% presented clockwis, CC = presented counterclockwise
retconditions = {'WFS-CW-R1' 'WFO-CW-R1' 'WSF-CW-R1' 'WSO-CW-R1' 'WOS-CW-R1' 'WOF-CW-R1' 'WFS-CW-R2' 'WFO-CW-R2' 'WSF-CW-R2' 'WSO-CW-R2' 'WOS-CW-R2' 'WOF-CW-R2' 'WFS-CC-R1' 'WFO-CC-R1' 'WSF-CC-R1' 'WSO-CC-R1' 'WOS-CC-R1' 'WOF-CC-R1' 'WFS-CC-R2' 'WFO-CC-R2' 'WSF-CC-R2' 'WSO-CC-R2' 'WOS-CC-R2' 'WOF-CC-R2'}; %During retrieval we are only prestening the "retrieved" conditions
baselineconditions = {'WFS-CW-NR' 'WFO-CW-NR' 'WSF-CW-NR' 'WSO-CW-NR' 'WOS-CW-NR' 'WOF-CW-NR' 'WFS-CC-NR' 'WFO-CC-NR' 'WSF-CC-NR' 'WSO-CC-NR' 'WOS-CC-NR' 'WOF-CC-NR'}; 

%PreStudy Rounds
for round = 1:preStudyRounds
conID = zeros(3,length(conditions));
    for con = 1:length(conditions)
        x = shuffle([1 2]);
        conID(1:2,con)= x(1:2);
        conID(3,con) = 1; 
    end
     startTrial = ((trialperblockPS)*(round-1))+1;
     lastTrial = startTrial + trialperblockPS -1;
    for trial = startTrial:lastTrial
        column = find(strcmp(conditions, preStudyOrder(1,trial)));
        row = conID(3,column);
        preStudyOrder{2,trial} = [preStudyOrder{1,trial} '-' num2str(conID(row,column))];
        conID(3,column) = conID(3,column) + 1;
    end
    
end
 
%PreTest Rounds
for round = 1:preTestRounds
conID = zeros(3,length(conditions));
    for con = 1:length(conditions)
        x = shuffle([1 2]);
        conID(1:2,con)= x(1:2);
        conID(3,con) = 1; 
    end
     startTrial = ((trialperblockPT)*(round-1))+1;
     lastTrial = startTrial + trialperblockPT -1;
    for trial = startTrial:lastTrial
        column = find(strcmp(conditions, preTestOrder(1,trial)));
        row = conID(3,column);
        preTestOrder{2,trial} = [preTestOrder{1,trial} '-' num2str(conID(row,column))];
        conID(3,column) = conID(3,column) + 1;
    end
    
 end
        
%Retrieval Rounds
for round = 1:retrievalBlocks
    conID = zeros(3,length(retconditions));
    for con = 1:length(retconditions)
        x = shuffle([1 2]);
        conID(1:2,con) = x(1:2);
        conID(3,con) = 1;
    end
    startTrial = ((trialperblockR)*(round-1))+1;
    lastTrial = startTrial + trialperblockR -1;
    for trial = startTrial:lastTrial
        column = find(strcmp(retconditions, retrievalOrder(1,trial)));
        row = conID(3,column);
        retrievalOrder{2,trial} = [retrievalOrder{1,trial} '-' num2str(conID(row,column))];
        conID(3,column) = conID(3,column) + 1;
    end
end

%Final Test Trials

%baselineOrder
baselineOrder = [baselineconditions baselineconditions baselineconditions baselineconditions];

for rep = 1:2
condID = zeros(3,12);
    for con = 1:12
       x = shuffle([1 2]);
        condID(1:2,con)= x(1:2);
        conID(3,con) = 1; 
    end
        startTrial = (24*(rep-1)+1);
        lastTrial = (startTrial +23);
    for trial = startTrial:lastTrial
        column = find(strcmp(baselineconditions, baselineOrder(1,trial)));
        row = conID(3,column);
        baselineOrder{2,trial} = [baselineOrder{1,trial} '-' num2str(conID(row,column))];
        conID(3,column) = conID(3,column) + 1;
    end
end

%relatedOrder
relatedOrder = [retconditions retconditions];

%for rep = 1:2
condID = zeros(3,24);
    for con = 1:24
       x = shuffle([1 2]);
        condID(1:2,con)= x(1:2);
        conID(3,con) = 1; 
    end
        startTrial = (48*(rep-1)+1);
        lastTrial = (startTrial + 47);
    for trial = 1:48
        column = find(strcmp(retconditions, relatedOrder(1,trial)));
        row = conID(3,column);
        relatedOrder{2,trial} = [relatedOrder{1,trial} '-' num2str(conID(row,column))];
        conID(3,column) = conID(3,column) + 1;
    end
%end

%testedOrder
testedOrder = [retconditions retconditions];

%for rep = 1:2
condID = zeros(3,24);
    for con = 1:24
       x = shuffle([1 2]);
        condID(1:2,con)= x(1:2);
        conID(3,con) = 1; 
    end
        startTrial = (48*(rep-1)+1);
        lastTrial = (startTrial + 47);
    for trial = 1:48
        column = find(strcmp(retconditions, testedOrder(1,trial)));
        row = conID(3,column);
        testedOrder{2,trial} = [testedOrder{1,trial} '-' num2str(conID(row,column))];
        conID(3,column) = conID(3,column) + 1;
    end
%end

end