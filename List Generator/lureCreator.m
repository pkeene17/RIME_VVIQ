function [ lurelist ] = lureCreator( numlures,targetitems, lureitems )
%UNTITLED2 Summary of this function goes here
%   This function intakes the number of lures (numLures) required for each trial, a list of target items, a  list of lure items. The length of the target item list and the lure item list must be identical. 
%It will output a matrix lurelist. The number of rows will correspond to
%the number of target items and the number of columns will correspond to
%the number of lures.  The first column of the output list will be the
%target items. The remaining columns will be a randomized order of the lure
%items with the constraint that no two lure items will repeat within a
%given target trial. 
% 


lurelist = {};
lurelist(:,1) = targetitems'; %make the first column of the ouput list a list of the target items

for column = 2:numlures+1 %creates a column for each lure 
satisfied = 0;
repeat = 0; %checks to see if there are any repeat lures within a given trial
while satisfied == 0 %if there are any repeats within a trial this will not be satisfied 
  lurelist(:,column) = shuffle(lureitems);
  for columncheck = 1:column-1 %goes through every column to check if there are any repeats
   for item = 1:length(lurelist)
      if strcmp(lurelist(item,column),lurelist(item,columncheck)) == 1 %checks to make that the same image is not presented within the same final test round
           repeat = repeat + 1;
      end
   end
  end
  if repeat > 0
      satisfied = 0;
      repeat = 0;
  elseif repeat == 0;
      satisfied = 1;
      repeat = 0;
  end
end

end

end
