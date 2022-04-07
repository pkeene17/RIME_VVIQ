function [goTime startTime theData] = RIME_fMRI_Prac(thePath,sNum,S,dbgn)

% This is just like the original CROFS study - the subject just watches words
% matched with pictures. No keyboard response

%% initialize rand.  
rand('twister',sum(100*clock));
% kbNum=S.kbNum;

%% Read the input file
%cd(thePath.list);

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
pracDir = [subjDir '/Prac'];


if ~isdir(subjDir) %if the directory doesn't alrady exist, create it
    mkdir(subjDir)
    mkdir(pracDir)
elseif ~isdir(pracDir)
    mkdir(pracDir)
end


%% First Round of Practice 
theData.Study1.word        	= {'qqyellow'         'qqmongoose' 'qqcandy'  'qqheadphones'  'qqfolder'       'qqexcited'          'qqstatistics' 'qqkosher'           'qqgraphics' 'qqmeeting'        'qqmemory' 'qqaquamarine'};
theData.Study1.image       	= {'qqAdmin_Building' 'qqBridges'  'qqCoast'  'qqCourtyard'   'qqCrater_Lake'  'qqDuck_Graduation'  'qqflag'       'qqDuck_Motorcycle'  'qqMarket'   'qqDuck_Pushups' 'qqMountain' 'qqOnesie'};
% theData.Study1.image_vers 	= {'qqAcropolis_1'      'qqBono_1'     	'qqGalapagos_Islands_1' 'qqAndes'  'qqJay_Leno_1'  'qqBrush_1'};


theData.Vivid.word          = {'qqfolder'      'qqexcited'         'qqcandy' 'qqstatistics' 'qqgraphics' 'qqmongoose'};
theData.Vivid.image       	= {'qqCrater_Lake' 'qqDuck_Graduation' 'qqCoast' 'qqflag'       'qqMarket'   'qqBridges'};
%theData.Vivid.image_vers    = {'qqAcropolis_1'      'qqBono_1'    	'qqGalapagos_Islands_1' 'qqAndes' 'qqJay_Leno_1'   'qqBrush_1'};



Study1Length	= 12;
VividLength     = 6;


KbName('UnifyKeyNames');
%% Trial Outline
if dbgn == 1 % debugging
    getReadyTime        = .01;
    instrScrTime        = .01;
    startFixTime        = .01;
%   stimTime            = .1;
    fixTime             = .01;
    wordtime            = .01; %added by FRR
    pictime             = .01; %added by FRR
    vividStimTime       = 1;%.01;
    vividRedBoxTime     = 1; 
    feedbacktime        = 3;
    endblocktime        = 3;
% 1.5 + 1 + 1.25 + 1 + 1.25 +1 + 1 = 8
%     oddevenTime         = .1;
%     oddevenFix          = .1;
%     oddevenBetween      = .1;
%     oddevenrepeats      = 1; %how many times the odd/even task repeats
    
elseif dbgn == 0 %no debugging
    %% Trial Outline
    getReadyTime        = 4;
    instrScrTime        = 6;
    startFixTime        = 2;
%   stimTime            = 4;
    fixTime             = 1;
    wordtime            = 1.5; %added by FRR
    pictime             = 1; %added by FRR
    vividStimTime       = 3;
    vividRedBoxTime     = 1; 
    feedbacktime        = 3;
    endblocktime        = 3;
%     oddevenTime         = 1;
%     oddevenFix          = 1.5;
%     oddevenBetween      = 1.25;
%     oddevenrepeats      = 3; %how many times the odd/even task repeats
end

%% Screen commands and device specification
myRect = S.myRect;
Screen('TextSize', S.Window, S.cueTextSize);
Screen('TextFont', S.Window, S.font);
Screen('TextStyle', S.Window, 1);

% get center and box points
xcenter = myRect(3)/2;
ycenter = myRect(4)/2; %+ S.YadjustmentFactor; % FRR commented out S.Yadj.... as we now do not present Word on top of image anymore. so no adjustment necessary
% note that for text I have always used 'center'
% instead of ycenter because the centering did not
% work properly if I didn't

Screen('FillRect', S.Window, S.screenColor);
Screen(S.Window,'Flip');
%cd(thePath.stim);

% oddkey =  '4$';                 %***ask avi whether this is correct
% evenkey = '3#';

