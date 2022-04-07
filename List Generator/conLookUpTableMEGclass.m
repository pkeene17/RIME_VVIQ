function [ allCons ] = conLookUpTableMEGclass(conditions, stimIDList, stimNameList, sNum, conditionRepPerRound,conIDorder)
%Outputs a condition lookup table that lists all of the items (their name and ID) for a given
%conditionID that will be used thoughout the experiment. Meaining,
%everytime con1 is called it will use the same items as listed here. This
%assignment of specific items to a conID will be unique for each sNum. 
%   Detailed explanation goes here
%

%First get all conID names
allCons = [];
allCons = conIDorder;

numblocks = length(allCons)/conditionRepPerRound;

%Next assign items to each conID
facecounter = 1;
scenecounter = 1;
objectcounter = 1;

%The words in this experiment are grouped into sets of 12. We want to first
%randomize the order of the groups and then randomize the order of the
%words within each group

randgroup = shuffle(linspace(1,numblocks,numblocks));
for block = 1:numblocks
   randblock = randgroup(block); %choose a random word group #
   firstpos = (randblock-1)*conditionRepPerRound+1;
   endpos = firstpos + conditionRepPerRound-1;
   words = stimIDList.words{sNum}(firstpos:endpos); %get the words from the group #
   %Stim IDs
   firstpos = (block-1)*conditionRepPerRound+1; 
   endpos = firstpos + conditionRepPerRound-1;
   allCons(2,firstpos:endpos) = shuffle(words); %shuffle the words and place them in allCons in incremental group positions (ie 1-12 then 13-24 etc.)
   %Item Name 
   for trial = firstpos:endpos
    item = find(strcmp(stimNameList.col2,allCons(2,trial)));
    allCons(4,trial)= stimNameList.col1(item);
   end
end

%Image
for trialcounter = 1:length(allCons)  %creates vector for the B item column
 if strcmp(allCons{1,trialcounter}(1),'F')
      %stimIDList
      allCons(3,trialcounter) = stimIDList.faces{sNum}(facecounter); %places stimIDList in a new row
      %Item Name
      item = find(strcmp(stimNameList.col4,allCons(3,trialcounter))); %finds the picture associated with the stim name and places it in a new row
      allCons(5,trialcounter) = stimNameList.col3(item);
      facecounter= facecounter+1; %move onto next face
 elseif strcmp(allCons{1,trialcounter}(1),'S')
      %stimIDList
      allCons(3,trialcounter) = stimIDList.scenes{sNum}(scenecounter);
      %Item Name
      item = find(strcmp(stimNameList.col6,allCons(3,trialcounter))); 
      allCons(5,trialcounter) = stimNameList.col5(item);
      scenecounter= scenecounter+1; %move onto next scene
 elseif strcmp(allCons{1,trialcounter}(1),'O')
      %stimIDList
      allCons(3,trialcounter) = stimIDList.objects{sNum}(objectcounter);
      %Item Name
      item = find(strcmp(stimNameList.col8,allCons(3,trialcounter))); 
      allCons(5,trialcounter) = stimNameList.col7(item);
      objectcounter= objectcounter+1; %move onto next object
 end
end

end


