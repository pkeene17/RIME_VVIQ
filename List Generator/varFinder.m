function factors = varFinder(vector)

% This script takes in a vector of strings, finds all the 
% unique strings in it and then creates a structure with subfields named
% after each of the unique strings and each subfield representing a vector
% of all occurrences (serial positions) of that string in the original
% vector.  For ecample: vector = {'cona' 'conb' 'cona'} would become 
% factors.cona = [1 3], factors.conb = [2]


% first get all the unique names
names = unique(vector);

% for each name, get the serial positions
for name = 1:length(names)
    indices{name} = find(strcmp(vector, names(name)));
end

% create structure with a field for each factor
factors = cell2struct(indices,names,2);

end
