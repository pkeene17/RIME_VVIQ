%This list will inlcude
%1 condition
%2 conditionID
%3 word ID
%4 image ID (face, scene or object)
%5 word name
%6 image name
%7 mini block number
%8 category (face 1; scene 2; object 3;)
    %% 'FNI' 'SNI' 'ONI' 'FRI' 'SRI' 'ORI' 'FND' 'SND' 'OND' 'FRD' 'SRD''ORD' 'FL1' 'SL1' 'OL1' 'FL2' 'SL2' 'OL2'
    %(F not retr. identical - 1; 1      S not retr. identical - 2;  O not retr. identical - 3; F retr. identical - 4;       	S retr. identical - 5;      O retr. identical - 6;
    % F not retr. different - 7;        S not retr. different - 8;  O not retr. different - 9; F retr. different - 10;      	S retr. different - 11;     O retr. different - 12;
    % FL1 face-lure(new)  13            SL1 scene-lure(new) -14     OL1 object-lure(new) - 15; FL2 face-lure(new)  13       	SL2 scene-lure(new) -14     OL2 object-lure(new) - 15 ) FRR add
       
clear all;
%% %%%%%%%%%%%%%%%%%%%%%%%
%% Set Variables
%%%%%%%%%%%%%%%%%%%%%%%%%
%Subjects
numSub = 99; %put the number of subjects here

%Conditions
% F = face ; S = scene ; O  = object ; N = no retrieval ; R = retrieval
% i = identical/same; D = different/similar;  L = lure/new
Conditions          = {'FNI' 'SNI' 'ONI' 'FRI' 'SRI' 'ORI' 'FND' 'SND' 'OND' 'FRD' 'SRD' 'ORD' 'FL1' 'SL1' 'OL1' 'FL2' 'SL2' 'OL2'}; %this is identical with PostTestconditions
Study1Conditions    = {'FNI' 'SNI' 'ONI' 'FRI' 'SRI' 'ORI' 'FND' 'SND' 'OND' 'FRD' 'SRD' 'ORD'}; %no lures
VividConditions     = {'FRI' 'SRI' 'ORI' 'FRD' 'SRD' 'ORD'}; %only retrieved
PostTestConditions  = {'FNI' 'SNI' 'ONI' 'FRI' 'SRI' 'ORI' 'FND' 'SND' 'OND' 'FRD' 'SRD' 'ORD' 'FL1' 'SL1' 'OL1' 'FL2' 'SL2' 'OL2'}; %this is identical with conditions

%numCond = length(conditions);
blockrow = 7; %identify the row in the list where you want to insert the block number

%Number of Trials Per Block
%(of the unique trials)
Study1Trials    = 192; 	% FRR change from 300
LureTrials      = 96;   % FRR number of new items in post test
%Study2Trials   = 300; 	% FRR change: we wont have study 2 %This the number of trials a subjects learns during the B study rounds (the number of blocks will dicate how many times they are exposed to each trial)
VividTrials     = Study1Trials/2;           % FRR change from 300; half of Study1
PostTestTrials  = Study1Trials+LureTrials;  % FRR 288 trials

%%%%uniqueTrials = 204; 	%FRR change from 300 %This is the number of unique image pairings that will be learned during the study
%numTrials       = 2;
numStudy1Trials = [1];  % FRR change form 4; %This is an array that specifies the number of trials for each condition to be randomzied within a block.
% If all the conditions have the same amount of trials then you can put just the single number for how many trials for each condition.
% ie. If each condition has 6 trials just write 6.
numVividTrials  = [1];
numPostTestTrials = [1];

TrialsperStudy1Block    = 12; %FRR put manually %TrialsperBlock  = numCond*numTrials;
TrialsperVividBlock     = 6;
TrialsperPostTestBlock  = 18; % we have 15 conditions but 3 of them need to be counted double

%Number of Rounds per Study Phase
Study1Blocks    = 1;
%Study2Blocks   = 1;
VividBlocks     = 1;
PostTestBlocks  = 1;

