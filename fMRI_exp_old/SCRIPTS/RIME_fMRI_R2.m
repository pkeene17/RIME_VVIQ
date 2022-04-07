function theData = RIME_fMRI_R2(thePath,sNum,S,R2Name,block)    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: record keys does NOT actually record keys we just use it as a delay for the script to wait until go-time. We use kbcheck to check fore key
% resonses :D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is just like the original CROFS study - the subject just watches words matched with pictures. No keyboard response

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

if sNum < 10
    subj = ['0' num2str(sNum)];
else
    subj = num2str(sNum);
end

subjDir = [thePath '/Data/' subj];
R2Dir = [subjDir '/R2'];

% Hongmi_new
if ~isdir(subjDir)
    mkdir(subjDir)
    mkdir(R2Dir)
end
if ~isdir(R2Dir)
    mkdir(R2Dir)
end

% Tell Matlab to stop listening to keyboard input 
%(frr: this needs to be included so I can print some variables to the screen during the
% experimetn as a sanity check while the scanner runs. It also means the
% backticks (triggers) are not displayed anymore, says Avi0. )
% NOTE: GET KEYBOARD BACK WITH >>CONTROL+COMMAND+C<< ON MAC
ListenChar(2); %frr <-- this causes the script to crash the first time you try to run it oftentimes, but than you just have to restart it and it works (Avi and Hongmi experience the sane thing).

% as we need to read in different randomizations for list1, (list2- we dropped this) and test
load([thePath '/LIST/allLists.mat']);
load([thePath '/LIST/retrieve2List.mat']);

theList.Study1      = lists{sNum}.Study1;
theList.Vivid       = lists{sNum}.Vivid;
retrieveLength      = length(retrieve2List{sNum}); %96

clear lists
% trialsPerStudy1 = 12; 
% trialsPerVivid  = 6;
% totalBlocks = 16; 

% mostly copied/ adapted from old REI script based on MEG script
% theData.Study1.condition        = theList.Study1(1,:);
% theData.Study1.conID            = theList.Study1(2,:);
% theData.Study1.wordID           = theList.Study1(3,:); %; was word id
% theData.Study1.imageID          = theList.Study1(4,:); %; was BitemID
% theData.Study1.word             = theList.Study1(5,:); %; was CitemID
% theData.Study1.image            = theList.Study1(6,:); %; was word
% theData.Study1.miniblock        = theList.Study1(7,:); %; was Bitem
% theData.Study1.category         = theList.Study1(8,:); % (face 1; scene 2; object 3;); was Citem
% theData.Study1.image_vers       = theList.Study1(9,:); % (_1 or _2 - which ever one is used in this condition in this phase, so I can always read in image_vers and not worry about it later)
% theData.Study1.image_vers_code 	= theList.Study1(10,:); % code which tells me whether for this subejct the original in study1 had extension _1 or _2

theData.R2.condition         = retrieve2List{sNum}(1,:);
theData.R2.conID             = retrieve2List{sNum}(2,:);
theData.R2.wordID            = retrieve2List{sNum}(3,:);
theData.R2.imageID           = retrieve2List{sNum}(4,:);
theData.R2.word              = retrieve2List{sNum}(5,:);
theData.R2.image             = retrieve2List{sNum}(6,:);
theData.R2.miniblock         = retrieve2List{sNum}(7,:);
theData.R2.category          = retrieve2List{sNum}(8,:);
theData.R2.image_vers        = retrieve2List{sNum}(9,:); % (_1 or _2 - which ever one is used in this condition in this phase, so I can always read in image_vers and not worry about it later)
theData.R2.image_vers_code 	 = retrieve2List{sNum}(10,:); % code which tells me whether for this subejct the original in study1 had extension _1 or _2
%theData.R2.nonzero           = [];

KbName('UnifyKeyNames');


