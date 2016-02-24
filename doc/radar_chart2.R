library("fmsb")

radar_chart <- function(dataset){
  
  name <- names(dataset)
  n <- length(name) - 1
  zip <- subset(dataset, select = name[1])
  VarToPlot <- name[order(dataset[1,2:(n+1)], decreasing = T)[1:5]+1]
  variables <- subset(dataset, select = VarToPlot)
  
  maxmin <- data.frame(
    v1 = c(max(variables[,1]), min(variables[,1])),
    v2 = c(max(variables[,2]), min(variables[,2])),
    v3 = c(max(variables[,3]), min(variables[,3])),
    v4 = c(max(variables[,4]), min(variables[,4])),
    v5 = c(max(variables[,5]), min(variables[,5])))
  
  top3 <- c(1,2,3)
  dat <- data.frame(
    v1 = variables[top3, 1],
    v2 = variables[top3, 2],
    v3 = variables[top3, 3],
    v4 = variables[top3, 4],
    v5 = variables[top3, 5])
  dat <- rbind(maxmin,dat)
  colnames(dat) <- VarToPlot
  
  radarchart(dat, axistype = 0, pcol = c(2,3,4), plty = 1, plwd = 4)
  legend(-2.5, -0.3, legend = as.character(zip[1:3,]), lty = 1, lwd = 4, col = c(2,3,4), cex = 0.6)
  
}