%FRR not sure if the keys work like that
onekey =    KbName('1!'); % not vivid
twokey =    KbName('2@'); % little vivid
threekey = 	KbName('3#'); % more vivid
fourkey =  	KbName('4$'); % very vivid

oddkey =    KbName('3#');
evenkey =   KbName('4$');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Up all the pictures and images

% Load fixation
% fileName = 'fix.jpg';
% pic = imread([thePath '/stim/' fileName]);
% [fixHeight fixWidth crap] = size(pic);
% fix = Screen(S.Window,'MakeTexture', pic);
% 
% % Load blank
% fileName = 'blank.jpg';
% pic = imread([thePath '/stim/' fileName]);
% blank = Screen('MakeTexture', S.Window, pic)


% ------------------------------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      STUDY 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------------------------------------------------------------------------------------------------

% Load the stim pictures for the current block
for n = 1:Study1Length
        picname = [theData.Study1.image{n}(3:end) '.jpg'];  %FRR add Study1. This is the filename of the image% FRR changed from Bitem to image http://open.spotify.com/track/4758TUDZ75PgCbDlvfBeKa
        pic = imread([thePath '/stim/practice/' picname]);
        [imgheight(n) imgwidth(n) crap] = size(pic);
        imgPtrs(n) = Screen('MakeTexture',S.Window,pic);
end

%%%%%%%%% Hongmi: fixation parameters. you can change the size and
%%%%%%%%% thickness of the fixation
black = 0;
fixlength = 25;
fixwidth = 4;
fixcol = black;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get everything else ready

% preallocate shit:
for preall = 1:Study1Length
    theData.Study1.onset(preall) = 0; %FRR add Study1
end

%get cursor out of the way
SetMouse(0,myRect(4));




% initiate experiment and begin recording time...
% WAB: took out the quit aspect here because too hard to do during a scan,
% before trigger.

% Loaded Screen
% Screen('DrawTexture', S.Window, blank);
message = 'Task Loaded';
DrawFormattedText(S.Window,message,'center',ycenter,S.textColor);  % used to say 'center','center'
Screen(S.Window,'Flip');

while 1
   [keyDown, secs, keyCodes] = KbCheck;
   if keyDown
       if keyCodes(S.triggerKey)
           break;
       elseif keyCodes(S.quitKey)
           sca; return;
       end
   end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Go
Priority(MaxPriority(S.Window));
startTime = GetSecs;
goTime = 0;

% the below is just for some NULL TIME to start each block
% get ready screen
goTime = goTime + getReadyTime;
% Screen('DrawTexture', S.Window, blank);
message = ['Get ready! \n\n Practice. \n\n Block 1 of 2 '];
DrawFormattedText(S.Window,message,'center','center',S.textColor);  % used to say 'center','center' %FRR changed ycenter to 'center'
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

% % show fixation
% goTime = goTime + startFixTime;
% destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
% Screen('DrawTexture', S.Window, blank);
% Screen('DrawTexture', S.Window, fix,[],destRect);
% Screen(S.Window,'Flip');
Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]);
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);
        

for Trial = 1:Study1Length

        goTime = goTime + wordtime; % changed from >>goTime = goTime + stimTime; <<  by FRR
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Present word + Picture
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Draw the word
%         Screen('DrawTexture', S.Window, blank);
        Screen('TextSize', S.Window, S.cueTextSize);% text size is specified within the loop because it's
        % a different size for the cue and the image name (it alternates within each trial)
        word = theData.Study1.word{Trial}(3:end); %FRR add Study1
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % was -180 ycenter before; changed 100809 % FRR changed ycenter to 'center'
        % make white box to frame image?
        
        %---added by FRR to seperate presentation of word and pic---%
        % Flip (word only)
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Draw the image
        goTime = goTime + pictime; % added for pic only by FRR
        destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
        Screen('DrawTexture',S.Window,imgPtrs(Trial),[],destRect);
        
        % Flip (pic only)
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        
        % Present null (fixation)
        goTime = goTime + fixTime;
%         destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
%         Screen('DrawTexture', S.Window, blank);
%         Screen('DrawTexture', S.Window, fix,[],destRect);
        Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
            0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]);
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
      

end % end of 'for Trial = 1:listLength' loop


