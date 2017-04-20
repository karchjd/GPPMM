require("OpenMx");
require("devtools")
load_all("~/mystuff/projects/dissertation/code/Rdis")

a<-commandArgs(trailingOnly=TRUE)
p<-as.numeric(a[1])
#create model and simulate
simOut <- ARSimulate(31337,p)
model <-simOut$model
simData <- simOut$simData
trueModel <- simOut$trueModel
write.table(simData,'data_AR.csv',col.names=FALSE,quote=FALSE,row.names = FALSE)

#fit full model
model <- mxModel(model,mxData(simData,type='raw'))
result1 <- mxRun(model)

#transport results to matlab
resTrue <- openMxToMatlab(trueModel,flat=TRUE)
resMx <- openMxToMatlab(result1,flat=TRUE)
resStart <- openMxToMatlab(model,flat=TRUE)
writeMat('ARR.mat',resTrue=resTrue,resMx=resMx,resStart=resStart) #save results to matlab