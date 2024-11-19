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

# Source this R data sheet with all necessary function to run job
source("EWAS_QGComp_Functions_Update3.R")


### Load Data
load(file="CovariateData_120823.Rdata")

load(file="CovariateNameVector_120823.Rdata")

load(file="MixtureNameVector_120823.Rdata")


# Testing 100 Genes
#load(file="ExprDataTestList_100genes_120523.Rdata")

# Testing 1000 Genes
#load(file="ExprDataTestList_1000genes_120623.Rdata")

# Running Full Data Set
load(file="ExpressionData_List_120823.Rdata")


### Run EWAS QGComp with Parallelilization
#Bval is the number of bootstraps to perform (1000 is usually considered good here)
#seedval is to set a seed for reproducibility

start <- Sys.time()
print(start)

#Use this line to run the EWAS QGComp Bootstrap function

# For Full Data Set
ewas_qgcomp_fit.boot<-bplapply(X=meth_list_matrix, FUN=ewas_qgcomp.boot, pheno = Pheno, mix_comp = Xnm, covars = covars, mval_conversion=FALSE, qval=4, output_type="full", Bval=1000, seedval=1234, BPPARAM = SnowParam(workers = 20))

# For Test Data Set
#ewas_qgcomp_fit.boot<-bplapply(X=meth_test_list_matrix, FUN=ewas_qgcomp.boot, pheno = Pheno, mix_comp = Xnm, covars = covars, mval_conversion=FALSE, qval=4, output_type="full", Bval=1000, seedval=1234, BPPARAM = SnowParam(workers = 20))

end <- Sys.time()
print(end)

# Print the duration of the job in hms format
as_hms(difftime(end, start))

# Output log file will be stored in /home/user/logs and will contain the PBS job id as the prefix in the file name

### Save EWAS QGComp Results
save(ewas_qgcomp_fit.boot,file="BootstrapResults_FullDataset_03202024.RData")