% ------------------------------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      VIVIDNESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------------------------------------------------------------------------------------------------
% Load the stim pictures for the current block
% for n = 1:VividLength
%         picname = [theData.Vivid.image{n}(3:end) '.jpg'];  % This is the filename of the image %FRR change from Bitem to image %then changed to image_vers to make sure I get the right version for subject
%         pic = imread([thePath '/stim/practice/' picname]);
%         [imgheight(n) imgwidth(n) crap] = size(pic);
%         imgPtrs(n) = Screen('MakeTexture',S.Window,pic);
% end
% whtBoxPtrs = Screen('MakeTexture',S.Window,imread([thePath '/stim/box.jpg']));%added by FRR to draw white box
% redBoxPtrs = Screen('MakeTexture',S.Window,imread([thePath '/stim/box.jpg']));%added by FRR to draw white box

red = [160 0 0];
boxwidth = 6;
boxrect = [xcenter-225/2 ycenter-225/2 xcenter+225/2 ycenter+225/2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get everything else ready

% preallocate shit:
for preall = 1:VividLength
    theData.Vivid.onset(preall) = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Go

Priority(MaxPriority(S.Window));
%startTime = GetSecs; % FRR cahnged form GetSecs to secs
%goTime = 0;


% the below is just for some null time to start each block
% get ready screen
goTime = goTime + instrScrTime;
% Screen('DrawTexture', S.Window, blank);
message = 'PLEASE RESPOND: \n\n \n\n | 1 |------| 2 |------| 3 |------| 4 | \n\n least vivid    ---    most vivid';
%message = 'Get ready: Vividness Rating! \n\n 1: least vivid   ---   4: most vivid'; % FRR change
DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

% show fixation
goTime = goTime + fixTime; %startFixTime;
% destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
% Screen('DrawTexture', S.Window, blank);
% Screen('DrawTexture', S.Window, fix,[],destRect);
Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
             0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation

Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

for Trial = 1:VividLength
        goTime = goTime + vividStimTime;
        
        %% Present word (FRR commented out Picture )
        % Draw the word
%         Screen('DrawTexture', S.Window, blank);
        Screen('TextSize', S.Window, S.cueTextSize);% text size is specified within the loop because it's
        % a different size for the cue and the image name (it alternates within each trial)
        
%         % Draw the imagebox
%         destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
%         Screen('DrawTexture',S.Window, whtBoxPtrs,[],destRect);
        Screen('FrameRect', S.Window, black ,boxrect, boxwidth);   
        % Draw word
        word = theData.Vivid.word{Trial}(3:end);
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness
        
        % Flip
        Screen(S.Window,'Flip',goTime);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FRR script snippets taking from odd/even phase: recording
        %resposnes in vivdness rating test
        %Collect vivdness repsonse
        
        upTime = GetSecs;
        vividkey = 0;
        vividtime = 0;
        while 1
            [keyDown, secs, keyCodes] = KbCheck(-1); %checks for responses from all KBs
            %keyDown
            if keyDown
                if keyCodes(onekey)
                    vividkey = 1;
                    vividtime = secs - upTime;
                elseif keyCodes(twokey)
                    vividkey = 2;
                    vividtime = secs - upTime;
                elseif keyCodes(threekey)
                    vividkey = 3;
                    vividtime = secs - upTime;
                elseif keyCodes(fourkey)
                    vividkey = 4;
                    vividtime = secs - upTime;
                elseif keyCodes(S.quitKey)
                    fclose(fp); sca; return;
                end
            end
            if GetSecs-startTime > goTime
                break;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % after the first 3 seconds show the same thing, either with a white or a red box, for one more second. 
        % White or red depends on whether participants have already replied 
        
        goTime = goTime + vividRedBoxTime;
        % Draw the word
%         Screen('DrawTexture', S.Window, blank);
        Screen('TextSize', S.Window, S.cueTextSize);% text size is specified within the loop because it's
        % a different size for the cue and the image name (it alternates within each trial)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hongmi: Draw the imagebox
%         destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
        if vividkey == 0
%             Screen('DrawTexture',S.Window, redBoxPtrs,[],destRect); %REDBOX if no response so far
            Screen('FrameRect', S.Window, red ,boxrect, boxwidth);

        else
%             Screen('DrawTexture',S.Window, whtBoxPtrs,[],destRect);
            Screen('FrameRect', S.Window, black ,boxrect, boxwidth);

        end
        
        % Draw word
        word = theData.Vivid.word{Trial}(3:end);
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness
        
        % Flip
        Screen(S.Window,'Flip',goTime);
        upTime = GetSecs;
%         vividkey = 0;
%         vividtime = 0;
        while 1
            [keyDown, secs, keyCodes] = KbCheck(-1); %checks for responses from all KBs
            %keyDown
            if keyDown
                if keyCodes(onekey)
                    vividkey = 1;
                    vividtime = secs - upTime;
                elseif keyCodes(twokey)
                    vividkey = 2;
                    vividtime = secs - upTime;
                elseif keyCodes(threekey)
                    vividkey = 3;
                    vividtime = secs - upTime;
                elseif keyCodes(fourkey)
                    vividkey = 4;
                    vividtime = secs - upTime;
                elseif keyCodes(S.quitKey)
                    fclose(fp); sca; return;
                end
             end  
            if GetSecs-startTime > goTime
                break;
            end
        end
        
        % recordKeys(startTime,goTime,S.kbNum); %FRR note: commented out in other script as well
         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
        blockTrial = mod(Trial,6);
        if blockTrial ==0
            blockTrial=6;
        end
        % theData.Test.vividresponseExpTrial{Trial,1} = vividkey; %FRR replaced repeats with 1 as we do not repeat the rating
        % theData.Test.vividRTExpTrial{Trial,1} = vividtime;
        theData.Vivid.vividresponse_currblock{blockTrial,1} = vividkey; % FRR replaced repeats with 1 as we do not repeat the rating
        theData.Vivid.vividRT_currblock{blockTrial,1}       = vividtime;
        theData.Vivid.vividresponse{Trial,1}    = vividkey;     % this is needed when I am appending the file that saves across blocks
        theData.Vivid.vividRT{Trial,1}          = vividtime;       
        
        recordKeys(startTime,goTime,S.kbNum); %FRR just waites
     
        % Present null (fixation)
        goTime = goTime + fixTime;
%         destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
%         Screen('DrawTexture', S.Window, blank);
%         Screen('DrawTexture', S.Window, fix,[],destRect);
        Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
             0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
        Screen(S.Window,'Flip',goTime);
        
        recordKeys(startTime,goTime,S.kbNum);
        
        
        eval(['save ' pracDir '/' 'prac' '.mat theData '])
%   
respnum = [0];   %initialize in case participant doesn't response at all
        for n = 1:length(theData.Vivid.vividresponse_currblock);
            if theData.Vivid.vividresponse_currblock{n} > 0;
                respnum = respnum + 1;
            else respnum = respnum;  
            end
        end
end 
%     Screen('DrawTexture', S.Window, blank);
    Screen(S.Window,'Flip');
% feedback screen 
        goTime = goTime + feedbacktime;
        % Screen('DrawTexture', S.Window, blank); %Hongmi: we don't need this
        message = ['Block complete. You responded on \n' num2str(respnum) ' of 6 trials.'];
        DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);        

        % 'Block Complete' screen
        goTime = goTime + endblocktime;
        % Screen('DrawTexture', S.Window, blank); %Hongmi: we don't need this
        message = ['Block complete.'];
        DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Second Round of Practice 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