% dbgnfact = 1; % to easily ajust dbgn display time 
%% Trial Outline
% if dbgn == 1 % debugging
%     getReadyTime        = 6/dbgnfact;
%     instrScrTime        = 6/dbgnfact;
%     startFixTime        = 2/dbgnfact;
%    % fixTime             = 1/dbgnfact;% was necessary when I did not have the  odd/even task 
%     wordtime            = 1.5/dbgnfact; %added by FRR
%     pictime             = 2.5/dbgnfact; %added by FRR
%     vividStimTime       = 3/dbgnfact;
%     vividRedBoxTime     = 1/dbgnfact; 
%     oddevenTime         = 1/dbgnfact;    % 1.25+1+1.25+1.25+1+1.25 = 8
%     oddevenFix          = 1.25/dbgnfact;
%     oddevenBetween      = 1.25/dbgnfact;
%     oddevenrepeats      = 3; %how many times the odd/even task repeats
% elseif dbgn == 0 %no debugging
    %% Trial Outline
    
    instrScrTime        = 4; %changed from 6 RS
    startFixTime        = 6;
    vividStimTime       = 3;
    vividRedBoxTime     = 1; 
    vividFixTime        = 4; % added by RS
    endblocktime        = 6; 

%end

%% Screen commands and device specification
myRect = S.myRect;
Screen('TextSize', S.Window, S.cueTextSize);
Screen('TextFont', S.Window, S.font);
Screen('TextStyle', S.Window, 1);

% get center and box points
xcenter = myRect(3)/2;
ycenter = myRect(4)/2; %+ S.YadjustmentFactor; % FRR commented out S.Yadj.... as we now do not present Word on top of image anymore. so no adjustment necessary
% note that for text I have always used 'center' instead of ycenter because the centering did not work properly if I didn't

% the bottom box in the scanner codes index as 4 and pinky as 1 so we have
% to reverse the coding for the scanner
if S.scanner==  2 % behavioral 
    onekey =    KbName('1!'); % not vivid
    twokey =    KbName('2@'); % little vivid
    threekey = 	KbName('3#'); % some vivid
    fourkey =  	KbName('4$'); % very vivid

elseif S.scanner== 1 %fMRI
    fourkey =   KbName('9('); % very vivid
    threekey =  KbName('8*'); % some vivid
    twokey = 	KbName('7&'); % little vivid
    onekey =  	KbName('6^'); % not vivid
end

% fixation parameters
black = 0;
fixlength = 25;
fixwidth = 4;
fixcol = black;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get everything else ready


for preall = 1:retrieveLength
    theData.R2.onset(preall) = 0; %<-- this will code the actual measured onset of the trial (here the trial begins with the word), so it should be almost identical to plannedplannedwordonset
    theData.R2.plannedwordonset(preall) = 0; 
    theData.R2.plannedpreoddevenfixonset(preall) = 0; 
    theData.R2.plannedpostoddevenfixonset(preall) = 0; 
end

% deleted Study1 coding, took up too much space - for reference, see fMRIclass_S1ONLY_Vivid RS 4/7/15
% ------------------------------------------------------------------------------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%                      VIVIDNESS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ------------------------------------------------------------------------------------------------------------------------
    
    red = [160 0 0];
    boxwidth = 6;
    boxrect = [xcenter-225/2 ycenter-225/2 xcenter+225/2 ycenter+225/2];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %get cursor out of the way
    SetMouse(0,myRect(4));

    % initiate experiment and begin recording time...
    % WAB: took out the quit aspect here because too hard to do during a scan,
    % before trigger.

    % % Loaded Screen
