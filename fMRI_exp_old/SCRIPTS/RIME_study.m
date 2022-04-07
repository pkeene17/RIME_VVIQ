% RIME_study
% Study rounds to be included in RIME_fMRI_studyvivid.m

% get ready screen
message = ['Memorize word-picture pairs.\n\n Block #' num2str(block), ' of 16 '];
DrawFormattedText(S.Window,message,'center','center',S.textColor);  % used to say 'center','center' %FRR changed ycenter to 'center'
Screen(S.Window,'Flip');

goTime = goTime + instrScrTime;
recordKeys(startTime,goTime,S.kbNum);

% show fixation
goTime = goTime + startFixTime;
Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]);
Screen(S.Window,'Flip');

recordKeys(startTime,goTime,S.kbNum);


for Trial = 1:Study1Length
    if (theData.Study1.miniblock{Trial}==block) %FRR add study 1
        
        goTime = goTime + wordtime; % changed from >>goTime = goTime + stimTime; <<  by FRR
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Present word + Picture
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Draw the word
        Screen('TextSize', S.Window, S.cueTextSize);% text size is specified within the loop because it's
        % a different size for the cue and the image name (it alternates within each trial)
        word = theData.Study1.word{Trial}(3:end); %FRR add Study1
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % was -180 ycenter before; changed 100809 % FRR changed ycenter to 'center'
        % make white box to frame image?
        
        %---added by FRR to seperate presentation of word and pic---%
        % Flip (word only)
        Screen(S.Window,'Flip');
        
        % recording trial onsets
        wordonset = GetSecs-startTime;
        theData.Study1.onset(Trial) = wordonset;
        recordKeys(startTime,goTime,S.kbNum);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Draw the image
        goTime = goTime + pictime; % added for pic only by FRR
%         destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
%         Screen('DrawTexture',S.Window,imgPtrs(Trial),[],destRect);
        Screen('DrawTexture',S.Window,imgPtrs(Trial));

        % Flip (pic only)
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% added here by RS for fMRI version
        %         %ODD/EVEN TASK
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        blockTrial = mod(Trial,12);
        if blockTrial==0
            blockTrial=12;
        end
        
        %       First a fixation cross
        goTime = goTime + oddevenFix;
        Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
            0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
        
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        
        for repeats = 1:oddevenrepeats
            %Present the number
            goTime = goTime + oddevenTime;
            numarray = [1:8];
            ii = Shuffle(numarray);
            num = num2str(ii(1));
            
            % Record the number presented
            theData.Study1.numberpresented{blockTrial,repeats}= num;
            % Record if number is odd or even (even = 0, odd = 1)
            theData.Study1.oddeven{blockTrial,repeats} = mod(num,2);
            % theData.Test.numberpresentedExpTrial{Trial,repeats}= num;
            % theData.Test.oddevenExpTrial{Trial,repeats} = mod(num,2);
            numberpresented{blockTrial,repeats}= num;   % this is needed when I am appending the file that saves across blocks
            oddeven{blockTrial,repeats} = mod(num,2);
            
            Screen('TextSize', S.Window, S.numTextSize);
            DrawFormattedText(S.Window,num,'center',ycenter-30,S.textColor);
            Screen(S.Window,'Flip');
            
            %Collect odd/even repsonse
            upTime = GetSecs;
            oddevenkey = 0;
            oddeventime = 0;
            while 1
                [keyDown, secs, keyCodes] = KbCheck(-1);
                %keyDown
                if keyDown
                    if keyCodes(oddkey)
                        oddevenkey = 1;
                        oddeventime = secs - upTime;
                    elseif keyCodes(evenkey)
                        oddevenkey = 2;
                        oddeventime = secs - upTime;
                    elseif keyCodes(S.quitKey)
                        fclose(fp); sca; return;
                    end
                    
                end
                if GetSecs-startTime > goTime
                    break;
                end
            end
            
            %Record odd/even responses
            %            theData.Test.oddevenresponseExpTrial{Trial,repeats} = oddevenkey;
            %            theData.Test.oddevenRTExpTrial{Trial,repeats} = oddeventime;
            theData.Study1.oddevenresponse{blockTrial,repeats} = oddevenkey;
            theData.Study1.oddevenRT{blockTrial,repeats} = oddeventime;
            %             oddevenresponse{blockTrial,repeats} = oddevenkey;   % this is needed when I am appending the file that saves across blocks
            %             oddevenRT{blockTrial,repeats} = oddeventime;        % this is needed when I am appending the file that saves across blocks
            
            if repeats<oddevenrepeats
                %Fixation in between numbers
                goTime = goTime + oddevenBetween;
                Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
                    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
                
                Screen(S.Window,'Flip');
                recordKeys(startTime,goTime,S.kbNum);
            end
            
            % Hongmi_new: printing out responses
            fprintf('block: %2d, trial: %2d, repeats: %d, wordonset: %4.4f, resp: %d, RT: %4.4f\n',...
                block,Trial,repeats,wordonset,oddevenkey,oddeventime);
            
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Present null (fixation)
        goTime = goTime + fixTime;
        Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
            0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        
        
        eval(['save ' studyDir '/' study1NameBlock '.mat theData theList'])
%         eval(['save ' studyDir '/' study1NameBlock '_study.mat'])
        
        %--------------------------
        % at the end save the file for all blocks
        if Trial == Study1Length
            study1Name_all =[study1Name(1:15) study1Name(end-12:end)];
            matName = [study1Name_all '_study.mat'];
            cmd = ['save ' matName];
            eval(cmd);
        end
        
    end
end % end of 'for Trial = 1:listLength' loop