function theData = RIME_fMRI_PT(thePath,sNum,S,saveName,block,startTrial, dbgn)

% This is based on PT2 of REI (int test), but only the first part of it.  No keyboard response

%% initialize rand.
rand('twister',sum(100*clock));
% kbNum=S.kbNum;

%% Read the input file
%cd(thePath.list);

% FRR add
%1 condition
%2 conditionID
%3 word ID
%4 image ID (face, scene or object)
%5 word name
%6 image name
%7 mini block number
%8 category (face 1; scene 2; object 3;)
%9 condition    (F not retr. identical - 1; 1   S not retr. identical - 2;  O not retr. identical - 3; F retr. identical - 4;       	S retr. identical - 5;      O retr. identical - 6;
%F not retr. different - 7;   	S not retr. different - 8;  O not retr. different - 9; F retr. different - 10;      	S retr. different - 11;     O retr. different - 12;
%FL1 face-lure(new)  13      	SL1 scene-lure(new) -14     OL1 object-lure(new) - 15; FL2 face-lure(new)  13       	SL2 scene-lure(new) -14     OL2 object-lure(new) - 15 ) FRR add

if sNum < 10                                %added 3/25/15 RS copied from fMRIclass_S1ONLY_Vivid.m
    subj = ['0' num2str(sNum)];
else
    subj = num2str(sNum);
end

if exist(saveName)
    load(saveName)
    listLength = length(theList);
    clear lists
else
%     load allLists
    load([thePath '/LIST/allLists.mat']);
    theList = lists{sNum}.PostTest;
    listLength = length(theList);
    clear lists
    
    %FRR change all of the below
    theData.PT.condition        = theList(1,:);
    theData.PT.conID            = theList(2,:);
    theData.PT.wordID           = theList(3,:);
    theData.PT.imageID          = theList(4,:);
    theData.PT.word             = theList(5,:);
    theData.PT.image            = theList(6,:);
    theData.PT.miniblock        = theList(7,:);
    theData.PT.category         = theList(8,:);
    theData.PT.image_vers       = theList(9,:); % (_1 or _2 - which ever one is used in this condition in this phase, so I can always read in image_vers and not worry about it later)
    theData.PT.image_vers_code 	= theList(10,:); % code which tells me whether for this subejct the original in study1 had extension _1 or _2
end

subjDir = [thePath '/Data/' subj]; %added 3/26/15 RS
ptDir = [subjDir '/PT'];


if ~isdir(subjDir)  %added 3/26/15 RS
    mkdir(ptDir)
end

KbName('UnifyKeyNames');

%% Trial Outline
if dbgn == 1 % debugging
    fixTime = .5;
    blockLength = 18;
    startFixTime = .2;
else
    fixTime = .5; % 1s seemed to long
    blockLength = 18;
    startFixTime = .5; 
end


%Set the up, down, left, and right image displacements
luredowndisplace = 300; %how much to shift the image down from center

%% Screen commands and device specification

myRect = S.myRect;
Screen('TextSize', S.Window, S.labelTextSize);
Screen('TextFont', S.Window, S.font);
Screen('TextStyle', S.Window, 1);

% get center and box points
xcenter = myRect(3)/2;
ycenter = myRect(4)/2 + S.YadjustmentFactor;

Screen('FillRect', S.Window, S.screenColor);
Screen(S.Window,'Flip');
%cd(thePath.stim);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Up all the pictures and images

% % Load fixation %commented out per Hongmi RS
% fileName = 'fix.jpg';
% pic = imread([thePath '/stim/' fileName]);
% [fixHeight fixWidth crap] = size(pic);
% fix = Screen(S.Window,'MakeTexture', pic);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Hongmi: fixation parameters. you can change the size and
%%%%%%%%% thickness of the fixation
black = 0;
fixlength = 25;
fixwidth = 4;
fixcol = black;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% hongmi: box parameters

red = [160 0 0];
boxwidth = 6;
boxrect = [xcenter-225/2 ycenter-225/2 xcenter+225/2 ycenter+225/2];


% %Load blank box %commented out by RS per Hongmi
% fileName = 'box.jpg';
% pic = imread([thePath '/stim/' fileName]);
% [boxHeight boxWidth crap] = size(pic);
% box = Screen('MakeTexture', S.Window, pic);
% 
% % Load blank
% fileName = 'blank.jpg';
% pic = imread([thePath '/stim/' fileName]);
% blank = Screen('MakeTexture', S.Window, pic);

