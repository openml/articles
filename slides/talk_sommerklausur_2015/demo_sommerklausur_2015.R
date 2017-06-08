library(mlr)
library(OpenML)
options(width = 80)

authenticateUser(username = "openml.rteam@gmail.com", 
                 password = "testpassword")

################################################################################
### Explore Data and Tasks #####################################################
################################################################################
# get a list of all data sets
datasets = listOMLDataSets()
str(datasets)
head(datasets)

# select a data set that meets your requirements
req = which(with(datasets, NumberOfFeatures < 30 & NumberOfFeatures > 10 &
                   NumberOfInstances > 1000 & NumberOfInstances < 1500 & 
                   NumberOfMissingValues == 0 &
                   NumberOfClasses %in% 2))
str(datasets[req, ])

# remember ID of those datasets for later
did = datasets[req, "did"]
did

# what tasks are available for these datasets?
tasks = listOMLTasks()
tasks[tasks$did %in% did, ]

# remember only those tasks
tasks = tasks[tasks$did %in% did, ]

################################################################################
### Download Data and Tasks ####################################################
################################################################################
taskCV = getOMLTask(task.id = tasks$task_id[tasks$estimation_procedure == 
                                              "10-fold Crossvalidation"])
taskCV

# get the data set
data = getOMLDataSet(x = taskCV) 
str(data$data)

################################################################################
### Register Learners ##########################################################
################################################################################
library(mlr)
set.seed(1)
lrn1 = makeLearner("classif.randomForest", predict.type = "prob")
lrn2 = makeLearner("classif.rpart", predict.type = "prob")
runs = runMultipleLearnersOnTask(taskCV, list(lrn1, lrn2))

runs$runs
runs$benchmark

plotROCRCurvesGGVIS(generateROCRCurvesData(runs$benchmark))
plotViperCharts(runs$benchmark)

################################################################################
### Upload Runs ################################################################
################################################################################
runIDs = sapply(runs$runs, uploadOMLRun)

################################################################################
### Explore your own and other people's results ################################
################################################################################
runresults = listOMLRunResults(task.id = taskCV$task.id)
tail(runresults) #runresults[runresults$run.id%in%runIDs,]
