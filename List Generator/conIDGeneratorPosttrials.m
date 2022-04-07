function [ condOrder ] = conIDGenerator( conditions, condOrder, blocksperPhase,TrialsperPostTestBlock)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

trialNum        = length(condOrder);        %how many trials are there in the phase %FRR: here conOrder = Study1Order
trialperBlock   = trialNum/blocksperPhase;  %number of trials within each block of the phase %FRR: here blocksperPhase = Study1Blocks
condNum         = length(conditions);       %number of conditions used in the phase %FRR we have 6 (FN, SN, ON,FR, SR, OR)
%condRepeat      = trialperBlock/condNum;    %how many time the set of conditions repeats within a block --> FRR ie twice within each Block here, or 34 times in the experiment. 
condRepeat      = TrialsperPostTestBlock; %if different conditions occure differently often we need to do this
counterrow      = condRepeat +1; %FRR not sure why this is +1 - maybe because first row is header??? (did not check at all) 

for block = 1:blocksperPhase
    
conID = zeros(counterrow,condNum);

    for con = 1:condNum 
        x = shuffle(linspace(1,condRepeat,condRepeat));
        conID(1:condRepeat,con)= x(1:condRepeat);
        conID(counterrow,con) = 1; 
    end
     startTrial = ((trialperBlock)*(block-1))+1;
     lastTrial = startTrial + trialperBlock -1;
    for trial = startTrial:lastTrial
        column = find(strcmp(conditions, condOrder(1,trial)));
        row = conID(counterrow,column);
        condOrder{2,trial} = [condOrder{1,trial} '_' num2str(conID(row,column))];
        conID(counterrow,column) = conID(counterrow,column) + 1;
    end
    
end


end