%Load border
fileName = 'border.jpg';
pic = imread([thePath '/stim/' fileName]);
[borderHeight borderWidth crap] = size(pic);
border = Screen('MakeTexture', S.Window, pic);
%
%Load surenew Box
fileName = 'surenew.jpg';
pic = imread([thePath '/stim/' fileName]);
[surenewboxHeight surenewboxWidth crap] = size(pic);
surenewbox = Screen('MakeTexture', S.Window, pic);
%
%Load likenew Box
fileName = 'likenew.jpg';
pic = imread([thePath '/stim/' fileName]);
[likenewboxHeight likenewboxWidth crap] = size(pic);
likenewbox = Screen('MakeTexture', S.Window, pic);

%Load likeold Box
fileName = 'likeold.jpg';
pic = imread([thePath '/stim/' fileName]);
[likeoldboxHeight likeoldboxWidth crap] = size(pic);
likeoldbox = Screen('MakeTexture', S.Window, pic);

%Load sureold Box
fileName = 'sureold.jpg';
pic = imread([thePath '/stim/' fileName]);
[sureoldboxHeight sureoldboxWidth crap] = size(pic);
sureoldbox = Screen('MakeTexture', S.Window, pic);

% Load the stim pictures for the current block
for n = 1:listLength
    picname = [theData.PT.image_vers{n}(3:end) '.jpg'];  % This is the filename of the image %FRR changed to image from Citem %FRR change form image to image_vers so I can load version 1 or 2 of image
    pic = imread([thePath '/stim/images/' picname]);
    [imgheight(n) imgwidth(n) crap] = size(pic);
    imgPtrs(n) = Screen('MakeTexture',S.Window,pic);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get everything else ready

% preallocate shit:
%for preall = 1:listLength
%    theData.onset(preall) = 0;
%end

% Loaded Screen
% Screen('DrawTexture', S.Window, blank); %commented out RS per Hongmi
message = 'Task Loaded';
DrawFormattedText(S.Window,message,'center',ycenter,S.textColor);  % used to say 'center','center'
Screen(S.Window,'Flip');

%get cursor out of the way
SetMouse(0,myRect(4));



%  initiate experiment and begin recording time...
% WAB: took out the quit aspect here because too hard to do during a scan,
% before trigger.
while 1
    [keyDown, secs, keyCodes] = KbCheck;
    if keyDown
        if keyCodes(S.triggerKey)
            break;
%              elseif keyCodes(S.quitKey)
%                 sca; return;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Go
Priority(MaxPriority(S.Window));
startTime = GetSecs;
goTime = 0;

%the below is just for some null time to start each block
goTime = goTime + 1;
% %show fixation
% destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
% Screen('DrawTexture', S.Window, blank);
% Screen('DrawTexture', S.Window, fix,[],destRect);
% Screen(S.Window,'Flip');

%     destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2]; %commented out by RS per Hongmi
%     Screen('DrawTexture', S.Window, blank);
%     Screen('DrawTexture', S.Window, fix,[],destRect);
    Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %added by RS per Hongmi

% % show fixation
% goTime = goTime + startFixTime;
% destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
% Screen('DrawTexture', S.Window, blank);
% Screen('DrawTexture', S.Window, fix,[],destRect);
 Screen(S.Window,'Flip');

recordKeys(startTime,goTime,S.kbNum);


for Trial = startTrial:listLength
%     if (theData.PT.miniblock{Trial}==block) %FRR add study 1
        
        %% Draw  picture and response boxes
        %goTime = goTime + stimTime;
        
        % Draw the image 
        destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
        Screen('DrawTexture',S.Window,imgPtrs(Trial),[],destRect);


        %Set Position Variables
        one = xcenter-300;
        two = xcenter -100;
        three = xcenter+100;
        four = xcenter+300;
        
        %Set Image Paramaters (for mouse click)
        oneleft     = one-borderWidth/2;
        oneright    = one+borderWidth/2;
        twoleft     = two-borderWidth/2;
        tworight    = two+borderWidth/2;
        threeleft   = three-borderWidth/2;
        threeright  = three+borderWidth/2;
        fourleft    = four-borderWidth/2;
        fourright   = four+borderWidth/2;
        allup       = ycenter+luredowndisplace-borderHeight/2;
        alldown     = ycenter+luredowndisplace+borderHeight/2;
        wordcenter  = (allup+alldown)/2; %added by RS
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% changed by RS to make black per Hongmi
%%%%%%%%%%% manually centered box labels inside of boxes... not the most elegant method, but works well enough

        % draw SURE NEW
