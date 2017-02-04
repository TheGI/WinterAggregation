## Load libraries
library(plotrix)
library(ggplot2)

## Clear environment and variables
rm(list = ls(all = TRUE))

## Set working directory: change for each user
setwd("~/Google Drive/Argentine Ant Winter Activity Project/data")

## Custom function definitions
mean.na.rm <- function(x){mean(as.numeric(x), na.rm=TRUE)}
colmean.na.rm <- function(x){apply(x,2,mean.na.rm)}
sd.na.rm <- function(x){sd(as.numeric(x), na.rm = TRUE)}
colsd.na.rm <- function(x){apply(x,2,sd.na.rm)}
se.na.rm <- function(x){sd.na.rm(x)/sqrt(length(x))}
colse.na.rm <- function(x){apply(x,2,se.na.rm)}

## Read data from csv file and save as data.frame
#df.ant <- read.csv("antData_20160201.csv")
#df.env <- read.csv("envData_20160201.csv")
#df.ant <- read.csv("antData_20160222.csv")
#df.env <- read.csv("envData_20160222.csv")
#df.ant <- read.csv("antData_20160314.csv")
#df.env <- read.csv("envData_20160314.csv")

t_ss <- df.ant[seq(1,length(df.ant[,1]),16), c("t_start","t_stop")]

envmean <-as.data.frame(t(apply(X = t_ss, MARGIN = 1, 
                                function(x) colmean.na.rm(df.env[which(df.env$time > x[1] & df.env$time < x[2]),
                                                                 c("temperature", "humidity","light")]))))
envse <- as.data.frame(t(apply(X = t_ss, MARGIN = 1, 
                               function(x) colse.na.rm(df.env[which(df.env$time > x[1] & df.env$time < x[2]),
                                                              c("temperature", "humidity","light")]))))
antmean <- as.data.frame(t(sapply(seq(1,length(df.ant[,1])/16,1), 
                                  function(x) colmean.na.rm(df.ant[seq(16*(x-1)+1,16*x,1),
                                                                   c("numup","numdown","speedup","speeddown")]))))
antse <- as.data.frame(t(sapply(seq(1,length(df.ant[,1])/16,1), 
                                function(x) colse.na.rm(df.ant[seq(16*(x-1)+1,16*x,1),
                                                               c("numup","numdown","speedup","speeddown")]))))

#data manipulation: add aggregation num, sum of num up and down, and reorder - adjust agg rep length cause day 3 shorter
agg <- rep(1:3,27)
sumupdown <- antmean$numup + antmean$numdown
antmean.ag <- cbind(antmean,agg)
antmean.agg <- cbind(antmean.ag,sumupdown)
antmean.agg <- antmean.agg[,c("numup","numdown","sumupdown","speedup","speeddown","agg")]

### (1) within-day comparison between aggregations ###########################################
#subsetting antmean data by aggregation
antmean.agg1 <- subset(antmean.agg,agg==1)
antmean.agg2 <- subset(antmean.agg,agg==2)
antmean.agg3 <- subset(antmean.agg,agg==3)
#normalizing within Agg 1
for (i in 1:5){
  antmean.agg1[,i] <- antmean.agg1[,i] / max(antmean.agg1[,i],na.rm = T)
}
#normalizing within Agg 2
for (i in 1:5){
  antmean.agg2[,i] <- antmean.agg2[,i] / max(antmean.agg2[,i],na.rm = T)
}
#normalizing within Agg 3
for (i in 1:5){
  antmean.agg3[,i] <- antmean.agg3[,i] / max(antmean.agg3[,i],na.rm = T)
}
#plotting normalized data
title.vec <- c("numup","numdown","sumupdown","speedup","speeddown","agg")
par(mar=c(3,3,2,2))
par(mfrow = c(3,2))
for (i in 1:5){
plot(antmean.agg1[,i], col = 'red', main = title.vec[i], xlim = c(0,27))
lines(stats::lowess(antmean.agg1[,i], f = .25), col = 'red')
points(antmean.agg2[,i], col = 'blue')
lines(stats::lowess(antmean.agg2[,i], f = .25), col = 'blue')
points(antmean.agg3[,i], col = 'black')
lines(stats::lowess(antmean.agg3[,i], f = .25), col = 'black')
}
legend("topright",col = c('red','blue','black'),legend=c('agg1','agg2','agg3'),bty="n",lty = 1, y.intersp = .25)