theData.Study1.word        	= {'qqfabric' 'qqcrew'            'qqgift'        'qqdeli'    'qqhumility' 'qqammunition'     'qqchicken' 'qqnormal' 'qqbless'      'qqsorrow'     'qqentity'    'qqroyalty'};
theData.Study1.image       	= {'qqPath'   'qqPioneer_Mother'  'qqPlayground'  'qqRiver'   'qqSign'     'qqSkinner_Butte'  'qqStadium' 'qqStone'  'qqTree_Boy'   'qqUmbrella'   'qqWaterfall' 'qqWelcome_Sign'};
% theData.Study1.image_vers 	= {'qqAcropolis_1'      'qqBono_1'     	'qqGalapagos_Islands_1' 'qqAndes'  'qqJay_Leno_1'  'qqBrush_1'};


theData.Vivid.word          = {'qqcrew'           'qqhumility' 'qqgift'       'qqbless'    'qqammunition'    'qqdeli'};
theData.Vivid.image       	= {'qqPioneer_Mother' 'qqSign'     'qqPlayground' 'qqTree_Boy' 'qqSkinner_Butte' 'qqRiver'};
%theData.Vivid.image_vers    = {'qqAcropolis_1'      'qqBono_1'    	'qqGalapagos_Islands_1' 'qqAndes' 'qqJay_Leno_1'   'qqBrush_1'};



