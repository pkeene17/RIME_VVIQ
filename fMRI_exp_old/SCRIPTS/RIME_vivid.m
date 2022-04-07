% RIME_vivid
% vividness rounds to be included in RIME_fMRI_studyvivid.m


% get ready screen
goTime = goTime + instrScrTime;
Screen('TextSize', S.Window, S.cueTextSize);
message = 'PLEASE RESPOND: \n\n \n\n | 1 |------| 2 |------| 3 |------| 4 | \n\n least vivid    ---    most vivid';
DrawFormattedText(S.Window,message,'center','center',S.textColor); % used to say 'center','center' %FRR changed back from 'center',ycenter
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

% show fixation
goTime = goTime + startFixTime; %fixTime
Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
    0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
Screen(S.Window,'Flip');
recordKeys(startTime,goTime,S.kbNum);

for Trial = 1:VividLength
    if (theData.Vivid.miniblock{Trial}==block)
        
        goTime = goTime + vividStimTime;
        
        %% Present word (FRR commented out Picture )

        word = theData.Vivid.word{Trial}(3:end);
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness
        
        % Draw the box
        Screen('FrameRect', S.Window, black ,boxrect, boxwidth);

        % Flip
        Screen(S.Window,'Flip');
        
        % Hongmi_new: recording trial onsets
        cueonset = GetSecs-startTime;
        theData.Vivid.onset(Trial) = cueonset;
        
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
        
        % Draw word
        word = theData.Vivid.word{Trial}(3:end);
        DrawFormattedText(S.Window,word,'center','center',S.textColor);  % FRR changed -170 to  only 'center' as i want the word to be centered and there is no image any longer in the vividness
        
        % Draw box
        if vividkey == 0
            Screen('FrameRect', S.Window, red ,boxrect, boxwidth);
        else
            Screen('FrameRect', S.Window, black ,boxrect, boxwidth);
        end
        
        % Flip
        Screen(S.Window,'Flip');
        upTime = GetSecs;
        while 1
            [keyDown, secs, keyCodes] = KbCheck(-1); %checks for responses from all KBs
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
        blockTrial = mod(Trial,6);
        if blockTrial ==0
            blockTrial=6;
        end
        theData.Vivid.vividresponse_currblock{blockTrial,1} = vividkey; % FRR replaced repeats with 1 as we do not repeat the rating
        theData.Vivid.vividRT_currblock{blockTrial,1}       = vividtime;
        theData.Vivid.vividresponse{Trial,1}    = vividkey;     % this is needed when I am appending the file that saves across blocks
        theData.Vivid.vividRT{Trial,1}          = vividtime;
        
        % Hongmi_new: printing out responses
        fprintf('block: %2d, trial: %2d, cueonset: %4.4f, resp: %d, RT: %4.4f\n',...
            block,Trial,cueonset,vividkey,vividtime);
        
        recordKeys(startTime,goTime,S.kbNum); %FRR just waites
        
        
        % Present null (fixation)
        goTime = goTime + vividFixTime; % changed from fixTime to vividFixTime RS
        Screen('DrawLines',S.Window, [-fixlength/2 fixlength/2 0 0; ...
            0 0 -fixlength/2 fixlength/2], fixwidth, fixcol,[xcenter ycenter]); %%%%%%Hongmi: fixation
        Screen(S.Window,'Flip');
        recordKeys(startTime,goTime,S.kbNum);
        
        eval(['save ' vivDir '/' vividNameBlock '.mat theData theList'])
%         eval(['save ' vivDir '/' vividNameBlock '_study.mat'])
        
        
        
    end
end