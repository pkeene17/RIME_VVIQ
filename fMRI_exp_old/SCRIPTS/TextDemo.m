function TextDemo
% TextDemo uses Screen to display text in various sizes, fonts, and styles.
% See also ScreenDemo, MovieDemo, ScreenTest.

% To demonstrate the current (2/24/02) buglet in Screen DrawText, try TextTest.

% 4/24/94 dhb  Wrote it.
% 5/7/96  dhb  Convert calling from SCRTEXT to Screen.
% 5/16/96 dhb  New calling sequence, GetClicks.
% 2/1/97  dhb  Clearer user instructions and fancy flashing message.
% 2/4/97  dhb  Folded in Pelli's text tests so that there is just
%              one TestText script.
% 2/23/97 dhb  Update for version 2 calling.
%	3/5/97	dgp  Update for reversed order of [fontName,fontNumber] returned args.
%	3/9/97	dgp  Added some really big text. Simplified a bit.
%	3/15/97	dgp  Cosmetic.
%	6/7/97	dgp  Cosmetic.
%	7/19/97	dgp  Make colors independent of pixelSize.
%	4/1/99	dgp  Call SORT on cells only if version>5.
%   6/20/01 awi  made the following changes to make TextDemo run on Windows version of the Psychtoolbox
%                - changed Screen text function calls to accept a pointer to a psychtoolbox window, 
%                  not the Matlab command window.  The Windows version of Screen does not recognize the 
%                  Matlab command window pointer as valid.
%                - removed call to Screen OpenOffscreenWindow which passed -1 as screen number.  This
%                  argument value is not yet supported in the Windows version of Screen
%                - added line to fill the background to white for Windows.
%                - changed font names from Mac fonts to Windows fonts.  
%                - changed fonts coordinates because Windows and Mac interpret fonts coordinates differently.  
%                - an updated release of Screen accompanies this version of TextDemo.
%  6/26/01 awi   made the following changes to unify OS9 and Windows versions of TextDemo and to accomodate
%                recent changes to Windows Screen
%                - removed call to Screen 'FillRect' which filled the window background because Screen 
%                  'OpenWindow' now correctly initializes the background.
%                - added platform conditional for fonts.  
%                - Reverted to text coordinates used for Mac because now positioning rules for Screen
%                  'DrawText' are the same for PC as for Mac.
%                - The function definition line had been inadvertently commented out on 6/20/01; 
%                  it has been restored.
%                - an updated version of Screen accompanies this release of TextDemo.
% 2/24/02 dgp	Work around bug: don't ask for newY return value when calling Screen DrawText. 
% 2/24/02 dgp	Print more font names.
% 4/04/02 awi   Made two changes to the loop that reads and stores font names for listing in the command window.  
%               - When testing for a font name "if length(font)>0" replaces "if length(font)>1" because the latter
%                 would fail to detect fonts with names one character long.  
%               - Testing for 10000 fonts under Windows takes a while, giving the false impression that the script has 
%                 hung or crashed. We now open a large window and display a message saying that it could take some time.   
%  9/27/04 dgp	Increase tenfold the range of the font scan, to try to get them all. Filter the resulting 
% 				list through UNIQUE, to eliminate duplicates.

% Open window
window = Screen(0,'OpenWindow');
ShowCursor(0);	% arrow cursor
HideCursor;
white=WhiteIndex(window);
black=BlackIndex(window);
gray=(white+black)/2;

% Choose fonts likely to be installed on this platform

        serifFont = 'Bookman';
        sansSerifFont = 'Arial'; % or Helvetica
        symbolFont = 'Symbol';
        displayFont = 'Impact';


           
% Draw text in various ways
r=Screen(window,'Rect');
Screen(window,'TextSize',24);
Screen(window,'TextFont',serifFont);
Screen(window,'DrawText','Hello world',100,100,black);
Screen(window,'TextSize',48);
Screen(window,'DrawText','Some dimmer bigger text',100,150,gray);
Screen(window,'TextSize',24);
Screen(window,'TextStyle',4);
Screen(window,'DrawText','This is underlined!!!',100,200,black);
Screen(window,'DrawText',' So''s this.',[],[],black);
Screen(window,'TextStyle',0);
Screen(window,'TextFont',displayFont); 
Screen(window,'TextSize',18);
Screen(window,'DrawText','Would you believe, symbols?',100,250,black);
Screen(window,'TextFont',symbolFont);
Screen(window,'DrawText','  displayed as symbols',[],[],black);
Screen(window,'TextFont',displayFont);
Screen(window,'TextSize',12);
Screen(window,'DrawText',[Screen(window,'TextFont') ' 12 pt'],100,300,black);
Screen(window,'TextFont',sansSerifFont);
Screen(window,'TextSize',36);
oldMode=Screen(window,'TextMode','srcOr');
Screen(window,'DrawText','Combined by ORing: XOXOXO',100,350,gray);
Screen(window,'DrawText','Combined by ORing: OXOXOX',100,350,(gray+black)/2);
Screen(window,'TextMode',oldMode);
Screen(window,'TextSize',60);
r=Screen(window,'Rect');
Screen(window,'DrawText','Click mouse to proceed',20,r(RectBottom)-20,black);
GetClicks;

% Erase by redrawing
Screen(window,'DrawText','Click mouse to proceed',20,r(RectBottom)-20,white);
Screen(window,'FillRect');

% Say goodbye
fontSize=Screen(window,'TextSize',400); % save font size and set new size
r=Screen(window,'Rect');
Screen(window,'DrawText','Bye!',10,r(RectBottom)-150,black);
Screen(window,'TextSize',fontSize);	% restore font size
Screen(window,'DrawText','Click mouse to proceed.',20,r(RectBottom)-20,black);
GetClicks;

% Close window
ShowCursor;
Screen(window,'Close');

% Test text functions that return information
window=Screen(0,'OpenWindow'); % open window
width=Screen(window,'TextWidth','Click mouse to get font info');
textFont=Screen(window,'TextFont');
textSize=Screen(window,'TextSize');
textStyle=Screen(window,'TextStyle');
textMode=Screen(window,'TextMode');
fprintf('Current text font %s, size %d, style %d, mode %d\n\n',textFont,textSize,textStyle,textMode);

% Warn the user that this could take a while
Screen(window,'TextSize',24);
Screen(window,'TextFont',serifFont);
Screen(window,'DrawText','Reading font names. This could take a while ...',50,50,black);

% Make list of fonts
oldFont=Screen(window,'TextFont');
list={};
for i=2:100000
	font=Screen(window,'TextFont',i);
	if length(font)>0
		list=cat(1,list,{font});
    end
end
list=unique(list);
Screen(window,'TextFont',oldFont);
fprintf('Available fonts include these %d:\n\n',length(list));
for i=1:length(list)
	fprintf('%s\n',list{i});
end

% Close window
Screen(window,'Close');