%% Screen commands and device specification
myRect = S.myRect;
Screen('TextSize', S.Window, S.cueTextSize);
Screen('TextFont', S.Window, S.font);
Screen('TextStyle', S.Window, 1);

% get center and box points
xcenter = myRect(3)/2;
ycenter = myRect(4)/2; %+ S.YadjustmentFactor; % FRR commented out S.Yadj.... as we now do not present Word on top of image anymore. so no adjustment necessary
% note that for text I have always used 'center'
% instead of ycenter because the centering did not
% work properly if I didn't

Screen('FillRect', S.Window, S.screenColor);
Screen(S.Window,'Flip');
%cd(thePath.stim);

% oddkey =  '4$';                 %***ask avi whether this is correct
% evenkey = '3#';

%FRR not sure if the keys work like that
onekey =    KbName('1!'); % not vivid
twokey =    KbName('2@'); % little vivid
threekey = 	KbName('3#'); % more vivid
fourkey =  	KbName('4$'); % very vivid

oddkey =    KbName('3#');
evenkey =   KbName('4$');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Up all the pictures and images


% ------------------------------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      STUDY 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------------------------------------------------------------------------------------------------

% Load the stim pictures for the current block
for n = 1:Study1Length
        picname = [theData.Study1.image{n}(3:end) '.jpg'];  %FRR add Study1. This is the filename of the image% FRR changed from Bitem to image http://open.spotify.com/track/4758TUDZ75PgCbDlvfBeKa
        pic = imread([thePath '/stim/practice/' picname]);
        [imgheight(n) imgwidth(n) crap] = size(pic);
        imgPtrs(n) = Screen('MakeTexture',S.Window,pic);
end

%%%%%%%%% Hongmi: fixation parameters. you can change the size and
%%%%%%%%% thickness of the fixation
black = 0;
fixlength = 25;
fixwidth = 4;
fixcol = black;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get everything else ready

% preallocate shit:
for preall = 1:Study1Length
    theData.Study1.onset(preall) = 0; %FRR add Study1
end

%get cursor out of the way
SetMouse(0,myRect(4));




% initiate experiment and begin recording time...
% WAB: took out the quit aspect here because too hard to do during a scan,
% before trigger.

% Loaded Screen
% Screen('DrawTexture', S.Window, blank);
message = 'Task Loaded';
DrawFormattedText(S.Window,message,'center',ycenter,S.textColor);  % used to say 'center','center'
Screen(S.Window,'Flip');

while 1
   [keyDown, secs, keyCodes] = KbCheck;
   if keyDown
       if keyCodes(S.triggerKey)
           break;
       elseif keyCodes(S.quitKey)
           sca; return;
       end
   end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Go
Priority(MaxPriority(S.Window));
startTime = GetSecs;
goTime = 0;

% the below is just for some NULL TIME to start each block
% get ready screen
goTime = goTime + getReadyTime;
% Screen('DrawTexture', S.Window, blank);
message = ['Get ready! \n\n Practice. \n\n Block 2 of 2 '];
DrawFormattedText(S.Window,message,'center','center',S.textColor);  % used to say 'center','center' %FRR changed ycenter to 'center'
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

% % show fixation
% goTime = goTime + startFixTime;
% destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
% Screen('DrawTexture', S.Window, blank);
% Screen('DrawTexture', S.Window, fix,[],destRect);
% Screen(S.Window,'Flip');
Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]);
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);
        

