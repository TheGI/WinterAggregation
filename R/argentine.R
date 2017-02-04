# set the working directory
setwd('~/Google Drive/Research/Linepithema_Winter_Survey/preprocessdata/')

ant.data <- read.csv('antData_20160201.csv', stringsAsFactors = FALSE)
ant.data <- rbind(ant.data,
                  read.csv('antData_20160222.csv', 
                           stringsAsFactors = FALSE)[,-10])
ant.data <- rbind(ant.data,
                  read.csv('antData_20160314.csv', stringsAsFactors = FALSE))

env.data <- read.csv('envData_20160201.csv',stringsAsFactors = FALSE)
env.data <- rbind(env.data,
                  read.csv('envData_20160222.csv',stringsAsFactors = FALSE))
env.data <- rbind(env.data,
                  read.csv('envData_20160314.csv',stringsAsFactors = FALSE))
