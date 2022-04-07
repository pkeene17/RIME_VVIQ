function theData = RIME_fMRI_studyvivid(thePath,sNum,S,scanningrun,sName)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: record keys does NOT actually record keys we just use it as a delay
% for the script to wait until go-time. We use kbcheck to check for key
% responses :D

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is just like the original CROFS study - the subject just watches words
% matched with pictures. No keyboard response

%% initialize rand.
rand('twister',sum(100*clock));

%% Read the input file

%This list with inlcude (copied from the MEG file by FRR)
%1 condition
%2 conditionID
%3 word ID
%4 image ID (face, scene or object)
%5 word name
%6 image name
%7 mini block number
%8 category (face 1; scene 2; object 3;)

if sNum < 10            % added by AC and RS to make directories
    subj = ['0' num2str(sNum)];
else
    subj = num2str(sNum);
end

subjDir = [thePath '/Data/' subj];
vivDir = [subjDir '/Vivid'];
studyDir = [subjDir '/Study1'];

if ~isdir(subjDir) %if the directory doesn't alrady exist, create it
    mkdir(subjDir)
end
if ~isdir(studyDir)
    mkdir(studyDir)
end
if ~isdir(vivDir)
    mkdir(vivDir)
end

% as we need to read in different randomisations for list1, list2 and test
load([thePath '/LIST/allLists.mat']); %%%%%%%%%%%%%%%%%%% Hongmi
theList.Study1      = lists{sNum}.Study1;
theList.Vivid       = lists{sNum}.Vivid;
Study1Length        = length(theList.Study1);
VividLength         = length(theList.Vivid); %commented out RS so we can get the block from allLists.mat

% mostly copied/ adapted from old REI script based on MEG script
theData.Study1.condition        = theList.Study1(1,:);
theData.Study1.conID            = theList.Study1(2,:);
theData.Study1.wordID           = theList.Study1(3,:); %; was word id
theData.Study1.imageID          = theList.Study1(4,:); %; was BitemID
theData.Study1.word             = theList.Study1(5,:); %; was CitemID
theData.Study1.image            = theList.Study1(6,:); %; was word
theData.Study1.miniblock        = theList.Study1(7,:); %; was Bitem
theData.Study1.category         = theList.Study1(8,:); % (face 1; scene 2; object 3;); was Citem
theData.Study1.image_vers       = theList.Study1(9,:); % (_1 or _2 - which ever one is used in this condition in this phase, so I can always read in image_vers and not worry about it later)
theData.Study1.image_vers_code 	= theList.Study1(10,:); % code which tells me whether for this subejct the original in study1 had extension _1 or _2

% preallocate shit:
for preall = 1:Study1Length
    theData.Study1.onset(preall) = 0; %FRR add Study1
end


theData.Vivid.condition         = theList.Vivid(1,:);
theData.Vivid.conID             = theList.Vivid(2,:);
theData.Vivid.wordID            = theList.Vivid(3,:);
theData.Vivid.imageID           = theList.Vivid(4,:);
theData.Vivid.word              = theList.Vivid(5,:);
theData.Vivid.image             = theList.Vivid(6,:);
theData.Vivid.miniblock         = theList.Vivid(7,:);
theData.Vivid.category          = theList.Vivid(8,:);
theData.Vivid.image_vers        = theList.Vivid(9,:); % (_1 or _2 - which ever one is used in this condition in this phase, so I can always read in image_vers and not worry about it later)
theData.Vivid.image_vers_code 	= theList.Vivid(10,:); % code which tells me whether for this subejct the original in study1 had extension _1 or _2
theData.Vivid.nonzero           = 0; %initializing in case the participant doesn't respond at all during a block
% preallocate shit:
for preall = 1:VividLength
    theData.Vivid.onset(preall) = 0;
end


KbName('UnifyKeyNames');

%% Trial Outline
instrScrTime        = 4; %changed from 6 RS
startFixTime        = 6;
fixTime             = 1.5;
wordtime            = 1; %added by FRR
pictime             = 1.5; %added by FRR
vividStimTime       = 3;
vividRedBoxTime     = 1;
oddevenTime         = 1;
vividFixTime        = 4; %added by RS
endblocktime        = 6; 

oddevenFix          = 1; %changed from 1.5 RS
oddevenBetween      = 1; %changed from 1.25 RS
oddevenrepeats      = 2; %how many times the odd/even task repeats, changed from 3 RS

%% Screen commands and device specification
myRect = S.myRect;
Screen('TextSize', S.Window, S.cueTextSize);
Screen('TextFont', S.Window, S.font);
Screen('TextStyle', S.Window, 1);

% get center and box points
xcenter = myRect(3)/2;
ycenter = myRect(4)/2; %+ S.YadjustmentFactor; % FRR commented out S.Yadj.... as we now do not present Word on top of image anymore. so no adjustment necessary

% the bottom box in the scanner codes index as 4 and pinky as 1 so we have
% to reverse the coding for the scanner
if S.scanner==  2 % behavioral
    onekey =    KbName('1!'); % not vivid
    twokey =    KbName('2@'); % little vivid
    threekey = 	KbName('3#'); % some vivid
    fourkey =  	KbName('4$'); % very vivid
    
    oddkey =    KbName('1!'); %frr change from  '3#'
    evenkey =   KbName('2@'); %frr change from  '4$'
    