for Trial = 1:Study1Length

        goTime = goTime + wordtime; % changed from >>goTime = goTime + stimTime; <<  by FRR
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Present word + Picture
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Draw the word
%         Screen('DrawTexture', S.Window, blank);
        Screen('TextSize', S.Window, S.cueTextSize);% text size is specified within the loop because it's
        % a different size for the cue and the image name (it alternates within each trial)
        word = theData.Study1.word{Trial}(3:end); %FRR add Study1
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % was -180 ycenter before; changed 100809 % FRR changed ycenter to 'center'
        % make white box to frame image?
        
        %---added by FRR to seperate presentation of word and pic---%
        % Flip (word only)
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Draw the image
        goTime = goTime + pictime; % added for pic only by FRR
        destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
        Screen('DrawTexture',S.Window,imgPtrs(Trial),[],destRect);
        
        % Flip (pic only)
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        
        % Present null (fixation)
        goTime = goTime + fixTime;
%         destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
%         Screen('DrawTexture', S.Window, blank);
%         Screen('DrawTexture', S.Window, fix,[],destRect);
        Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
            0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]);
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
      

end % end of 'for Trial = 1:listLength' loop


% ------------------------------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      VIVIDNESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------------------------------------------------------------------------------------------------
% Load the stim pictures for the current block
% for n = 1:VividLength
%         picname = [theData.Vivid.image{n}(3:end) '.jpg'];  % This is the filename of the image %FRR change from Bitem to image %then changed to image_vers to make sure I get the right version for subject
%         pic = imread([thePath '/stim/practice/' picname]);
%         [imgheight(n) imgwidth(n) crap] = size(pic);
%         imgPtrs(n) = Screen('MakeTexture',S.Window,pic);
% end
% whtBoxPtrs = Screen('MakeTexture',S.Window,imread([thePath '/stim/box.jpg']));%added by FRR to draw white box
% redBoxPtrs = Screen('MakeTexture',S.Window,imread([thePath '/stim/box.jpg']));%added by FRR to draw white box

