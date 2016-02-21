library("fmsb")

v1 <- runif(1000, 0, 1)
v2 <- runif(1000, 0, 1)
v3 <- runif(1000, 0, 1)
v4 <- runif(1000, 0, 1)
v5 <- runif(1000, 0, 1)

maxmin <- data.frame(
  v1 = c(max(v1), min(v1)),
  v2 = c(max(v2), min(v2)),
  v3 = c(max(v3), min(v3)),
  v4 = c(max(v4), min(v4)),
  v5 = c(max(v5), min(v5)))
RNGkind("Mersenne-Twister")
set.seed(123)
top3 <- c(1,2,3)
dat <- data.frame(
  v1 = v1[top3],
  v2 = v2[top3],
  v3 = v3[top3],
  v4 = v4[top3],
  v5 = v5[top3])
dat <- rbind(maxmin,dat)

radarchart(dat, axistype=0, pcol=c(2,3,4), plty=1, plwd=4)
