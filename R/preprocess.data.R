## load libraries
library(plotrix)
library(ggplot2)
library(gcookbook)
library(grid)
library(gridExtra)

## clear environment and variables
rm(list = ls(all = TRUE))

## set workign directory
## ! change this for each user
#setwd("~/Google Drive/Argentine Ant Winter Activity Project/data")
setwd("/Users/GailLee/Documents/RStudioWS/Argentine/data")

## load custom defined functions
source("/Users/GailLee/Documents/RStudioWS/Argentine/code/mean.na.rm.R")
source("/Users/GailLee/Documents/RStudioWS/Argentine/code/sd.na.rm.R")
source("/Users/GailLee/Documents/RStudioWS/Argentine/code/se.na.rm.R")
source("/Users/GailLee/Documents/RStudioWS/Argentine/code/colmean.na.rm.R")
source("/Users/GailLee/Documents/RStudioWS/Argentine/code/colsd.na.rm.R")
source("/Users/GailLee/Documents/RStudioWS/Argentine/code/colse.na.rm.R")
source("/Users/GailLee/Documents/RStudioWS/Argentine/code/multiplot.R")

## read data from csv file and save as data.frame
df.ant1 <- read.csv("20160201/antData_20160201.csv")
df.env1 <- read.csv("20160201/envData_20160201.csv")
df.ant2 <- read.csv("20160222/antData_20160222.csv")
df.env2 <- read.csv("20160222/envData_20160222.csv")
df.ant3 <- read.csv("20160314/antData_20160314.csv")
df.env3 <- read.csv("20160314/envData_20160314.csv")

df.ant2 <- df.ant2[-10] # omitting 10th column (lasertemp data)

# combine all three data
df.ant <- rbind(df.ant1, df.ant2, df.ant3)
df.env <- rbind(df.env1, df.env2, df.env3)

# interested time interval
t_ss <- df.ant[seq(1,dim(df.ant)[1],16), c("t_start","t_stop")]

# get mean of ant measurements for every 16 trials
ant.mean <- as.data.frame(t(sapply(seq(1,length(df.ant[,1])/16,1), 
                                  function(x) colmean.na.rm(df.ant[seq(16*(x-1)+1,16*x,1),
                                                                   c("numup","numdown","speedup","speeddown","winter")]))))
ant.stderr <- as.data.frame(t(sapply(seq(1,length(df.ant[,1])/16,1), 
                                function(x) colse.na.rm(df.ant[seq(16*(x-1)+1,16*x,1),
                                                               c("numup","numdown","speedup","speeddown","winter")]))))

# get mean of environment measurements for every 16 trials
env.mean <-as.data.frame(t(apply(X = t_ss, MARGIN = 1, 
                                function(x) colmean.na.rm(df.env[which(df.env$time > x[1] & df.env$time < x[2]),
                                                                 c("temperature", "humidity","light")]))))
env.stderr <- as.data.frame(t(apply(X = t_ss, MARGIN = 1, 
                               function(x) colse.na.rm(df.env[which(df.env$time > x[1] & df.env$time < x[2]),
                                                              c("temperature", "humidity","light")]))))

# combine all means and standard errors
total.data <- cbind(ant.mean, ant.stderr, env.mean, env.stderr)
colnames(total.data) <- c('m_numup', 'm_numdown', 'm_speedup', 'm_speeddown','m_winter',
                     'se_numup', 'se_numdown', 'se_speedup', 'se_speeddown','se_winter',
                     'm_temperature', 'm_humidity', 'm_light',
                     'se_temperature', 'se_humidity', 'se_light')