%         destRect = [oneleft allup oneright alldown];
%         Screen('DrawTexture',S.Window,surenewbox,[],destRect);
        Screen('FrameRect', S.Window, [black], [oneleft, allup, oneright, alldown], [boxwidth]);
        message = 'SURE NEW';
        DrawFormattedText(S.Window,message,(oneleft+14),wordcenter, black, (oneright));
        
        % draw LIKELY NEW
%         destRect = [twoleft allup tworight alldown];
%         Screen('DrawTexture',S.Window,likenewbox,[],destRect);
        Screen('FrameRect', S.Window, [black], [twoleft, allup, tworight, alldown], [boxwidth]);
        message = 'LIKELY NEW';
        DrawFormattedText(S.Window,message,(twoleft+7),wordcenter, black, (tworight));
        
    % draw LIKELY OLD
%         destRect = [threeleft allup threeright alldown];
%         Screen('DrawTexture',S.Window,likeoldbox,[],destRect);
        Screen('FrameRect', S.Window, [black], [threeleft, allup, threeright, alldown], [boxwidth]);
        message = 'LIKELY OLD';
        DrawFormattedText(S.Window,message,(threeleft+9),wordcenter, black, threeright);
        
    % draw SURE OLD
%         destRect = [fourleft allup fourright alldown];
%         Screen('DrawTexture',S.Window,sureoldbox,[],destRect);
        Screen('FrameRect', S.Window, [black], [fourleft, allup, fourright, alldown], [boxwidth]);
        message = 'SURE OLD';
        DrawFormattedText(S.Window,message,(fourleft+18),wordcenter, black);
        
    % Flip
        Screen(S.Window,'Flip')
        
        %Collect Mouse Click
        upTime1 = GetSecs;
        whichPositionX1 = 0;
        whichPositionY1 = 0;
        mouseclicktime1 = 0;
        mouseholddowntime1 = 0;
        [x,y,buttons] = GetMouse;
        while any(buttons) % if already down, wait for release
            [x,y,buttons] = GetMouse;
            mouseholddowntime1 = GetSecs - upTime1;