%    Screen('DrawTexture', S.Window, blank); commented out by RS per Hongmi
    message = 'Task Loaded';
    DrawFormattedText(S.Window,message,'center','center',S.textColor);  % used to say 'center','center' %FRR changed back from 'center',ycenter
    Screen(S.Window,'Flip');
    
    while 1
        [keyDown, secs, keyCodes] = KbCheck(-1);
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
    %bPriority(MaxPriority(S.Window));
    startTime = GetSecs; % FRR cahnged form GetSecs to secs
    goTime = 0;

    % the below is just for some null time to start each block
    % get ready screen
    goTime = goTime + instrScrTime;
    theData.R2.plannedReminderonset(block) = goTime-instrScrTime; 

    message = 'PLEASE RESPOND: \n\n \n\n | 1 |------| 2 |------| 3 |------| 4 | \n\n least vivid    ---    most vivid';
    DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
    Screen(S.Window,'Flip');
    recordKeys(startTime,goTime,S.kbNum);

    % show fixation
    goTime = goTime + startFixTime;
    theData.Vivid.plannedStartFixonset(block) = goTime-startFixTime; 

    Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %added by RS per Hongmi


    Screen(S.Window,'Flip');
    recordKeys(startTime,goTime,S.kbNum);
    
    for Trial = 1:48 %changed from retrieveLength RS
  

            goTime = goTime + vividStimTime;
            theData.R2.plannedwordonset(Trial) = goTime - vividStimTime;
            
            %% Present word (FRR commented out Picture )

            % Draw the imagebox
            Screen('FrameRect', S.Window, black ,boxrect, boxwidth);

            % Draw word
            word = theData.R2.word{Trial}(3:end);
            DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness

            % Flip
            initTrial = Screen(S.Window,'Flip');
            realonset = initTrial-startTime; % <--- keep this as a seperate line to print stuff later
            theData.R2.onset(Trial) = realonset; %<---------------------------------------------------- actual trial onset time

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %FRR script snippets taking from odd/even phase: recording resposnes in vivdness rating test
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
%                     elseif keyCodes(S.quitKey)    commented out RS 4/13/15 unnecessary and gave me an error
%                         fclose(fp); sca; return;
                    end
                 end  
                if GetSecs - startTime > goTime
                    break;
                end
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % after the first 3 seconds show the same thing, either with a
            % white or a red box, for one more second.  White or red
            % depends on whether participants have already replied
            goTime = goTime + vividRedBoxTime;
            
            % Draw the word
            word = theData.R2.word{Trial}(3:end);
            DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness
            
            % Draw the imagebox
            if vividkey == 0
                Screen('FrameRect', S.Window, red ,boxrect, boxwidth);
            else
                Screen('FrameRect', S.Window, black ,boxrect, boxwidth);
            end

            % Flip
            Screen(S.Window,'Flip');
            upTime = GetSecs;
            
           
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %FRR script snippets taking from odd/even phase: recording resposnes in vivdness rating test
            %Collect vivdness repsonse
            while 1
                [keyDown, secs, keyCodes] = KbCheck(-1); %checks for responses from all KBs
                if keyDown
                    if keyCodes(onekey)
                        vividkey = 1;
                        vividtime = secs - upTime + vividStimTime; %forgot this before - we need to add the time of the whitebox too :-)                                                                                                                                                                                                            
                    elseif keyCodes(twokey)
                        vividkey = 2;
                        vividtime = secs - upTime + vividStimTime;
                    elseif keyCodes(threekey)
                        vividkey = 3;
                        vividtime = secs - upTime + vividStimTime;
                    elseif keyCodes(fourkey)
                        vividkey = 4;
                        vividtime = secs - upTime + vividStimTime;
                    elseif keyCodes(S.quitKey)
                        fclose(fp); sca; return;
                    end
                 end  
                if GetSecs - startTime > goTime
                    break;
                end
            end
            % recordKeys(startTime,goTime,S.kbNum); %FRR note: commented out in other script as well


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            blockTrial = Trial; %changed b/c only 1 block RS 4/7/15
            
            theData.R2.vividresponse_currblock{blockTrial,1} = vividkey; % FRR replaced repeats with 1 as we do not repeat the rating
            theData.R2.vividRT_currblock{blockTrial,1}       = vividtime;
            theData.R2.vividresponse{Trial,1}    = vividkey;     % this is needed when I am appending the file that saves across blocks
            theData.R2.vividRT{Trial,1}          = vividtime;       

            recordKeys(startTime,goTime,S.kbNum); %FRR just waites

 
    %commented out when using odd/even task, as I am usung the other fixation code above        
