## Load libraries
library(plotrix)
library(ggplot2)
library(gcookbook)
library(grid)
library(gridExtra)

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

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

## Read data from csv file and save as data.frame
#  df.ant <- read.csv("20160201/antData_20160201.csv")
#  df.env <- read.csv("20160201/envData_20160201.csv")
# df.ant <- read.csv("20160222/antData_20160222.csv")
# df.env <- read.csv("20160222/envData_20160222.csv")
df.ant <- read.csv("20160314/antData_20160314.csv")
df.env <- read.csv("20160314/envData_20160314.csv")

# interested time interval
t_ss <- df.ant[seq(1,length(df.ant[,1]),16), c("t_start","t_stop")]

# get mean of ant measurements for every 16 trials
antmean <- as.data.frame(t(sapply(seq(1,length(df.ant[,1])/16,1), 
                                  function(x) colmean.na.rm(df.ant[seq(16*(x-1)+1,16*x,1),
                                                                   c("numup","numdown","speedup","speeddown")]))))
antse <- as.data.frame(t(sapply(seq(1,length(df.ant[,1])/16,1), 
                                function(x) colse.na.rm(df.ant[seq(16*(x-1)+1,16*x,1),
                                                               c("numup","numdown","speedup","speeddown")]))))

# get mean of environment measurements for every 16 trials
envmean <-as.data.frame(t(apply(X = t_ss, MARGIN = 1, 
                                function(x) colmean.na.rm(df.env[which(df.env$time > x[1] & df.env$time < x[2]),
                                                                 c("temperature", "humidity","light")]))))
envse <- as.data.frame(t(apply(X = t_ss, MARGIN = 1, 
                               function(x) colse.na.rm(df.env[which(df.env$time > x[1] & df.env$time < x[2]),
                                                              c("temperature", "humidity","light")]))))

total = cbind(antmean, antse, envmean, envse);
colnames(total) <- c('m_numup', 'm_numdown', 'm_speedup', 'm_speeddown',
                     'se_numup', 'se_numdown', 'se_speedup', 'se_speeddown',
                     'm_temperature', 'm_humidity', 'm_light',
                     'se_temperature', 'se_humidity', 'se_light');

# sourceVar = everything;
# xVar = m_temperature;
# yVar = m_numup;
# yErr = se_numup;
# 
# ggplot(sourceVar, aes(x=xVar, y=yVar)) + 
#   geom_errorbar(aes(ymin=yVar-yErr, ymax=yVar+yErr), width=.1) + 
#   geom_point()
# 
# ggplot(total, aes(x=m_temperature, y=m_numdown)) + 
#   geom_errorbar(aes(ymin=m_numdown-se_numdown, ymax=m_numdown+se_numdown), width=.1) + 
#   geom_point()
# 
# ggplot(everything, aes(x=m_temperature, y=m_speedup)) + 
#   geom_errorbar(aes(ymin=m_speedup-se_speedup, ymax=m_speedup+se_speedup), width=.1) + 
#   geom_point()
# 
# ggplot(everything, aes(x=m_temperature, y=m_speeddown)) + 
#   geom_errorbar(aes(ymin=m_speeddown-se_speeddown, ymax=m_speeddown+se_speeddown), width=.1) + 
#   geom_point()
# 
# 
# ggplot(total, aes(x=seq(1,81,1))) +
#   geom_line(aes(y = m_numdown), colour="blue") + 
#   geom_line(aes(y = m_humidity), colour = "grey") + 
#   geom_point(aes(y = m_numdown)) +
#   geom_point(aes(y = m_humidity)) +
#   geom_errorbar(aes(ymin=m_numdown-se_numdown, ymax=m_numdown+se_numdown), width=.1) +
#   geom_errorbar(aes(ymin=m_humidity-se_humidity, ymax=m_humidity+se_humidity), width=.1)
# 
# 
# ggplot(total, aes(x=seq(1,81,1))) +
#   geom_line(aes(y = m_numup), colour="blue") + 
#   geom_line(aes(y = m_humidity), colour = "grey") + 
#   geom_point(aes(y = m_numup)) +
#   geom_point(aes(y = m_humidity)) +
#   geom_errorbar(aes(ymin=m_numup-se_numup, ymax=m_numup+se_numup), width=.1) +
#   geom_errorbar(aes(ymin=m_humidity-se_humidity, ymax=m_humidity+se_humidity), width=.1)
# 
# ggplot(total, aes(x=seq(1,81,1))) +
#   geom_line(aes(y = m_speeddown), colour="blue") + 
#   geom_line(aes(y = m_humidity), colour = "grey") + 
#   geom_point(aes(y = m_speeddown)) +
#   geom_point(aes(y = m_humidity)) +
#   geom_errorbar(aes(ymin=m_speeddown-se_speeddown, ymax=m_speeddown+se_speeddown), width=.1) +
#   geom_errorbar(aes(ymin=m_humidity-se_humidity, ymax=m_humidity+se_humidity), width=.1)
# 
# 
# ggplot(total, aes(x=seq(1,81,1))) +
#   geom_line(aes(y = m_speedup), colour="blue") + 
#   geom_line(aes(y = m_temperature), colour = "grey") + 
#   geom_point(aes(y = m_speedup)) +
#   geom_point(aes(y = m_humidity)) +
#   geom_errorbar(aes(ymin=m_speedup-se_speedup, ymax=m_speedup+se_speedup), width=.1) +
#   geom_errorbar(aes(ymin=m_humidity-se_humidity, ymax=m_humidity+se_humidity), width=.1)
# 
plots <- list()
## TODO: Normalize each variable and plot num & temp against time 
## and run stats on difference between num and temp for each time point
## see if there is trend difference
for (aggN in 1:3){
  for (obsN in 1:3){
    print("hello")
    pN <- ggplot( subset(everything, aggrnum==aggN & obsnum==obsN) , 
                  aes(x=m_temperature, y=m_numup)) + 
      geom_errorbar(aes(ymin=m_numup-se_numup, 
                        ymax=m_numup+se_numup), width=.1) + 
      geom_point() +
      geom_smooth(method = "lm", se = TRUE) +
      xlim(5, 25) +
      ylim(0,20)
    plots[[(aggN-1)*3+obsN]] <- pN;
#     mod <- lm(subset(everything$m_speeddown, aggrnum==aggN & obsnum==obsN) ~
#       subset(everything$m_temperature, aggrnum==aggN & obsnum==obsN))
  }
}
multiplot(plotlist = plots, cols = 3)

