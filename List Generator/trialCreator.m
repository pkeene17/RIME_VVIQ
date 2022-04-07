function [ condOrder ] = trialCreator( numTrials, conditions)
%UNTITLED Summary of this function goes here
%   


numCond = length(conditions);

if length(numTrials) < 2 %if there is an even number of trials for each condition this will create a vector with the number of trials corresponding to each condition(in this case they will all be the same)
    trialDigit = numTrials; %creates variable that represents the number of trials for each condition. This will be one number since all the conditions will have equal number of trials. 
    numTrials = [];
    for counter = 1:numCond
        numTrials(counter) = trialDigit;
    end
end

%check to see if the vector specifying the number of trials has an input
%for each condition
if length(numTrials) ~= numCond
    display('The length of the number of trials must equal the number of conditions');
elseif length(numTrials) == numCond    
condOrder = {};
end

%Creates a vector condOrder that contains each condition repeated the
%number of times specified by its corresponding input in numTrials
for condcounter = 1:numCond
    for trialcounter = 1:numTrials(condcounter)
        condOrder = [condOrder conditions{condcounter}];
    end
end

        
condOrder= Shuffle(condOrder); %shuffles the order of the conditions to create a randomized list of trials


condOrder';

end