### (2) within-aggregation comparison between days ###########################################
#start above (1) with 20160201 data
day <- rep(1,27)
antmean.day1 <- cbind(antmean.agg,day)
#start above (1) with 20160222 data
day <- rep(2,27)
antmean.day2 <- cbind(antmean.agg,day)
#start above (1) with 20160314 data
day <- rep(3,17)
antmean.day3 <- cbind(antmean.agg,day)

#subsetting antmean day data by aggregation
antmean.agg1.1 <- subset(antmean.day1,agg==1)
antmean.agg1.2 <- subset(antmean.day2,agg==1)
antmean.agg1.3 <- subset(antmean.day3,agg==1)
antmean.agg1 <- rbind(antmean.agg1.1,antmean.agg1.2,antmean.agg1.3)

antmean.agg2.1 <- subset(antmean.day1,agg==2)
antmean.agg2.2 <- subset(antmean.day2,agg==2)
antmean.agg2.3 <- subset(antmean.day3,agg==2)
antmean.agg2 <- rbind(antmean.agg2.1,antmean.agg2.2,antmean.agg2.3)

antmean.agg3.1 <- subset(antmean.day1,agg==3)
antmean.agg3.2 <- subset(antmean.day2,agg==3)
antmean.agg3.3 <- subset(antmean.day3,agg==3)
antmean.agg3 <- rbind(antmean.agg3.1,antmean.agg3.2,antmean.agg3.3)

#normalizing across within agg1 
for (i in 1:5){
  antmean.agg1[,i] <- antmean.agg1[,i] / max(antmean.agg1[,i],na.rm = T)
}
#normalizing across aggs within agg2 
for (i in 1:5){
  antmean.agg2[,i] <- antmean.agg2[,i] / max(antmean.agg2[,i],na.rm = T)
}
#normalizing across aggs within agg3 
for (i in 1:5){
  antmean.agg3[,i] <- antmean.agg3[,i] / max(antmean.agg3[,i],na.rm = T)
}

#subsetting antmean aggregation by day
antmean.agg1.1 <- subset(antmean.agg1,day==1)
antmean.agg1.2 <- subset(antmean.agg1,day==2)
antmean.agg1.3 <- subset(antmean.agg1,day==3)

antmean.agg2.1 <- subset(antmean.agg2,day==1)
antmean.agg2.2 <- subset(antmean.agg2,day==2)
antmean.agg2.3 <- subset(antmean.agg2,day==3)

antmean.agg3.1 <- subset(antmean.agg3,day==1)
antmean.agg3.2 <- subset(antmean.agg3,day==2)
antmean.agg3.3 <- subset(antmean.agg3,day==3)

#plotting normalized data - change antmean.agg #s for each run
title.vec <- c("numup","numdown","sumupdown","speedup","speeddown")
par(mar=c(4,4,2,2))
par(mfrow = c(3,2))
for (i in 1:5){
  plot(antmean.agg1.1[,i], col = 'red', main = title.vec[i], ylim = c(0,1))
  lines(stats::lowess(antmean.agg1.1[,i], f = .25), col = 'red')
  points(antmean.agg1.2[,i], col = 'blue')
  lines(stats::lowess(antmean.agg1.2[,i], f = .25), col = 'blue')
  points(antmean.agg1.3[,i], col = 'black')
  lines(stats::lowess(antmean.agg1.3[,i], f = .25), col = 'black')
}
legend("topright",col = c('red','blue','black'),legend=c('day1','day2','day3'),bty="n",lty = 1, y.intersp = .25)