%              if GetSecs-startTime > goTime %commented out FRR 12/Jan/15,
%              maybe this is why I sometimes had 0s
%                  break;
%              end
        end
        
        while ~any(buttons) % wait for press
            [x,y,buttons,focus,valuators,valinfo] = GetMouse;
            if buttons(1)
                whichPositionX1 = x;
                whichPositionY1 = y;
                mouseclicktime1 = GetSecs-upTime1 - mouseholddowntime1;
                
                %Only move on if they click one of the images
                if allup < whichPositionY1 && whichPositionY1 < alldown && xor((oneleft <= whichPositionX1 && whichPositionX1 <= oneright), (twoleft <= whichPositionX1 && whichPositionX1 <= tworight))
                    goTime = goTime  + mouseclicktime1 + mouseholddowntime1 + .2;
                    recordKeys(startTime,goTime,S.kbNum);
                         if dbgn == 0 % NOT debugging
                             while any(buttons) % if already down, wait for release, so that you do not rush through exp by holding key down
                                   [x,y,buttons] = GetMouse;
                             end
                         end
                         break;
                elseif allup < whichPositionY1 && whichPositionY1 < alldown &&  xor ( (threeleft <= whichPositionX1 && whichPositionX1 <= threeright), (fourleft <= whichPositionX1 && whichPositionX1 <= fourright)) %FRR not sure why this is in a seperate line rather than with the above?
                    goTime = goTime  + mouseclicktime1 + mouseholddowntime1 + .2;
                    recordKeys(startTime,goTime,S.kbNum);
                        if dbgn == 0 % NOT debugging
                            while any(buttons) % if already down, wait for release, so that you do not rush through exp by holding key down
                                   [x,y,buttons] = GetMouse;
                            end
                        end
                        break;
                else
                        if dbgn == 0 % NOT debugging
                            while any(buttons) % if didnt click on an image (but clicked anywhere else) the code waits for th buton to be released and therefore will continue in this greater while loop
                                [x,y,buttons] = GetMouse;
                            end
                        end
                end
            end
        end
        
        
        %Record Stimulus Responses
        %X and Y mouse click position
        theData.PT.xposition(Trial) = whichPositionX1;
        theData.PT.yposition(Trial) = whichPositionY1;
        %RT
        theData.PT.RT(Trial) = mouseclicktime1;
        %Hold down time
        theData.PT.HD(Trial) = mouseholddowntime1;
        
        %response Choice
        showchoices = 0; %have this variable to skip over second item choice if they choose not sure
        if (oneleft <= whichPositionX1 && whichPositionX1<= oneright) && (allup <= whichPositionY1 && whichPositionY1 <= alldown)
            theData.PT.Choice(Trial) = 1;
            showchoices =1;
        elseif (twoleft <= whichPositionX1 && whichPositionX1<= tworight) && (allup <= whichPositionY1 && whichPositionY1 <= alldown)
            theData.PT.Choice(Trial) = 2;
            showchoices =1;
        elseif (threeleft <= whichPositionX1 && whichPositionX1<= threeright) && (allup <= whichPositionY1 && whichPositionY1 <= alldown)
            theData.PT.Choice(Trial) = 3;
            showchoices =1;
        elseif (fourleft <= whichPositionX1 && whichPositionX1<= fourright) && (allup <= whichPositionY1 && whichPositionY1 <= alldown)
            theData.PT.Choice(Trial) = 4;
        else
            theData.PT.Choice(Trial) = 0; %this should only occure when debugging
            showchoices =1;
        end
        
        %% some response coding
        if theData.PT.conID{Trial}(3)  == 'I'; %if exactly the same/identical pic had been shown
            
            if theData.PT.Choice(Trial) == 4;       % Response = sure old (correct)
                %Hits
                theData.PT.sureHits(Trial)      = 1;
                theData.PT.unsureHits(Trial)    = 0;
                theData.PT.Hits(Trial)          = 1;
                %CR
                theData.PT.sureCR(Trial)        = 0;
                theData.PT.unsureCR(Trial)      = 0;
                theData.PT.CR(Trial)            = 0;
                
                %Acc
                theData.PT.Accuracy(Trial)      = 1;
            elseif theData.PT.Choice(Trial) == 3; % Response = likely old (correct)
                %Hits
                theData.PT.sureHits(Trial)      = 0;
                theData.PT.unsureHits(Trial)    = 1;
                theData.PT.Hits(Trial)          = 1;
                %CR
                theData.PT.sureCR(Trial)        = 0;
                theData.PT.unsureCR(Trial)      = 0;
                theData.PT.CR(Trial)            = 0;
                
                %Acc
                theData.PT.Accuracy(Trial)      = 1;
            elseif theData.PT.Choice(Trial) == 2; % Response = likely new (wrong)
                %Hits
                theData.PT.sureHits(Trial)      = 0;
                theData.PT.unsureHits(Trial)    = 0;
                theData.PT.Hits(Trial)          = 0;
                
                %CR
                theData.PT.sureCR(Trial)        = 0;
                theData.PT.unsureCR(Trial)      = 0;
                theData.PT.CR(Trial)            = 0;
                
                %Acc
                theData.PT.Accuracy(Trial)      = 0;
                
          elseif theData.PT.Choice(Trial) == 1; % Response = sure new (wrong)
                %Hits
                theData.PT.sureHits(Trial)      = 0;
                theData.PT.unsureHits(Trial)    = 0;
                theData.PT.Hits(Trial)          = 0;
                
                %CR
                theData.PT.sureCR(Trial)        = 0;
                theData.PT.unsureCR(Trial)      = 0;
                theData.PT.CR(Trial)            = 0;
                %Acc
                theData.PT.Accuracy(Trial)      = 0;
            end
            
        elseif theData.PT.conID{Trial}(3)  ~= 'I';%if exactly the same/identical pic had NOT been shown
            if theData.PT.Choice(Trial) == 4;       % Response = sure old (wrong)
                %Hits
                theData.PT.sureHits(Trial)      = 0;
                theData.PT.unsureHits(Trial)    = 0;
                theData.PT.Hits(Trial)          = 0;
                %CR
                theData.PT.sureCR(Trial)        = 0;
                theData.PT.unsureCR(Trial)      = 0;
                theData.PT.CR(Trial)            = 0;
                
                %Acc
                theData.PT.Accuracy(Trial)      = 0;
            elseif theData.PT.Choice(Trial) == 3; % Response = likely old (wrong)
                %Hits
                theData.PT.sureHits(Trial)      = 0;
                theData.PT.unsureHits(Trial)    = 0;
                theData.PT.Hits(Trial)          = 0;
                %CR
                theData.PT.sureCR(Trial)        = 0;
                theData.PT.unsureCR(Trial)      = 0;
                theData.PT.CR(Trial)            = 0;
                
                %Acc
                theData.PT.Accuracy(Trial)      = 0;
           elseif theData.PT.Choice(Trial) == 2; % Response = likely new (correct)
                %Hits
                theData.PT.sureHits(Trial)      = 0;
                theData.PT.unsureHits(Trial)    = 0;
                theData.PT.Hits(Trial)          = 0;
                
                %CR
                theData.PT.sureCR(Trial)        = 0;
                theData.PT.unsureCR(Trial)      = 1;
                theData.PT.CR(Trial)            = 1;
                
                %Acc
                theData.PT.Accuracy(Trial)      = 1;
                
            elseif theData.PT.Choice(Trial) == 1; % Response = sure new (correct)
                %Hits
                theData.PT.sureHits(Trial)      = 0;
                theData.PT.unsureHits(Trial)    = 0;
                theData.PT.Hits(Trial)          = 0;
                
                %CR
                theData.PT.sureCR(Trial)        = 1;
                theData.PT.unsureCR(Trial)      = 0;
                theData.PT.CR(Trial)            = 1;
                %Acc
                theData.PT.Accuracy(Trial)      = 1;
            end
            
        end
        
        %Show fixation after each response  %FRR add
        goTime = goTime + fixTime;

