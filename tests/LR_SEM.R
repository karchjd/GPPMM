require("OpenMx");
require("devtools")
load_all("~/mystuff/projects/dissertation/code/Rdis")

a<-commandArgs(trailingOnly=TRUE)
p<-as.numeric(a[1])
N<-as.numeric(a[2])
ctTime<-as.logical(as.numeric(a[3]))

if (is.na(p)){
  p<- 3
  N<- 20
  ctTime <- FALSE
}


if (ctTime){
  N2 <- N
}else{
  N2<- 0
}

#create model
model <- generateLGCM(p,N=N2,posvar=TRUE)

#simulate
modelRandom <- LGCMrandomValues(model); #populate all free variables with kinda random values
simData <- simulateData(modelRandom,N)
write.table(simData,'data.csv',col.names=FALSE,quote=FALSE,row.names = FALSE)
#fit and report full model, also compute CIs
model <- mxModel(model,mxData(simData,type='raw'))
modelWCi <- mxModel(model,mxCI(names(c(omxGetParameters(model)))))
result1 <- mxRun(modelWCi,intervals=TRUE)
resfull <- openMxToMatlab(result1) #transform all stuff from ml estimation

#transform all stuff from CI calculation
resCI <- summary(result1)$CI
resCI <- resCI[,1:3]
resCI <- t(resCI)
resCI <- as.data.frame(resCI)

#fit and report reduced model
modelRes <- mxModel(model,name="wo cov", mxPath(from="slope",to="intercept",free=FALSE,value=0,arrows=2))
result2 <- mxRun(modelRes)
resred <- openMxToMatlab(result2)
resred$mlPar$covIS <- 0

#perform and report lr test
lrTest <- mxCompare(result1,result2)
p <- lrTest$p[2]
resLR <- list()
resLR$p <- p
resLR$diffdf <- lrTest[2,'diffdf']
resLR$m2llfull <- lrTest[1,'minus2LL']
resLR$m2llred <- lrTest[2,'minus2LL']

#save results
writeMat('Rres.mat',resfull=resfull,resred=resred,resLR=resLR,resfullmlPar=resfull$mlPar,resredmlPar=resred$mlPar,CIs=resCI) #save results to matlab