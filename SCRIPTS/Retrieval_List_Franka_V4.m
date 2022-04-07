clear all;

numsub = 40; 

load allLists.mat %loads original trial lists (study1 and vividness) for all subjects that Franka made

%% Make Retrieval 1 List
for subject = 1:numsub
    
    retrievenum = length(lists{subject}.Vivid); %96 retrieval trials
        
        retrieve_trials{subject} = lists{subject}.Vivid; %just renaming Franka's vividness trial list for ease of coding
    
        for trial = 1:retrievenum
        
             retrieve1List{subject} = retrieve_trials{subject}(:,randperm(length(retrieve_trials{subject}))); %indexes and shuffles trials (columns) from retrieve_trials  
        end
end

save retrieve1List

%% Make Retrieval 2 List

clear retrieve_trials

for subject = 1:numsub
    
    retrievenum = length(lists{subject}.Vivid); %96 retrieval trials
        
        retrieve_trials{subject} = lists{subject}.Vivid; %just renaming Franka's vividness trial list for ease of coding
    
        for trial = 1:retrievenum
        
             retrieve2List{subject} = retrieve_trials{subject}(:,randperm(length(retrieve_trials{subject}))); %indexes and shuffles trials (columns) from retrieve_trials  
        end
end

save retrieve2List