%       destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2]; %commented out by RS per Hongmi
%       Screen('DrawTexture', S.Window, blank);
%       Screen('DrawTexture', S.Window, fix,[],destRect);
        Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
        0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %added by RS per Hongmi
    
    %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% draw the old/new boxes again here so they 'stay' on screen during fixation cross RS
         % draw SURE NEW
        Screen('FrameRect', S.Window, [black], [oneleft, allup, oneright, alldown], [boxwidth]);
        message = 'SURE NEW';
        DrawFormattedText(S.Window,message,(oneleft+14),wordcenter, black, (oneright));
        
        % draw LIKELY NEW
        Screen('FrameRect', S.Window, [black], [twoleft, allup, tworight, alldown], [boxwidth]);
        message = 'LIKELY NEW';
        DrawFormattedText(S.Window,message,(twoleft+7),wordcenter, black, (tworight));
        
        % draw LIKELY OLD
        Screen('FrameRect', S.Window, [black], [threeleft, allup, threeright, alldown], [boxwidth]);
        message = 'LIKELY OLD';
        DrawFormattedText(S.Window,message,(threeleft+9),wordcenter, black, threeright);
        
        % draw SURE OLD
        Screen('FrameRect', S.Window, [black], [fourleft, allup, fourright, alldown], [boxwidth]);
        message = 'SURE OLD';
        DrawFormattedText(S.Window,message,(fourleft+18),wordcenter, black);
        
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        
        
        %cd(thePath.data);
        % save the file, just as a mat
        cmd = ['save ' saveName ' theData' ' ' 'theList'];
        eval(cmd);
        
        
        % RECORD RESPONSES at end of each block
        % Trial>1 && mod(Trial,blockLength) == 1
        theDataPath = [thePath '/Data'];
        cd(theDataPath)
        if sNum < 10
            subj = ['0' num2str(sNum)];
        else
            subj = num2str(sNum);
        end
        
        %save file each time in case we crash
        subj_foldername = [subj];     % SUBJECT folder %changed from subj_foldername = ['sub_' subj]; 3/26/15 RS
        theSubjPath = ([theDataPath, '/' subj_foldername]);
        cd(theSubjPath)
        
        foldername = ['/PT/'];  %then check for Study1 folder
        ckfolder = exist(foldername);
        if ckfolder == 7
        else
            mkdir(theSubjPath, foldername);
        end
        cd([theSubjPath foldername ])
        
        if startTrial ==1 && block ==1
        matName = [saveName '_study.mat'];
        else
        matName  = [saveName 'TRIAL' num2str(startTrial) 'BLK' num2str(block) '_study.mat']; 
        end
        
        cmd = ['save ' matName];
        eval(cmd);
        
%        Screen('DrawTexture', S.Window, blank); %commented out RS per Hongmi
        Screen(S.Window,'Flip');
        
        Priority(0);
        cd([thePath '/SCRIPTS']);
%     end
end
 cd([theSubjPath foldername ])
% save everything in one file, just as a mat
saveName_all = [saveName(1:end-4) '_all.mat']; % this omits the "block" parts of the filename
cmd = ['save ' saveName_all ' theData' ' ' 'theList'];
eval(cmd);


matName = [saveName '_study.mat'];
cmd = ['save ' matName];
eval(cmd);
end
