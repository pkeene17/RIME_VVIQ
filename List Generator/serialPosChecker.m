function [ check ] = serialPosChecker(list,conditions,stdev)
   %FRR this makes sure that no one condition is randomly first a lot of
   %times. So this continues until a reasonable number (low variance) is reached 

for con = 1:length(conditions)
    avgPos(con) = mean(find(strcmp(conditions{con},list)));
end

sd = nanstd(avgPos); %FRR change from std, as we do not have values for the lures


if sd<stdev
    check = 1;
else
    check = 0;
end

end

