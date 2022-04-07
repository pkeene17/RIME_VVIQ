% makes a variable called stims that has the fields of faces, scenes,
% objects, and cues.  Each of those fields has a randomized array of stim 
% ID's (e.g., face13, cue130, etc).  The stimID's refer to the same images/words,
% across subjects (i.e., face13 is always the same person for every
% subject).  But the order of those stimID's is randomized for each subject
% so that the same images don't always appear in the same conditions.
% There's another script that calls the stims variable and it just
% sequentially assigns each stimID in the array to a set of conditions.
% That assignment procedure is not randomized for each subject, which is
% why the arrays here need to be randomized.  This script should also be
% run just once.  That's very important, otherwise you would overwrite the
% existing stims variable.  So, just for the sake of having a permanent
% record, I don't have this script called by anything else.  In other
% words, I'll run it once, save the stims variable and that's that.

subNum = 40; %total number of subjects


%How many unique items from each category are neccesary for the experiment
faceNum = 100;
sceneNum = 100;
objectNum = 100;
wordNum = 300;

%Create random order for each category
faces = shuffle(linspace(1,faceNum,faceNum));
scenes = shuffle(linspace(1,sceneNum,sceneNum));
objects = shuffle(linspace(1,objectNum,objectNum));
words = linspace(1,wordNum,wordNum); %words were hand selected into groups of 12 so we do not want to shuffle them here. We will shuffle within the group of 12 in the list generator script

for subject = 1:subNum
    f = []; % temporary holder for faces
    s = []; % scenes
    o = []; % objects
    w = []; % words
    for a = 1:faceNum
        randselection = faces(a);
        f = [f {['face' num2str(randselection)]}];
    end
    for b = 1:sceneNum
        randselection = scenes(b);
        s = [s {['scene' num2str(randselection)]}];
    end
    for c = 1:objectNum
        randselection = objects(c);
        o = [o {['object' num2str(randselection)]}];
    end
    for d = 1:wordNum
        randselection = words(d);
        w = [w {['word' num2str(randselection)]}];
    end
    stimIDs.faces{subject} = shuffle(f);
    stimIDs.scenes{subject} = shuffle(s);
    stimIDs.objects{subject} = shuffle(o);
    stimIDs.words{subject} = w;
end

save stimIDs stimIDs
            