x <- everything$m_temperature
y <- everything$m_speedup # plot scatterplot and the regression line
z <- everything$m_speeddown
k <- everything$m_numup
#k <- everything$m_speedup ## unhash this line and hash line 172, then run lines 175 through 195 

k_agg1 <- k[seq(1,length(k),3)]
k_agg2 <- k[seq(2,length(k),3)]
k_agg3 <- k[seq(3,length(k),3)]
k_day1 <- k[1:81]
k_day2 <- k[81:162]
k_day3 <- k[163:213]
x_agg1 <- x[seq(1,length(x),3)]
x_agg2 <- x[seq(2,length(x),3)]
x_agg3 <- x[seq(3,length(x),3)]
x_day1 <- x[1:81]
x_day2 <- x[81:162]
x_day3 <- x[163:213]

mod1 <- lm(y ~ x)
mod2 <- lm(z ~ x)
mod3 <- lm(k~x)

mod_agg1 <- lm(k_agg1 ~ x_agg1)
mod_agg2 <- lm(k_agg2 ~ x_agg2)
mod_agg3 <- lm(k_agg3 ~ x_agg3)
mod_day1 <- lm(k_day1 ~ x_day1)
mod_day2 <- lm(k_day2 ~ x_day2)
mod_day3 <- lm(k_day3 ~ x_day3)

par(mfrow = c(2,3))
plot(x_agg1, k_agg1, ylim = c(0, 25), xlim = c(5, 25))
abline(mod_agg1, lwd=2)
plot(x_agg2, k_agg2, ylim = c(0, 25), xlim = c(5, 25))
abline(mod_agg2, lwd=2)
plot(x_agg3, k_agg3, ylim = c(0, 25), xlim = c(5, 25))
abline(mod_agg3, lwd=2)
plot(x_day1, k_day1, ylim = c(0, 25), xlim = c(5, 25))
abline(mod_day1, lwd=2)
plot(x_day2, k_day2, ylim = c(0, 25), xlim = c(5, 25))
abline(mod_day2, lwd=2)
plot(x_day3, k_day3, ylim = c(0, 25), xlim = c(5, 25))
abline(mod_day3, lwd=2)



# calculate residuals and predicted values
res <- signif(residuals(mod1), 5)
pre <- predict(mod1) # plot distances between points and the regression line
segments(x, y, x, pre, col="red")

# add labels (res values) to points
library(calibrate)
textxy(x, y, res, cx=0.7)
