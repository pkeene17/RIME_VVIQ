%% calls export_mats in a loop
function run_export_mats(nsubj)

for i=1:nsubj
    if i~=18
        if i<10
            subj=strcat('0',int2str(i));
        else
            subj=int2str(i);
        end
        export_mats(subj)
    end
end