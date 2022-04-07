function RIME_fMRIrun(thePath)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is edited by FRR (and RS!) and based on the REIrun script.
% For the current experiment we have 25 Blocks that are scanned with fMRI.
% Each block contains:
% - two study rounds (identical to each other) in which they learn word- picutre associations
% - a vividness rating phase in which they are shown the word only and indicate how vividly they recall the image.
% This is followed by a memory test outside the scanner.
%
% Edits (to be) made
% - need to change the file names/variable names used here
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars -EXCEPT thePath


if nargin == 0
    error('Must specify thePath')
end

KbName('UnifyKeyNames');


% WAB: Might wanna take this out, just makes the matlab screen stuff work
% PK: edited to work on new ios versions
Screen('Preference', 'SkipSyncTests', 1);
if IsOSX
     Screen('Preference','TextRenderer', 0)
end

%% Take some inputs and specify some variables
sName = input('Enter date as string (using single quotes): ');
sNum =  input('Enter subject number: ');
expPhase = input('P, S1, S2, V, R1, R2, PT? ','s');
dbgn = input('Debugging? (1 for debugging, 0 for not): ');

if strcmp(expPhase,'S1')
    block = input('Enter start block number: ');
    %startTrial = input('Enter start trial number: ');
elseif strcmp(expPhase,'S2')
    block = input('Enter start block number: ');
elseif strcmp(expPhase,'V')
    block = input('Enter start block number: ');
elseif strcmp(expPhase,'R1')                            % added for first retrieval phase RS 4/7/15
    block = input('Enter start block number: ');
    startTrial = input('Enter start trial number: ');
elseif strcmp(expPhase,'R2')                            % added for second retrieval phase RS 4/7/15
    block = input('Enter start block number: ');
    startTrial = input('Enter start trial number: ');
elseif strcmp(expPhase,'PT')
    block = input('Enter start block number: ');
    startTrial = input('Enter start trial number: ');
elseif strcmp(expPhase,'P')
end

% S.scanner = 0; We shouldn't need this?
S.YadjustmentFactor =  0; %input('Enter adjustment factor (e.g., -98): ');
S.scanner = input('In scanner [1] or behavioral [2] ? ');
S.OS = 'mac'; % input('mac or pc? ','s');

if strcmp(S.OS,'mac')
    % Set input device (keyboard or buttonbox)
    if S.scanner == 1
        S.boxNum = -1;  % buttonbox
        S.kbNum = -1; % keyboard
    else % Behavioral
        S.boxNum = -1;  % buttonbox
        S.kbNum = -1; % keyboard
    end
else
    S.boxNum = 0;
    S.kbNum = 0;
end

%% Specify some screen commands
% S is a variable that gets passed to the scripts for each phase
S.triggerKey    = KbName('''"');     % key to start scanner
S.quitKey       = KbName('q');        % key to abort
S.continueKey   = KbName('c');    % key to continue to the next block

if S.scanner==1
    S.screenNumber = 0;
else
    S.screenNumber = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hongmi: changed the
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% colorsq
S.screenColor = 128;
S.textColor = 0;  
S.endtextColor = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S.cueTextSize = 32;  % the size of the font that the cue word appears.  It's
% also the size that the messages (e.g., 'get ready' will appear in)
S.imageNameTextSize = 20; % size of the font for the label underneath each image
S.numTextSize = 50;
S.font = 'Arial';
S.labelTextSize = 26; %size of the new/old box labels in the PT

%[S.Window, S.myRect] = Screen(S.screenNumber, 'OpenWindow', S.screenColor,[], 32); replaced with below from Hongmi RS 4/8/15

if dbgn == 1
    [S.Window, S.myRect] = Screen(S.screenNumber, 'OpenWindow', S.screenColor, [0 0 1024 768], 32);
else
    [S.Window, S.myRect] = Screen(S.screenNumber, 'OpenWindow', S.screenColor, [], 32);
end

Screen('TextSize', S.Window, 24);
Screen('TextStyle', S.Window, 1);
S.on = 1;  % Screen now on

%% Start appropriate phase

if (strcmp(expPhase,'S1'))
    for scanningrun = 1:8
        study.theData = RIME_fMRI_studyvivid(thePath,sNum,S,scanningrun,sName);
    end
% elseif (strcmp(expPhase,'S2'))
%     while block < 17
%         study2Name = ['RIME_fMRI_sub' num2str(sNum) '_' sName  '_Study2'];
%         %study2.theData = fMRIclass_v2_studyS2(thePath,sNum,S,block,study2Name,dbgn);
%         block = block +1;
%     end
% elseif strcmp(expPhase,'V') % vividness test
%         if block<10 %makes sure I save each block separately, I repeat this here in case I want to run V seperatly
%             BLK = ['block0' num2str(block)];
%         else
%             BLK = ['block' num2str(block)];
%         end
%         corename =    ['RIME_fMRI_sub' num2str(sNum) '_' BLK   '_' sName ];
%         study1Name  = [corename '_Study1'];
%         study2Name  = [corename '_Study2'];
%         vividName   = [corename '_Vivid'];
%         study.theData = RIME_fMRI(thePath,sNum,S,block,vividName,dbgn); %delete the 2 later %might  now work becuse I am missing stuff here
elseif strcmp(expPhase,'R1')    %added to start first extra retrieval phase RS 4/7/15
        %while block < 2 % only one block as self paced anyways
        corename    =    ['RIME_fMRI_sub' num2str(sNum) '_'   sName ];
        R1Name      = [corename '_R1.mat']; 
        study.theData = RIME_fMRI_R1(thePath,sNum,S,R1Name,block);
elseif strcmp(expPhase,'R2')    %added to start second extra retrieval phase RS 4/7/15
        %while block < 2 % only one block as self paced anyways
        corename    =    ['RIME_fMRI_sub' num2str(sNum) '_'   sName ];
        R2Name      = [corename '_R2.mat'];
        study.theData = RIME_fMRI_R2(thePath,sNum,S,R2Name,block);
elseif strcmp(expPhase,'PT')
        %while block < 2 % only one block as self paced anyways
        corename    =    ['RIME_fMRI_sub' num2str(sNum) '_'   sName ];
        PTName      = [corename '_PT.mat'];
        study.theData = RIME_fMRI_PT(thePath,sNum,S,PTName,startTrial,dbgn);
        % block = block +1;
        % end
elseif strcmp(expPhase,'P')
    RIME_fMRI_Prac(thePath,sNum,S,dbgn);
end

%% End
message = 'End of script. \n\n Press any key to exit.';

DrawFormattedText(S.Window,message,'center','center',S.endtextColor);
Screen(S.Window,'Flip');
pause; % pause until user response
clear screen;
end

