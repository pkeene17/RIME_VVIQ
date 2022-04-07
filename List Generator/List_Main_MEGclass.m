
%This list with inlcude
%1 condition
%2 conditionID
%3 word ID 
%4 image ID (face, scene or object)
%5 word name 
%6 image name
%7 mini block number
%8 category (face 1; scene 2; object 3;)


clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Variables
%Subjects
numSub = 40; %put the number of subjects here

%Conditions
conditions = {'F' 'S' 'O'}; %put in your list of conditions here
% F = face ; S = scene ; O  = object
numCond = length(conditions);

blockrow = 7; %identify the row in the list where you want to insert the block number

%Number of Trials Per Block
%of the unique trials) 
Study1Trials = 300;
Study2Trials = 300;%This the number of trials a subjects learns during the B study rounds (the number of blocks will dicate how many times they are exposed to each trial)
TestTrials = 300;
uniqueTrials = 300; %This is the number of unique image pairings that will be learned during the study
numTrials = 4; %This is an array that specifies the number of trials for each condition to be randomzied within a bin. If all the conditions have the same amount of trials then you can put just the single number for how many trials for each condition.  ie. If each condition has 6 trials just write 6.
TrialsperBlock = numCond*numTrials;

%Number of Rounds per Study Phase
Study1Blocks = 1; 
Study2Blocks = 1;
TestBlocks = 1;

%Load Stimuli Names
excelFile = 'stimuli_list_MEGclass.txt'; %must be a text file
stimList = read_table(excelFile);
    %col 1 = words
    %col 2 = wordID
    %col 3 = faces
    %col 4 = faceID
    %col 5 = scenes
    %col 6 = sceneID
    %col 7 = objects
    %col 8 = objectID
    
 %Load StimIDS
 load stimIDs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATE THE LISTS

for subject = 1:numSub

%Generate the list of conditions (no IDS yet) for all the
%phases

%Study1
x= 0;
while x == 0
Study1Order = [];
    for blocks = 1:Study1Blocks %For each round this will create a randomized list of all the trials in the prestudyphase, with a randomized order for each bin of 12 pairs (4 trials for each condition). 
          for conRepeats = 1:Study1Trials/TrialsperBlock %counts how many times the number of trials for each condition repeats within each block
           Study1Order= [Study1Order trialCreator(numTrials, conditions)];%This ensures that the randomized order is binned into sets of 12 
          end 
    end
        [check] = serialPosChecker(Study1Order,conditions,.1);
        if check == 1
            x =1;
        end
end

% Study2Order = [];
% for blocks = 1:Study2Blocks %For each round this will create a randomized list of all the trials in the prestudyphase, with a randomized order for each bin of 12 pairs (4 trials for each condition). 
%       for conRepeats = 1:Study2Trials/TrialsperBlock %counts how many times the number of trials for each condition repeats within each block
%        Study2Order= [Study2Order trialCreator(numTrials, conditions)];%This ensures that the randomized order is binned into sets of 12 
%       end 
% end
% 
% TestOrder = [];
% for blocks = 1:TestBlocks %For each round this will create a randomized list of all the trials in the prestudyphase, with a randomized order for each bin of 12 pairs (4 trials for each condition). 
%       for conRepeats = 1:TestTrials/TrialsperBlock %counts how many times the number of trials for each condition repeats within each block
%        TestOrder= [TestOrder trialCreator(numTrials, conditions)];%This ensures that the randomized order is binned into sets of 12 
%       end 
% end


%Assign condition IDS
[Study1Order] = conIDGenerator(conditions,Study1Order,Study1Blocks);

