function RIME_fMRI_makecsv_new(subjects,data_dir)
% including sure_dprime & vividness response consistency

% posttest results
PTFile = fopen([data_dir '/new/RIME_behavior_PT.csv'], 'w');
fprintf(PTFile,'SN,retcond,category,accuracy,accuracy_sure,hit,sure_hit,FA,sure_FA,CR,Miss,hit_FA,sure_hit_FA,dprime,dprime_sure\n'); %%%%
% 

% vividness consistency results
cnstFile = fopen([data_dir '/new/RIME_behavior_vividconsistency.csv'], 'w');
% fprintf(cnstFile,'SN,Study_R1,Study_R2,R1_R2,Study_R1_highlow,Study_R2_highlow,R1_R2_highlow\n');
fprintf(cnstFile,'SN,condition,percentage\n');

% vividness-PT relationship results
vivPTFile = fopen([data_dir '/new/RIME_behavior_vividPT.csv'], 'w');
fprintf(vivPTFile,'SN,response,Study_accuracy,Study_accuracy_sure,Study_hit_FA,Study_dprime,Study_dprime_sure,'); %%%
fprintf(vivPTFile,'Study_hit,Study_sure_hit,Study_FA,Study_sure_FA,Study_CR,Study_miss,R1_accuracy,R1_accuracy_sure,');
fprintf(vivPTFile,'R1_hit_FA,R1_dprime,R1_dprime_sure,R1_hit,R1_sure_hit,R1_FA,R1_sure_FA,R1_CR,R1_miss,'); %%%
fprintf(vivPTFile,'R2_accuracy,R2_accuracy_sure,R2_hit_FA,R2_dprime,R2_dprime_sure,R2_hit,R2_sure_hit,R2_FA,R2_sure_FA,R2_CR,R2_miss\n'); %%%


retcond_name = {'No_retrieval','Retrieval'};
category_name = {'Face','Scene','Object'};
vivcond_name = { 'S_R1','S_R2','R1_R2', 'S_R1_highlow','S_R2_highlow','R1_R2_highlow'};

%%
for i = 1:length(subjects)
    
   sub = subjects(i);
   if sub < 10
       subj_dir = ['0' num2str(sub)];
   else
       subj_dir = num2str(sub);
   end
   
   load(fullfile(data_dir,subj_dir,'DATA.mat'));
   %1=SN 2=stimcbal 3=category 4=ret/noret 5=identical/similar 6=wordID
   %7=imageID 8=image1/2 9=PTblock 10=PTtrial 11=PTRT 12=PTresp 13=old/new
   %14=sure/unsure 15=hit/FA/CR/miss 16=accuracy 17=accuracy_sure
   %18=studyblock 19=studytrial 20=vividtrial 21=vividresp 22=vividRT
   %23=R1trial 24=R1resp 25=R1RT 26=R2trial 27=R2resp 28=R2RT

   %% final test
   %fprintf(PTFile,'SN,retcond,category,accuracy,accuracy_sure,hit,sure_hit,FA,sure_FA,CR,Miss,hit_FA,dprime,dprime_sure\n');

   % all (including novel lures) 
   fprintf(PTFile,'%2d,All,All,',sub); 
   [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d, sured] =PT_analysis(DATA);
   fprintf(PTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f\n',...
       acc,sureacc,hit,surehit,FA,sureFA,CR,Miss,hit-FA,surehit-sureFA,d,sured);
   
   % ret/noret
   for retcond = 1:-1:0
       fprintf(PTFile,'%2d,%s,All,',sub,retcond_name{retcond+1});
       
       thisdata = DATA(DATA(:,4)==retcond,:);
       [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d, sured] =PT_analysis(thisdata);
       
       fprintf(PTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f\n',...
           acc,sureacc,hit,surehit,FA,sureFA,CR,Miss,hit-FA,surehit-sureFA,d,sured);  
   end
   
   % category (including novel lures)
  for category = 1:3
       fprintf(PTFile,'%2d,All,%s,',sub,category_name{category});
       
       thisdata = DATA(DATA(:,3)==category,:);
       [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d, sured] =PT_analysis(thisdata);
       
       fprintf(PTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f\n',...
           acc,sureacc,hit,surehit,FA,sureFA,CR,Miss,hit-FA,surehit-sureFA,d,sured);  
   end
   
   
   % ret/noret & category
   for category = 1:3
       
       for retcond = 1:-1:0
           
           fprintf(PTFile,'%2d,%s,%s,',sub,retcond_name{retcond+1},category_name{category});
           
           thisdata = DATA(DATA(:,3)==category & DATA(:,4) == retcond,:);
           [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d, sured] =PT_analysis(thisdata);
           
           fprintf(PTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f\n',...
               acc,sureacc,hit,surehit,FA,sureFA,CR,Miss,hit-FA,surehit-sureFA,d,sured);
       end
   end
   
   %% vividness response consistency
   
   %1=SN 2=stimcbal 3=category 4=ret/noret 5=identical/similar 6=wordID
   %7=imageID 8=image1/2 9=PTblock 10=PTtrial 11=PTRT 12=PTresp 13=old/new
   %14=sure/unsure 15=hit/FA/CR/miss 16=accuracy 17=accuracy_sure
   %18=studyblock 19=studytrial 20=vividtrial 21=vividresp 22=vividRT
   %23=R1trial 24=R1resp 25=R1RT 26=R2trial 27=R2resp 28=R2RT
   
    % fprintf(cnstFile,'SN,Study_R1,Study_R2,R1_R2,Study_R1_highlow,Study_R2_highlow,R1_R2_highlow\n');
    vividDATA = DATA(DATA(:,4)==1,:);
    vivid_hl = vividDATA(:,[21 24 27]);
    vivid_hl(vivid_hl(:)==1 | vivid_hl(:)==2) = 1; 
    vivid_hl(vivid_hl(:)==3 | vivid_hl(:)==4) = 2;

    S_R1 = 100*numel(vividDATA(vividDATA(:,21)~=0 & vividDATA(:,24)~= 0 & (vividDATA(:,21)==vividDATA(:,24)),24))/size(vividDATA,1);
    S_R2 = 100*numel(vividDATA(vividDATA(:,21)~=0 & vividDATA(:,27)~= 0 & (vividDATA(:,21)==vividDATA(:,27)),27))/size(vividDATA,1);  
    R1_R2 = 100*numel(vividDATA(vividDATA(:,24)~=0 & vividDATA(:,27)~= 0 & (vividDATA(:,24)==vividDATA(:,27)),27))/size(vividDATA,1);
    
    S_R1_hl = 100*numel(vivid_hl(vivid_hl(:,1)~=0 & vivid_hl(:,2)~= 0 &(vivid_hl(:,1)==vivid_hl(:,2)),1))/size(vivid_hl,1);
    S_R2_hl = 100*numel(vivid_hl(vivid_hl(:,1)~=0 & vivid_hl(:,3)~= 0 &(vivid_hl(:,1)==vivid_hl(:,3)),1))/size(vivid_hl,1);
    R1_R2_hl = 100*numel(vivid_hl(vivid_hl(:,2)~=0 & vivid_hl(:,3)~= 0 &(vivid_hl(:,2)==vivid_hl(:,3)),1))/size(vivid_hl,1);
    
    viv_values = [S_R1 S_R2 R1_R2 S_R1_hl S_R2_hl R1_R2_hl];
    
    for cond = 1:numel(vivcond_name)
        fprintf(cnstFile,'%2d,%s,%4.4f\n',sub,vivcond_name{cond},viv_values(cond));
    end
