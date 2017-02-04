colmean.na.rm <- function(x) {
  apply(x,2,mean.na.rm)
}