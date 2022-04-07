%This list with inlcude
%PRESTUDY, PRETEST and RETREIVAL 
%1 condition
%2 conditionID
%3 word ID (item1)
%4 item2 ID (face, scene or object)
%5 item3 ID (face, scene or object)
%6 word name (item1)
%7 item2 name
%8 item3 name
%9 direction (counterclockwise =1, clockwise = 2)
%10 item to be retrieved (1 for item2, 2 for item3) this will be empty for
%nontested trials
%11 block/round number

%Final Test
%1 condition
%2 conditionID
%3 word ID (item1)
%4 item2 ID (face, scene or object)
%5 item3 ID (face, scene or object)
%6 word name (item1)
%7 item2 name
%8 item3 name
%9 direction (counterclockwise =1, clockwise = 2)
%10 item to be retrieved (1 for item2, 2 for item3, 0 no retrieval)
%11 item tested (1 for item2, 2 for item3)
%12 related, tested, or basline trial (related = 1, tested = 2, baseline=3)
%13 target ID
%14 target name
%15 lure1 ID
%16 lure2 ID
%17 lure3 ID
%18 lure4 ID 
%19 lure5 ID
%20 lure1 name
%21 lure2 name
%22 lure3 name
%23 lure4 name
%24 lure5 name


%Final Test

conIDposFT = varFinder(finalTestOrder(2,:));
conIDs = fieldnames(conIDposFT);
numCons = length(conIDs);

for con = 1:numCons
    avg.(conIDs{con}) = mean(conIDposFT.(conIDs{con}));
    indices = conIDposFT.(conIDs{con});
    testedholder{con} = finalTestOrder(11,indices);
    trialtypeholder{con} = finalTestOrder(12,indices);
end


tested = cell2struct(testedholder,conIDs,2);
trialtype = cell2struct(trialtypeholder,conIDs,2);