%     fprintf(cnstFile,'%2d,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f\n',sub,S_R1,S_R2,R1_R2,S_R1_hl,S_R2_hl,R1_R2_hl);

    
   %% vividness-PR relationship
    % fprintf(vivPTFile,'SN,response,Study_accuracy,Study_accuracy_sure,Study_hit_FA,Study_dprime,');
    % fprintf(vivPTFile,'Study_hit,Study_sure_hit,Study_FA,Study_sure_FA,Study_CR,Study_miss,R1_accuracy,R1_accuracy_sure,');
    % fprintf(vivPTFile,'R1_hit_FA,R1_dprime,R1_hit,R1_sure_hit,R1_FA,R1_sure_FA,R1_CR,R1_miss,');
    % fprintf(vivPTFile,'R2_accuracy,R2_accuracy_sure,R2_hit_FA,R2_dprime,R2_hit,R2_sure_hit,R2_FA,R2_sure_FA,R2_CR,R2_miss\n');
   
%     for resp = 1:4
% 
%         fprintf(vivPTFile,'%2d,%d,',sub,resp);
%         
%         studydata = vividDATA(vividDATA(:,21)==resp,:);
%         %%
%         [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d, sured] =PT_analysis(studydata);
%         %%
%         fprintf(vivPTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,',...
%                acc,sureacc,hit-FA,d,sured, hit,surehit,FA,sureFA,CR,Miss);        
%     
%         R1data = vividDATA(vividDATA(:,24)==resp,:);
%         [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d,sured] =PT_analysis(R1data);
%         fprintf(vivPTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,',...
%                acc,sureacc,hit-FA,d, sured,hit,surehit,FA,sureFA,CR,Miss);        
% 
%          R2data = vividDATA(vividDATA(:,27)==resp,:);
%         [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d, sured]  =PT_analysis(R2data);
%         fprintf(vivPTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f\n',...
%                acc,sureacc,hit-FA,d,sured, hit,surehit,FA,sureFA,CR,Miss);       
%     end
    
    for resp = [2, 4]
        
        if resp == 2
            fprintf(vivPTFile,'%2d,low,',sub);
        else
            fprintf(vivPTFile,'%2d,high,',sub);
        end
        
        studydata = vividDATA(vividDATA(:,21)==resp | vividDATA(:,21)==resp-1,:);
        [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d , sured] =PT_analysis(studydata);
        fprintf(vivPTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,',...
               acc,sureacc,hit-FA,d, sured,hit,surehit,FA,sureFA,CR,Miss);  
    
        R1data = vividDATA(vividDATA(:,24)==resp  | vividDATA(:,24)==resp-1,:);
        [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d , sured] =PT_analysis(R1data);
        fprintf(vivPTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,',...
               acc,sureacc,hit-FA,d,sured, hit,surehit,FA,sureFA,CR,Miss);       

         R2data = vividDATA(vividDATA(:,27)==resp | vividDATA(:,27)==resp-1,:);
        [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d, sured] =PT_analysis(R2data);
        fprintf(vivPTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f\n',...
               acc,sureacc,hit-FA,d, sured,hit,surehit,FA,sureFA,CR,Miss);          
               
    end
    
    % add no retrieval condition for comparison
    noretdata = DATA(DATA(:,4)==0,:);
    [acc, sureacc, hit, surehit, FA, sureFA, CR, Miss, d, sured] =PT_analysis(noretdata);
    
    fprintf(vivPTFile,'%2d,No_retrieval,',sub);
    for iter = 1:3
    fprintf(vivPTFile,'%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,%4.4f,',...
           acc,sureacc,hit-FA,d, sured, hit,surehit,FA,sureFA,CR,Miss);   
    end
    fprintf(vivPTFile,'\n');
    
    
    
   clear DATA vividDATA 
   