elseif S.scanner== 1 %fMRI
    fourkey =   KbName('9('); % very vivid
    threekey =  KbName('8*'); % some vivid
    twokey = 	KbName('7&'); % little vivid
    onekey =  	KbName('6^'); % not vivid
    
    oddkey =    KbName('6^');
    evenkey =   KbName('7&');
end


% fixation parameters
black = 0;
fixlength = 25;
fixwidth = 4;
fixcol = black;

% box parameters
red = [160 0 0];
boxwidth = 6;
boxrect = [xcenter-225/2 ycenter-225/2 xcenter+225/2 ycenter+225/2];

% ------------------------------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      FIRST BLOCK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------------------------------------------------------------------------------------------------

block = scanningrun*2 -1;
if block<10
    BLK = ['block0' num2str(block)];
else
    BLK = ['block' num2str(block)];
end
corename            = ['RIME_fMRI_sub' num2str(sNum) '_' BLK   '_' sName ];
study1NameBlock     = [corename '_Study1'];
vividNameBlock      = [corename '_Vivid'];
corename            = ['RIME_fMRI_sub' num2str(sNum) '_' sName ];
study1Name          = [corename '_Study1'];
vividName           = [corename '_Vivid'];


% Load the stim pictures for the current scanning run
for n = 1:Study1Length
    if (theData.Study1.miniblock{n}==block || theData.Study1.miniblock{n}==block+1) %FRR add Study1
        picname = [theData.Study1.image_vers{n}(3:end) '.jpg'];  %FRR add Study1. This is the filename of the image% FRR changed from Bitem to image http://open.spotify.com/track/4758TUDZ75PgCbDlvfBeKa
        pic = imread([thePath '/stim/images/' picname]); %%%%%%% Hongmi
        [imgheight(n), imgwidth(n), ~] = size(pic);
        imgPtrs(n) = Screen('MakeTexture',S.Window,pic);
    end
end


% Loaded Screen
message = 'Task Loaded';
DrawFormattedText(S.Window,message,'center',ycenter,S.textColor);  % used to say 'center','center'
Screen(S.Window,'Flip');

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Go
while 1
    [keyDown, ~, keyCodes] = KbCheck(-1);
    
    if keyDown
        if keyCodes(S.triggerKey)
            break;
        elseif keyCodes(S.quitKey)
            sca; return;
        end
    end
end

startTime = GetSecs;
Priority(MaxPriority(S.Window));
goTime = 0;
ListenChar(2); %suppresses printing out keypresses on the command window
SetMouse(0,myRect(4)); %get cursor out of the way

% run study phase
RIME_study;

% run vividness phase
RIME_vivid;

%% save for later feedback response

respnum = 0;   %initialize in case participant doesn't response at all
for n = 1:length(theData.Vivid.vividresponse_currblock);
    if theData.Vivid.vividresponse_currblock{n} > 0;
        respnum = respnum + 1;
    else
        respnum = respnum;
    end
end
%% merge to one file
% 
% theNewPath = [vivDir '/'];
% if sNum < 10            % added by RS
%     vividName_allblocks = [theNewPath, vividName(1:14), vividName(end-12:end)]; % RS changed to correct number of letters
% else
%     vividName_allblocks = [theNewPath, vividName(1:15), vividName(end-12:end)]; % RS changed to correct numbers of letters
% end
% 
% if block == 1
%     if exist(vividName_allblocks,'file') == 2  % if the file already exists
%         delete(vividName_allblocks);    % delete it and start from scratch
%     else % if it does nto exist do nothing
%     end
%     %then whenever it is block one, start with the variables we currently have
%     theData.Vivid.vividresponse_alltrials   = [theData.Vivid.vividresponse]; % then create the variables new
%     theData.Vivid.vividRT_alltrials         = [theData.Vivid.vividRT];
% else % if it is another block, load
%     load(vividName_allblocks, 'theData', 'theList')
%     % and append
%     theData.Vivid.vividresponse_alltrials   = [theData.Vivid.vividresponse_alltrials   ; theData.Vivid.vividresponse];
%     theData.Vivid.vividRT_alltrials         = [theData.Vivid.vividRT_alltrials         ; theData.Vivid.vividRT];
% end
% 
% 
% save(vividName_allblocks, 'theData', 'theList')     % save the data and the list
% vividName_allblocks = [vividName_allblocks '_study.mat']; % then save everything with stduy etension
% save(vividName_allblocks)

% ------------------------------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      SECOND BLOCK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block = scanningrun*2;
if block<10
    BLK = ['block0' num2str(block)];
else
    BLK = ['block' num2str(block)];
end
corename            = ['RIME_fMRI_sub' num2str(sNum) '_' BLK   '_' sName ];
study1NameBlock     = [corename '_Study1'];
vividNameBlock      = [corename '_Vivid'];
corename            = ['RIME_fMRI_sub' num2str(sNum) '_' sName ];
study1Name          = [corename '_Study1'];
vividName           = [corename '_Vivid'];

% run study phase
RIME_study;

% run vividness phase
RIME_vivid;

%% save for later feedback response

for n = 1:length(theData.Vivid.vividresponse_currblock);
    if theData.Vivid.vividresponse_currblock{n} > 0;
        respnum = respnum + 1;
    else
        respnum = respnum;
    end
end

%% end of the block 

% fixation
goTime = goTime + endblocktime;
Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

Priority(0);
ListenChar(0); % Hongmi_new: show keypresses

% feedback screen
message = ['Block complete. You responded on \n' num2str(respnum) ' of 12 trials.\n\nPress any key to continue.'];
DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
Screen(S.Window,'Flip');
pause; % pause until user response


end