%Within each block of 12 the participant will study 12 word-picture pairs,
%thn study the same 12 pairs in a different order, they will then be tested
%on those sam pairs in a different order. We therefore need study2order and
%testorder to use the same condition ids from study1order within a given block
x= 0;
while x == 0
    for miniblock = 1:Study1Trials/TrialsperBlock %go through each block (set of 12)
        firstpos = (miniblock-1)*TrialsperBlock+1;
        endpos = firstpos + TrialsperBlock-1;
        conIDs(1:TrialsperBlock) = Study1Order(2,firstpos:endpos); %Create list of conIDs for each block

        Study2Order(2,firstpos:endpos) = shuffle(conIDs); %Randomize the blocks' condID order for Study2
        TestOrder(2,firstpos:endpos) = shuffle(conIDs);   %Randomize the blocks' condID order for Test

        %Extract the condition type from the conID
        for cond = 1:length(conIDs)
            Study2con{cond} = Study2Order{2,cond+firstpos-1}(1); %This will be an array of just th conditions without th identifying number
            Testcon{cond} = TestOrder{2,cond+firstpos-1}(1);
        end

        %Assign condition to Study2 and Test
        Study2Order(1,firstpos:endpos) = Study2con;
        TestOrder(1,firstpos:endpos) = Testcon;

    end
        [check] = serialPosChecker(Study1Order,conditions,.2);
        if check == 1
            x =1;
        end
end

keyboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fill in List rows
%%%%%%%%%%%%%


%Create mini-block row
[Study1Order] = blockAssigner(Study1Order,Study1Trials/TrialsperBlock,TrialsperBlock,blockrow);
[Study2Order] = blockAssigner(Study2Order,Study2Trials/TrialsperBlock,TrialsperBlock,blockrow);
[TestOrder] = blockAssigner(TestOrder,TestTrials/TrialsperBlock,TrialsperBlock,blockrow);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Create Condition Lookup Table that contains each conID and their
%associated pictures (this list is subject specific). The script will then
%go through each phase of the experiment and lookup the conID for each
%trial and assign that trial its associated items. So throughout the
%experiment con1 will always have the same items associated with it. 

[allCons] = conLookUpTableMEGclass(conditions,stimIDs,stimList,subject,TrialsperBlock,Study1Order(2,:));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Assign items to each trial
%
%Go through each trial, get the conID, and then find all the associated
%items for that conID in the conID lookup table (allCons)

%STudy1
for trial = 1:Study1Trials
    conID = find(strcmp(allCons(1,:),Study1Order(2,trial)));
    Study1Order(3:6,trial) = allCons(2:5,conID); 
    if strcmp(Study1Order{1,trial},'F')
        Study1Order{8,trial} = 1;
    elseif strcmp(Study1Order{1,trial},'S')
        Study1Order{8,trial} = 2;
    elseif strcmp(Study1Order{1,trial},'O')
        Study1Order{8,trial} = 3;
    end
end

%Study2
for trial = 1:Study2Trials
    conID = find(strcmp(allCons(1,:),Study2Order(2,trial)));
    Study2Order(3:6,trial) = allCons(2:5,conID); 
     if strcmp(Study2Order{1,trial},'F')
        Study2Order{8,trial} = 1;
    elseif strcmp(Study2Order{1,trial},'S')
        Study2Order{8,trial} = 2;
    elseif strcmp(Study2Order{1,trial},'O')
        Study2Order{8,trial} = 3;
    end
end

%Test
for trial = 1:TestTrials
    conID = find(strcmp(allCons(1,:),TestOrder(2,trial)));
    TestOrder(3:6,trial) = allCons(2:5,conID);   
      if strcmp(TestOrder{1,trial},'F')
        TestOrder{8,trial} = 1;
      elseif strcmp(TestOrder{1,trial},'S')
        TestOrder{8,trial} = 2;
      elseif strcmp(TestOrder{1,trial},'O')
        TestOrder{8,trial} = 3;
      end
end





lists{subject}.Study1 = Study1Order;
lists{subject}.Study2 = Study2Order;
lists{subject}.Test = TestOrder;
        
end

currdir = pwd;
%cd ../LIST
save allLists lists
cd(currdir);