%            Present null (fixation)
            goTime = goTime + vividFixTime; % changed from fixTime by RS
            Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ... %added by RS per Hongmi
             0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
          
            Screen(S.Window,'Flip');
            recordKeys(startTime,goTime,S.kbNum);
            
            % RECORD RESPONSES
            %--------------------------

            theData.R2.allonsets = [theData.R2.onset; theData.R2.plannedwordonset];%theData.R2.plannedpreoddevenfixonset;theData.R2.plannedpostoddevenfixonset]; %not using odd/even task
            
            eval(['save ' R2Dir '/' R2Name ' theData theList'])
%             eval(['save ' R2Dir '/' R2Name '_study.mat'])

            % the below is the edited version of the above RS 4/8/15
            fprintf('blk: %d Trial: %d plannedon: %4.2f realon: %4.2f, VIVIDrt: %4.2f, VIVIDresp: %d\n',...
            block, Trial, theData.R2.plannedwordonset(1,Trial),theData.R2.onset(Trial),....
            cell2mat(theData.R2.vividRT(Trial)), cell2mat(theData.R2.vividresponse(Trial)) );

        
    end 

    % fixation
    goTime = goTime + endblocktime;
    Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
        0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]);
    Screen(S.Window,'Flip');
    recordKeys(startTime,goTime,S.kbNum);
    
    %% feedback
    ListenChar(0); % Hongmi_new: show keypresses

    respnum = 0;   %initialize in case participant doesn't response at all
    for n = 1:length(theData.R2.vividresponse_currblock);
        if theData.R2.vividresponse_currblock{n} > 0;
            respnum = respnum + 1;
        else
            respnum = respnum;
        end
    end
    
    message = ['Block complete. You responded on \n' num2str(respnum) ' of 48 trials.\n\nPress any key to continue.'];
    DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
    Screen(S.Window,'Flip');
    pause;
    
    ListenChar(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
    message = 'Task Loaded';
    DrawFormattedText(S.Window,message,'center','center',S.textColor);  % used to say 'center','center' %FRR changed back from 'center',ycenter
    Screen(S.Window,'Flip');
    while 1
        [keyDown, secs, keyCodes] = KbCheck(-1);
        if keyDown
            if keyCodes(S.triggerKey)
                break;
            elseif keyCodes(S.quitKey)
                sca; return;
            end
        end
    end

    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now for the second half of V1
    startTime = GetSecs; % FRR cahnged form GetSecs to secs
    goTime = 0;

    % the below is just for some null time to start each block
    % get ready screen
    goTime = goTime + instrScrTime;
    theData.R2.plannedReminderonset(block) = goTime-instrScrTime; 

%    Screen('DrawTexture', S.Window, blank); commented out by RS per Hongmi
    message = 'PLEASE RESPOND: \n\n \n\n | 1 |------| 2 |------| 3 |------| 4 | \n\n least vivid    ---    most vivid';
    DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
    Screen(S.Window,'Flip');
    recordKeys(startTime,goTime,S.kbNum);

    % show fixation
    goTime = goTime + startFixTime;
    theData.Vivid.plannedStartFixonset(block) = goTime-startFixTime; 
    
    Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %added by RS per Hongmi

    Screen(S.Window,'Flip');
    recordKeys(startTime,goTime,S.kbNum);

    for Trial = 49:retrieveLength
  
            goTime = goTime + vividStimTime;
            theData.R2.plannedwordonset(Trial) = goTime - vividStimTime;

            %% Present word (FRR commented out Picture )

            % Draw the imagebox
            Screen('FrameRect', S.Window, black ,boxrect, boxwidth);

            % Draw word
            word = theData.R2.word{Trial}(3:end);
            DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness

            % Flip
            initTrial = Screen(S.Window,'Flip');
            realonset = initTrial-startTime; % <--- keep this as a seperate line to print stuff later
            theData.R2.onset(Trial) = realonset; %<---------------------------------------------------- actual trial onset time

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %FRR script snippets taking from odd/even phase: recording resposnes in vivdness rating test
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
%                     elseif keyCodes(S.quitKey)    commented out RS 4/13/15 unnecessary and gave me an error
%                         fclose(fp); sca; return;
                    end
                 end  
                if GetSecs - startTime > goTime
                    break;
                end
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % after the first 3 seconds show the same thing, either with a
            % white or a red box, for one more second.  White or red
            % depends on whether participants have already replied
            goTime = goTime + vividRedBoxTime;
            
            % Draw the imagebox
            if vividkey == 0
                Screen('FrameRect', S.Window, red ,boxrect, boxwidth);
            else
                Screen('FrameRect', S.Window, black ,boxrect, boxwidth);
                
            end
            
            % Draw word
            word = theData.R2.word{Trial}(3:end);
            DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness

            % Flip
            Screen(S.Window,'Flip');
            upTime = GetSecs;
            
           
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %FRR script snippets taking from odd/even phase: recording resposnes in vivdness rating test
            %Collect vivdness repsonse
            while 1
                [keyDown, secs, keyCodes] = KbCheck(-1); %checks for responses from all KBs
                if keyDown
                    if keyCodes(onekey)
                        vividkey = 1;
                        vividtime = secs - upTime + vividStimTime; %forgot this before - we need to add the time of the whitebox too :-)                                                                                                                                                                                                            
                    elseif keyCodes(twokey)
                        vividkey = 2;
                        vividtime = secs - upTime + vividStimTime;
                    elseif keyCodes(threekey)
                        vividkey = 3;
                        vividtime = secs - upTime + vividStimTime;
                    elseif keyCodes(fourkey)
                        vividkey = 4;
                        vividtime = secs - upTime + vividStimTime;
                    elseif keyCodes(S.quitKey)
                        fclose(fp); sca; return;
                    end
                 end  
                if GetSecs - startTime > goTime
                    break;
                end
            end
            % recordKeys(startTime,goTime,S.kbNum); %FRR note: commented out in other script as well


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            blockTrial = Trial; %changed b/c only 1 block RS 4/7/15
            
            theData.R2.vividresponse_currblock{blockTrial,1} = vividkey; % FRR replaced repeats with 1 as we do not repeat the rating
            theData.R2.vividRT_currblock{blockTrial,1}       = vividtime;
            theData.R2.vividresponse{Trial,1}    = vividkey;     % this is needed when I am appending the file that saves across blocks
            theData.R2.vividRT{Trial,1}          = vividtime;       

            recordKeys(startTime,goTime,S.kbNum); %FRR just waites

            % fixation
            goTime = goTime + vividFixTime; % changed from fixTime by RS
            Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ... %added by RS per Hongmi
             0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
          
            Screen(S.Window,'Flip');
            recordKeys(startTime,goTime,S.kbNum);


            % RECORD RESPONSES
            %--------------------------

            theData.R2.allonsets = [theData.R2.onset; theData.R2.plannedwordonset];%theData.R2.plannedpreoddevenfixonset;theData.R2.plannedpostoddevenfixonset]; %not using odd/even task

            eval(['save ' R2Dir '/' R2Name ' theData theList'])
%             eval(['save ' R2Dir '/' R2Name '_study.mat'])

            fprintf('blk: %d Trial: %d plannedon: %4.2f realon: %4.2f, VIVIDrt: %4.2f, VIVIDresp: %d\n',...
            block, Trial, theData.R2.plannedwordonset(1,Trial),theData.R2.onset(Trial),....
            cell2mat(theData.R2.vividRT(Trial)), cell2mat(theData.R2.vividresponse(Trial)) );
        
    end 
    
    % fixation
    goTime = goTime + endblocktime;
    Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
        0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]);
    Screen(S.Window,'Flip');
    recordKeys(startTime,goTime,S.kbNum);
    
    %% feedback
    ListenChar(0);
    
    respnum = 0;   %initialize in case participant doesn't response at all
    for n = 49:length(theData.R2.vividresponse_currblock);
        if theData.R2.vividresponse_currblock{n} > 0;
            respnum = respnum + 1;
        else
            respnum = respnum;
        end
    end
    
    message = ['Block complete. You responded on \n' num2str(respnum) ' of 48 trials.\n\nPress any key to continue.'];
    DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
    Screen(S.Window,'Flip');
    pause;
    
    Priority(0);
    cd(thePath)
    
end


