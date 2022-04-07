#script to analyze RIME_VVIQ data

library(tidyverse)
library(here)
library(R.matlab)
library(reticulate)
library(ggpubr)
library(rstatix)

#define some helpers
resp_labelsR <- function(resp)
{
  ret <- 0
  if(resp==0){
    ret <- "nan"
  }
  if(resp==1){
    ret <- "forgot"
  }
  if(resp==2){
    ret <- "gist"
  }
  if(resp==3){
    ret <- "mod. vivid"
  }
  if(resp==4){
    ret <- "v. vivid"
  }
  return(ret)
}

#for use with PT data
resp_labelsPT <- function(resp)
{
  ret <- 0
  if(resp==0){
    ret <- "nan"
  }
  if(resp==1){
    ret <- "sure new"
  }
  if(resp==2){
    ret <- "likely new"
  }
  if(resp==3){
    ret <- "likely old"
  }
  if(resp==4){
    ret <- "sure old"
  }
  return(ret)
}

#label the repetition status of an image
#I'm sorry but I need to rant about this; WHY are the condition IDs A) not saved in their own coulmn, B) stored in DIFFEERENT PARTS OF THIS STRING. WHO DID THIS
cond_labels <- function(conID)
{
  ret <- 0
  if(substr(conID,2,2)=="L"){
    ret <- "New"
  } else if(substr(conID,3,3)=="D") {
    ret <- "Foil"
  } else if(substr(conID,3,3)=="I") {
    ret <- "Old"
  }
  return(ret)
}

#get retrieval labels
ret_labels <- function(conID)
{
  ret <- 0
  if(substr(conID,2,2)=="R"){
    ret <- "Retrieved"
  } else if(substr(conID,2,2)=="N") {
    ret <- "Not Retrieved"
  } else {
    ret <- "Not Shown"
  }
  return(ret)
}

nsubj <- 5
ntrialsR <- 192
ntrialsPT <- 288
retrievaldf <- data.frame()
posttestdf <- data.frame()
### loading data ###
workingDir <- here("~/Desktop/RIME_VVIQ")
for (isubj in seq(from=2, to=nsubj))
{
  if(isubj<10){
    subjStr <- paste("0",as.character(isubj),sep="")
  } else {
    subjStr <- as.character(isubj)
  }
  subjDir <- paste(workingDir,"Data",subjStr,sep="/")
  retrievalmat <- readMat(here(paste(subjDir,"analysisFiles/retData.mat",sep="/")))
  posttestmat <- readMat(here(paste(subjDir,"analysisFiles/ptData.mat",sep="/")))
  retrievalmat <- as.data.frame(lapply(retrievalmat,unlist,use.name=FALSE))
  posttestmat <- as.data.frame(lapply(posttestmat,unlist,use.name=FALSE))
  ## add some much needed labeling to the data
  retrievalmat <- mutate(retrievalmat,respLabels=unlist(lapply(retrievalmat$response,resp_labelsR)))
  retrievalmat <- mutate(retrievalmat,condLabels=unlist(lapply(retrievalmat$conID,cond_labels)))
  retrievalmat <- mutate(retrievalmat,retLabels=unlist(lapply(retrievalmat$conID,ret_labels)))
  retrievalmat <- mutate(retrievalmat,subjID=as.factor(rep(isubj,ntrialsR)))
  
  posttestmat <- mutate(posttestmat,respLabels=unlist(lapply(posttestmat$response,resp_labelsPT)))
  posttestmat <- mutate(posttestmat,condLabels=unlist(lapply(posttestmat$conID,cond_labels)))
  posttestmat <- mutate(posttestmat,retLabels=unlist(lapply(posttestmat$conID,ret_labels)))
  posttestmat <- mutate(posttestmat,subjID=as.factor(rep(isubj,ntrialsPT)))
  retrievaldf <- rbind(retrievaldf,retrievalmat)
  posttestdf <- rbind(posttestdf,posttestmat)
}
## look at responses on vividness test
ggplot(retrievaldf,aes(x=response)) + geom_histogram(color='black',fill='blue',bins=5) + xlab('vividness rating')
#group by face object and scene images
retrievaldf %>% group_by(stimulus) %>% summarise_at(vars(response),list(mean_rating=mean)) %>%
  ggplot(aes(x=stimulus,y=mean_rating)) + geom_bar(stat="identity")
#group by retrieved vs not retrieved
#retrievaldf %>% group_by(retLabels) %>% summarise_at(vars(response),list(mean_rating=mean)) %>%
#  ggplot(aes(x=retLabels,y=mean_rating)) + geom_bar(stat="identity")

## look at acc on post test
posttestdf %>% summarise_at(vars(acc),list(mean_acc=mean)) %>%
  ggplot(aes(x=1,y=mean_acc)) + geom_bar(stat="identity")
## look at acc on post test split by stimulus type
posttestdf %>% group_by(stimulus) %>% summarise_at(vars(acc),list(mean_acc=mean)) %>%
  ggplot(aes(x=stimulus,y=mean_acc)) + geom_bar(stat="identity")
## look at acc on post test split by condition
posttestdf %>% group_by(condLabels) %>% summarise_at(vars(acc),list(mean_acc=mean)) %>%
  ggplot(aes(x=condLabels,y=mean_acc)) + geom_bar(stat="identity")
## look at acc on post test split by retrieval condition
posttestdf %>% group_by(retLabels) %>% summarise_at(vars(acc),list(mean_acc=mean)) %>%
  ggplot(aes(x=retLabels,y=mean_acc)) + geom_bar(stat="identity")

## look at confidence on post test
posttestdf %>% count(respLabels) %>%
  ggplot(aes(x=respLabels,y=n)) + geom_bar(stat="identity")

