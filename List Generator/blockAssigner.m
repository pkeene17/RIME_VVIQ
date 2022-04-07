function [ list ] = blockAssigner( list, numblocks, trialsperblock, blockrow)
%This function runs through the number of trails for each block (as
%specified in the input trialsperblock) for as many blocks are in the study
%phase (as specificed in the input numblocks) and assigns each trial the
%corresponding block number. The output is the list of conditions in the
%input with an extra row (the row number is specified by the input blockrow)
%containing  the block number. 


for block = 1:numblocks
    starttrial = trialsperblock*(block-1)+1;
    lasttrial = starttrial+trialsperblock-1;
    for trial = starttrial:lasttrial
        list{blockrow,trial} = block;
    end

end