red = [160 0 0];
boxwidth = 6;
boxrect = [xcenter-225/2 ycenter-225/2 xcenter+225/2 ycenter+225/2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get everything else ready

% preallocate shit:
for preall = 1:VividLength
    theData.Vivid.onset(preall) = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Go

Priority(MaxPriority(S.Window));
%startTime = GetSecs; % FRR cahnged form GetSecs to secs
%goTime = 0;


% the below is just for some null time to start each block
% get ready screen
goTime = goTime + instrScrTime;
% Screen('DrawTexture', S.Window, blank);
message = 'PLEASE RESPOND: \n\n \n\n | 1 |------| 2 |------| 3 |------| 4 | \n\n least vivid    ---    most vivid';
%message = 'Get ready: Vividness Rating! \n\n 1: least vivid   ---   4: most vivid'; % FRR change
DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

% show fixation
goTime = goTime + fixTime; %startFixTime;
% destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
% Screen('DrawTexture', S.Window, blank);
% Screen('DrawTexture', S.Window, fix,[],destRect);
Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
             0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation

Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

for Trial = 1:VividLength
        goTime = goTime + vividStimTime;
        
        %% Present word (FRR commented out Picture )
        % Draw the word
%         Screen('DrawTexture', S.Window, blank);
        Screen('TextSize', S.Window, S.cueTextSize);% text size is specified within the loop because it's
        % a different size for the cue and the image name (it alternates within each trial)
        
%         % Draw the imagebox
%         destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
%         Screen('DrawTexture',S.Window, whtBoxPtrs,[],destRect);
        Screen('FrameRect', S.Window, black ,boxrect, boxwidth);   
        % Draw word
        word = theData.Vivid.word{Trial}(3:end);
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness
        
        % Flip
        Screen(S.Window,'Flip',goTime);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FRR script snippets taking from odd/even phase: recording
        %resposnes in vivdness rating test
        %Collect vivdness repsonse
        
        upTime = GetSecs;
%         vividkey = 0;
%         vividtime = 0;
        while 1
            [keyDown, secs, keyCodes] = KbCheck(-1); %checks for responses from all KBs
            %keyDown
            if keyDown
                if keyCodes(onekey)
                    vividkey = 1;
                    vividtime = secs - upTime;
                elseif keyCodes(twokey)
                    vividkey = 2;
                    vividtime = secs - upTime;
                elseif keyCodes(threekey)
                    vividkey = 3;
                    vividtime = secs - upTime;
                elseif keyCodes(fourkey)
                    vividkey = 4;
                    vividtime = secs - upTime;
                elseif keyCodes(S.quitKey)
                    fclose(fp); sca; return;
                end
            end
            if GetSecs-startTime > goTime
                break;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % after the first 3 seconds show the same thing, either with a white or a red box, for one more second. 
        % White or red depends on whether participants have already replied 
        
        goTime = goTime + vividRedBoxTime;
        % Draw the word
%         Screen('DrawTexture', S.Window, blank);
        Screen('TextSize', S.Window, S.cueTextSize);% text size is specified within the loop because it's
        % a different size for the cue and the image name (it alternates within each trial)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hongmi: Draw the imagebox
%         destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
        if vividkey == 0
%             Screen('DrawTexture',S.Window, redBoxPtrs,[],destRect); %REDBOX if no response so far
            Screen('FrameRect', S.Window, red ,boxrect, boxwidth);

        else
%             Screen('DrawTexture',S.Window, whtBoxPtrs,[],destRect);
            Screen('FrameRect', S.Window, black ,boxrect, boxwidth);

        end
        
        % Draw word
        word = theData.Vivid.word{Trial}(3:end);
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness
        
        % Flip
        Screen(S.Window,'Flip',goTime);
        upTime = GetSecs;
%         vividkey = 0;
%         vividtime = 0;
        while 1
            [keyDown, secs, keyCodes] = KbCheck(-1); %checks for responses from all KBs
            %keyDown
            if keyDown
                if keyCodes(onekey)
                    vividkey = 1;
                    vividtime = secs - upTime;
                elseif keyCodes(twokey)
                    vividkey = 2;
                    vividtime = secs - upTime;
                elseif keyCodes(threekey)
                    vividkey = 3;
                    vividtime = secs - upTime;
                elseif keyCodes(fourkey)
                    vividkey = 4;
                    vividtime = secs - upTime;
                elseif keyCodes(S.quitKey)
                    fclose(fp); sca; return;
                end
             end  
            if GetSecs-startTime > goTime
                break;
            end
        end
        
        % recordKeys(startTime,goTime,S.kbNum); %FRR note: commented out in other script as well
         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
        blockTrial = mod(Trial,3);
        if blockTrial ==0
            blockTrial=3;
        end
        % theData.Test.vividresponseExpTrial{Trial,1} = vividkey; %FRR replaced repeats with 1 as we do not repeat the rating
        % theData.Test.vividRTExpTrial{Trial,1} = vividtime;
        theData.Vivid.vividresponse_currblock{blockTrial,1} = vividkey; % FRR replaced repeats with 1 as we do not repeat the rating
        theData.Vivid.vividRT_currblock{blockTrial,1}       = vividtime;
        theData.Vivid.vividresponse{Trial,1}    = vividkey;     % this is needed when I am appending the file that saves across blocks
        theData.Vivid.vividRT{Trial,1}          = vividtime;       
        
        recordKeys(startTime,goTime,S.kbNum); %FRR just waites
        
        eval(['save ' pracDir '/' 'prac' '.mat theData '])
        
        % Present null (fixation)
        goTime = goTime + fixTime;
%         destRect = [xcenter-fixWidth/2 ycenter-fixHeight/2 xcenter+fixWidth/2 ycenter+fixHeight/2];
%         Screen('DrawTexture', S.Window, blank);
%         Screen('DrawTexture', S.Window, fix,[],destRect);
        Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
             0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
        Screen(S.Window,'Flip',goTime);
        
        recordKeys(startTime,goTime,S.kbNum);
        Screen(S.Window,'Flip');
        
%%Feedback screen
end


respnum = [0];   %initialize in case participant doesn't response at all
        for n = 1:length(theData.Vivid.vividresponse_currblock);
            if theData.Vivid.vividresponse_currblock{n} > 0;
                respnum = respnum + 1;
            else respnum = respnum;  
            end
        end

        % feedback screen 
        goTime = goTime + feedbacktime;
        % Screen('DrawTexture', S.Window, blank); %Hongmi: we don't need this
        message = ['Block complete. You responded on \n' num2str(respnum) ' of 6 trials.'];
        DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);        

        % 'Block Complete' screen
        goTime = goTime + endblocktime;
        % Screen('DrawTexture', S.Window, blank); %Hongmi: we don't need this
        message = ['Block complete.'];
        DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum)
    
   
%     Screen('DrawTexture', S.Window, blank);
    
    Priority(0);
    cd(thePath)
end
