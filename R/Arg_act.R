#loading data
argact = read.csv('Arg_act_master_data.csv',header = TRUE)
attach(argact)
names(argact)

#number up and down/aggregation
par(mfrow = c(2,2))
for (i in 1:3){
  agg = subset(argact,Aggregation==i)
  num.up.mean = tapply(agg$Arg_up, agg$Start_R, mean, na.rm = TRUE)
  num.down.mean = tapply(agg$Arg_down, agg$Start_R, mean, na.rm = TRUE)
  num.up.err = tapply(agg$Arg_up, agg$Start_R, std.error, na.rm = TRUE)
  num.down.err = tapply(agg$Arg_down, agg$Start_R, std.error, na.rm = TRUE)
  plot(x = c(0,28), y = c(-1,15),type = "n",xaxt = 'n',xlab = '',ylab = "Ants/30s",main = i)
  axis(side = 1,at = c(1:27),labels = c(c(5:23),c(0:7)),tick = TRUE,las = 2)
  lines(num.up.mean,col='blue',lwd = 3)
  lines(num.down.mean, col='red',lwd = 3)
  errbar(c(1:27), num.up.mean, num.up.mean+num.up.err, num.up.mean-num.up.err, add = TRUE,col='blue')
  errbar(c(1:27), num.down.mean, num.down.mean+num.down.err, num.down.mean-num.down.err, add = TRUE,col='red')
  legend("topright",col = c('blue','red'),pch = 20,legend=c('up','down'),bty="n",y.intersp = .25) 
}

#speed up and down/aggregation
par(mfrow = c(2,2))
for (i in 1:3){
  agg = subset(argact,Aggregation==i)
  sp.up.mean = tapply(agg$Speed_up, agg$Start_R, mean, na.rm = TRUE)
  sp.down.mean = tapply(agg$Speed_down, agg$Start_R, mean, na.rm = TRUE)
  sp.up.err = tapply(agg$Speed_up, agg$Start_R, std.error, na.rm = TRUE)
  sp.down.err = tapply(agg$Speed_down, agg$Start_R, std.error, na.rm = TRUE)
  plot(x = c(0,28), y = c(0,80),type = "n",xaxt = 'n',xlab = '',ylab = "Time (s) to travel 10cm",main = i)
  axis(side = 1,at = c(1:27),labels = c(c(5:23),c(0:7)),tick = TRUE,las = 2)
  lines(sp.up.mean,col='blue',lwd = 3)
  lines(sp.down.mean, col='red',lwd = 3)
  errbar(c(1:27), sp.up.mean, sp.up.mean+sp.up.err, sp.up.mean-sp.up.err, add = TRUE,col='blue')
  errbar(c(1:27), sp.down.mean, sp.down.mean+sp.down.err, sp.down.mean-sp.down.err, add = TRUE,col='red')
  legend("topright",col = c('blue','red'),pch = 20,legend=c('up','down'),bty="n",y.intersp = .25) 
}