%Load Stimuli Names
excelFile = 'stimuli_list_fMRIclass.txt'; %must be a text file
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
load stimIDs % FRR I generated this first with 'stimID_fMRIclass.m'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATE THE LISTS (of conditions, here still without the ideintifing number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for subject = 1:numSub
    %Generate the list of conditions (i.e. just the codes, no IDs yet) for all the phases
    %Study1
    x= 0;
    while x == 0
        Study1Order = [];
        for blocks = 1:Study1Blocks                                     %FRR adapted; For each round this will create a randomized list of all the trials in the prestudyphase, with a randomized order for each bin of 12 pairs (2 trials for each condition).
            for conRepeats = 1:Study1Trials/TrialsperStudy1Block      %counts how many times the number of trials for each condition repeats within each block
                Study1Order= [Study1Order trialCreator(numStudy1Trials, Study1Conditions)];  %This ensures that the randomized order is binned into sets of 12
            end
        end
        %Check that there is not randomly too much variance between the conditions regarding at what serial position they are presented
        [check] = serialPosChecker(Study1Order,Study1Conditions,.9); %changed from .1 to .9 which is the highest I have seen in Avi's scripts. As this is a precaution only, it should be fine
        if check == 1
            x =1;
        end
    end

    %Vivid
    x= 0;
    while x == 0
        VividOrder = [];
        for blocks = 1:VividBlocks                                  %FRR adapted; For each round this will create a randomized list of all the trials in the prestudyphase, with a randomized order for each bin of 12 pairs (1 trials for each condition).
            for conRepeats = 1:VividTrials/TrialsperVividBlock    %counts how many times the number of trials for each condition repeats within each block
                VividOrder= [VividOrder trialCreator(numVividTrials, VividConditions)];  %This ensures that the randomized order is binned into sets of 12
            end
        end
        %Check that there is not randomly too much variance between the conditions regarding at what serial position they are presented
        [check] = serialPosChecker(VividOrder,VividConditions,.9); %changed from .1 to .9 which is the highest I have seen in Avi's scripts. As this is a precaution only, it should be fine
        if check == 1
            x =1;
        end
    end

    %Posttest
    x= 0;
    while x == 0
        PostTestOrder = [];
        for blocks = 1:PostTestBlocks                                       %FRR adapted; For each round this will create a randomized list of all the trials in the prestudyphase, with a randomized order for each bin of 12 pairs (1 trials for each condition).
            for conRepeats = 1:PostTestTrials/TrialsperPostTestBlock      %counts how many times the number of trials for each condition repeats within each block
                
                PostTestOrder= [PostTestOrder trialCreator(numPostTestTrials, PostTestConditions)];  %This ensures that the randomized order is binned into sets of 12
            end
        end
        %Check that there is not randomly too much variance between the conditions regarding at what serial position they are presented
        [check] = serialPosChecker(PostTestOrder,PostTestConditions,.9); %changsed from .1 to .9 which is the highest I have seen in Avi's scripts. As this is a precaution only, it should be fine
        if check == 1
            x =1;
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Assign condition IDs (here we add the identifying numbers to the condition codes)
    [Study1Order]   = conIDGenerator(Study1Conditions,Study1Order,Study1Blocks);     % this generates the numbers and appends them to condition prefix
    [PostTestOrder] = conIDGenerator(PostTestConditions,PostTestOrder,PostTestBlocks);
    
    % [Vividorder] is somewhat predetermined by study order (ie the same items need to appear here), so we just select the one's that need to be tested and shuffel them
    %Within each block of 16, the participant will study 12 word-picture pairs, then they will then be tested on HALF of those same pairs in a different order.
    %We therefore need Vividorder to use the same condition ids from study1order within a given block.
    x= 0;
    while x == 0
        for miniblock   = 1:Study1Trials/TrialsperStudy1Block       % go through each block (set of 12 trials for Study1)
            firstpos    = (miniblock-1)*TrialsperStudy1Block+1;
            endpos      = firstpos + TrialsperStudy1Block-1;
            conIDs(1:TrialsperStudy1Block) = Study1Order(2,firstpos:endpos); %Create list of conIDs for each block
            
            for cond = 1:length(conIDs)
                Study1con{cond} = Study1Order{2,cond+firstpos-1}(1); %This will be an array of just th conditions without th identifying number
            end
            %Assign condition
            Study1Order(1,firstpos:endpos)       = Study1con;
          
            [check] = serialPosChecker(Study1Order,Study1Conditions,5);
            if check == 1
                x = 1;
            end
            
            %Vivid     
            firstposVivid    = (miniblock-1)*TrialsperVividBlock+1;
            endposVivid      = firstposVivid + TrialsperVividBlock-1;
            for idx = 1:length(VividConditions)
                mystring = VividConditions{idx};             % this is the condition I am searching for
                findCond = strfind(conIDs, mystring);        % I search for the relevant ID in the conIDs from study1 to give me the exact ID (condition+number) of the item that was presented in that condition
                index = find(~cellfun(@isempty,findCond));   % This step is necessary to convert it into a number (something about the cell makes it necessary)
                IDsVividcon(idx) = conIDs(index);            % Then finally I can get the IDs for the Vividphase as well, and put it in an arry
            end
            VividOrder(2,firstposVivid:endposVivid)       = Shuffle(IDsVividcon);      %Randomize the order of the condID order for Vivdorder, so it is not the same as study1
            
            %Extract the condition type from the conID
            for cond = 1:length(IDsVividcon)
                Vividcon{cond} = VividOrder{2,cond+firstposVivid-1}(1); %This will be an array of just th conditions without th identifying number
            end
            
            %Assign condition
            VividOrder(1,firstposVivid:endposVivid)       = Vividcon;
        end

        %Post Test
        for miniblock   = 1:PostTestTrials/TrialsperPostTestBlock %go through each block (set of 18 for post test )
            firstpos    = (miniblock-1)*TrialsperPostTestBlock+1;
            endpos      = firstpos + TrialsperPostTestBlock-1;
            conIDsPostTest(1:TrialsperPostTestBlock) = PostTestOrder(2,firstpos:endpos); %Create list of conIDs for each block
            
            PostTestOrder(2,firstpos:endpos)    = Shuffle(conIDsPostTest);      %Randomize the blocks' condID order for Test (might be redundant, but better safe than sorry)
            
            for cond = 1:length(conIDsPostTest)
                PostTestcon{cond}   = PostTestOrder{2,cond+firstpos-1}(1); %This will be an array of just th conditions without th identifying number
            end
            
            
            %Assign condition
            PostTestOrder(1,firstpos:endpos)    = PostTestcon;
            
            
  
        end
        
    end
   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Fill in List rows
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %Create mini-block row
    [Study1Order]   = blockAssigner(Study1Order,Study1Trials/TrialsperStudy1Block,TrialsperStudy1Block,blockrow);
    %[Study2Order]   = blockAssigner(Study2Order,Study2Trials/TrialsperBlock,TrialsperBlock,blockrow); %FRR commeted out
    [VividOrder]    = blockAssigner(VividOrder,VividTrials/TrialsperVividBlock,TrialsperVividBlock,blockrow);
    [PostTestOrder] = blockAssigner(PostTestOrder,PostTestTrials/TrialsperPostTestBlock,TrialsperPostTestBlock,blockrow);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Create Condition Lookup Table that contains each conID and their
    %associated pictures (this list is subject specific). The script will then
    %go through each phase of the experiment and lookup the conID for each
    %trial and assign that trial its associated items. So throughout the
    %experiment con1 will always have the same items associated with it.
    
    %[allCons] = conLookUpTablefMRIclass(conditions,stimIDs,stimList,subject,TrialsperStudy1Block,Study1Order(2,:));
    
    [allCons] = conLookUpTablefMRIclass(Conditions,stimIDs,stimList,subject,TrialsperPostTestBlock,PostTestOrder(2,:)); %FRR edit to posttest, as this is the only one with all conditions.
    
    
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
    
    %Vivid
    for trial = 1:VividTrials
        conID = find(strcmp(allCons(1,:),VividOrder(2,trial)));
        VividOrder(3:6,trial) = allCons(2:5,conID);
        if strcmp(VividOrder{1,trial},'F')
            VividOrder{8,trial} = 1;
        elseif strcmp(VividOrder{1,trial},'S')
            VividOrder{8,trial} = 2;
        elseif strcmp(VividOrder{1,trial},'O')
            VividOrder{8,trial} = 3;
        end
    end
    
    %Test
    for trial = 1:PostTestTrials
        conID = find(strcmp(allCons(1,:),PostTestOrder(2,trial)));
        PostTestOrder(3:6,trial) = allCons(2:5,conID);
        if strcmp(PostTestOrder{1,trial},'F')
            PostTestOrder{8,trial} = 1;
        elseif strcmp(PostTestOrder{1,trial},'S')
            PostTestOrder{8,trial} = 2;
        elseif strcmp(PostTestOrder{1,trial},'O')
            PostTestOrder{8,trial} = 3;
        end
    end
    
    %FRR add: this makes sure that half the participants get the origial
    %stimulus set during study 1 and the similar items from the doubles
    %list, and that the reverse is true for the other list of subjects.
    
    if mod(subject,2) == 0 %if subject number is even, use even numbers as original 
        % all of study order should have extension _2 
        for trial = 1:Study1Trials
             Study1Order{9,trial}   = [Study1Order{6,trial}, '_2'];  
             Study1Order{10,trial}  = 'Orig2_Diff_1';               %this just makes it explicit in the list file later
        end
        % all of vivid order should have extension _2 (not that it matters as nothing is shown)
        for trial = 1:VividTrials
             VividOrder{9,trial}    = [VividOrder{6,trial}, '_2'];   
             VividOrder{10,trial}   = 'Orig2_Diff_1'; 
        end
        % all of PT should have _1 if it contains D (different/similar) and_2 if conID contains I (identical/same)
        for trial = 1:PostTestTrials
            if PostTestOrder{2,trial}(3) == 'D'
               PostTestOrder{9,trial}   = [PostTestOrder{6,trial}, '_1'];   % if different, than it changes from before!
            else
               PostTestOrder{9,trial} = [PostTestOrder{6,trial}, '_2'];     % if identical or lure(1/2), than it does not change from before! 
            end
            PostTestOrder{10,trial}  = 'Orig2_Diff_1';
        end
     else %if subject number is odd, use even numbers as original 
        % all of study order should have extension _1 
        for trial = 1:Study1Trials
             Study1Order{9,trial} = [Study1Order{6,trial}, '_1'];  
             Study1Order{10,trial}  = 'Orig1_Diff_2';
        end
    
        % all of vivid order should have extension _1 (not that it matters as nothing is shown) 
        for trial = 1:VividTrials
             VividOrder{9,trial} = [VividOrder{6,trial}, '_1']; 
             VividOrder{10,trial}   = 'Orig1_Diff_2'; 
        end
        % all of PT should have _1 if conID contains I (identical/same) and _2 if it contains D (different/similar)    
        for trial = 1:PostTestTrials
            if PostTestOrder{2,trial}(3) == 'D'
               PostTestOrder{9,trial} = [PostTestOrder{6,trial}, '_2'];     % if different, than it changes from before!
            else
               PostTestOrder{9,trial} = [PostTestOrder{6,trial}, '_1'];     % if identical or lure(1/2), than it does not change from before!
            end
            PostTestOrder{10,trial}  = 'Orig1_Diff_2';
        end
    
    
    end
    
    
    
    
    lists{subject}.Study1   = Study1Order;
    lists{subject}.Vivid    = VividOrder;
    lists{subject}.PostTest = PostTestOrder;
    
end

currdir = pwd;
%cd ../LIST
save allLists lists
cd(currdir);