end

end

function [acc,sureacc,hit,surehit,FA,sureFA,CR,Miss,d, sured] = PT_analysis(DATA)
   
     %1=SN 2=stimcbal 3=category 4=ret/noret 5=identical/similar 6=wordID
   %7=imageID 8=image1/2 9=PTblock 10=PTtrial 11=PTRT 12=PTresp 13=old/new
   %14=sure/unsure 15=hit/FA/CR/miss 16=accuracy 17=accuracy_sure
   %18=studyblock 19=studytrial 20=vividtrial 21=vividresp 22=vividRT
   %23=R1trial 24=R1resp 25=R1RT 26=R2trial 27=R2resp 28=R2RT
   
   DATA = DATA(DATA(:,12)~=0,:);

   acc = 100*numel(DATA(DATA(:,16)==1,16))/size(DATA,1);% overall accuracy
   sureacc = 100*numel(DATA(DATA(:,17)==1,17))/size(DATA,1); % overall accuracy (unsure=incorrect)
   hit = numel(DATA(DATA(:,15)==1,15))/numel(DATA(DATA(:,5)==1,5)); % hit
   surehit = numel(DATA(DATA(:,15)==1 & DATA(:,14)==1,15))/numel(DATA(DATA(:,5)==1,5)); % sure hit
   FA = numel(DATA(DATA(:,15)==2,15))/numel(DATA(DATA(:,5)~=1,5)); % false alarm
   sureFA = numel(DATA(DATA(:,15)==2 & DATA(:,14)==1,15))/numel(DATA(DATA(:,5)~=1,5)); % sure false alarm
   CR = numel(DATA(DATA(:,15)==3,15))/numel(DATA(DATA(:,5)~=1,5)); % correct rejection
   Miss = numel(DATA(DATA(:,15)==4,15))/numel(DATA(DATA(:,5)==1,5)); % miss
   [d,~,~] = dprime(hit,FA,numel(DATA(DATA(:,5)==1,5)),numel(DATA(DATA(:,5)~=1,5)));
   [sured,~,~] = dprime(surehit,sureFA,numel(DATA(DATA(:,5)==1,5)),numel(DATA(DATA(:,5)~=1,5)));
   

end

function [dPrime, betaRatio, criterion] = dprime(Hit_rate,FA_rate,hitN, FAN)
% get d prime, beta (ratio), criterion c from hit rate and false alarm rate 
% hitN = maximum number of hit trials
% FAN = maximum number of FA trials
% if hit or false alarm rate is 0 or 1, use 1/2N or 1-1/2N

if Hit_rate == 0 
    Hit_rate = 1/(2*hitN);
elseif Hit_rate == 1
    Hit_rate = 1-(1/(2*hitN));
end

if FA_rate == 0 
    FA_rate = 1/(2*FAN);
elseif FA_rate == 1
    FA_rate = 1-(1/(2*FAN));
end

dPrime    = norminv(Hit_rate,0,1) - norminv(FA_rate,0,1);
betaRatio = exp(-1*dPrime*0.5*(norminv(Hit_rate,0,1) + norminv(FA_rate,0,1)));
criterion = -1*0.5*(norminv(Hit_rate,0,1) + norminv(FA_rate,0,1));

end
