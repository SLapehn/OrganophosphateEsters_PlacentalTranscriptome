 ### Load Packages

library(tidyverse)
library(qgcomp)
library(data.table)
library(BiocParallel)
library(hms)
library(parallel)
library(parallelly)

# Set the multicore parameter to use 20 cpus
options(MulticoreParam=SnowParam(workers=20))

# Check the number of total cores and cores available to the current process
detected_cores <- detectCores()
print(paste("Detected Cores:", detected_cores))

available_cores <- availableCores()
print(paste("Available Cores:", available_cores))


source("EWAS_QGComp_Functions_Update3.R")

### Load Data
load(file="CovariateData_Male_121323.Rdata")

load(file="CovariateNameVector_SexStratified_121323.Rdata")

load(file="MixtureNameVector_120823.Rdata")

load(file="ExpressionData_Male_List_121323.Rdata")


### Run EWAS QGComp with Parallelilization
#Bval is the number of bootstraps to perform (1000 is usually considered good here)
#seedval is to set a seed for reproducibility

start <- Sys.time()
print(start)

#Use this line to run the EWAS QGComp Bootstrap function
ewas_qgcomp_fit.boot<-bplapply(X=meth_Male_list_matrix, FUN=ewas_qgcomp.boot, pheno = Pheno_Male, mix_comp = Xnm, covars = covars, mval_conversion=FALSE, qval=4, output_type="full", Bval=1000, seedval=1234, BPPARAM = SnowParam(workers = 20))
end <- Sys.time()
as_hms(difftime(end, start))

### Save EWAS QGComp Results

save(ewas_qgcomp_fit.boot,file="Male_BootstrapResults_03192024.RData")
