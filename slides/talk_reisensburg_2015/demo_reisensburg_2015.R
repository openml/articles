library(mlr)
library(OpenML)
options(width = 100)

# You have to register yourself at openml.org
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
req = which(with(datasets, NumberOfFeatures < 30 & 
                   NumberOfInstances > 1000 & NumberOfInstances < 1500 & 
                   NumberOfMissingValues == 0 &
                   NumberOfClasses %in% 2))
str(datasets[req, ])

# remember ID of those datasets for later usage
did = datasets[req, "did"]
did

# get more information for these data sets "data qualities"
qual = lapply(did, listOMLDataSetQualities)
qual = Reduce(function(...) plyr::join(..., by="name"), qual)
colnames(qual)[-1] = did
qual

# let's say we don't want to use imbalanced data sets
ratio = qual[2,as.character(did)]/qual[3,as.character(did)]
ratio
# remember only data set id for data sets with imbalance ratio < 1.2
did = names(ratio)[ratio < 1.2]
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

taskCV$input$estimation.procedure
taskCV$input$evaluation.measures

# get the data set
sleepdata = taskCV$input$data.set
sleepdata
str(sleepdata$data)

################################################################################
### Register Learners with mlr #################################################
################################################################################
library(mlr)
set.seed(1)
lrn1 = makeLearner("classif.rpart", predict.type = "prob")
lrn2 = makeLearner("classif.logreg", predict.type = "prob")
runs = runMultipleLearnersOnTask(taskCV, list(lrn1, lrn2))

# provides OpenML Run Objects that can be uploaded to the server
runs$runs
# provides mlr benchmark results (default measure: accuracy)
runs$benchmark

# there are several evaluation measures for OpenML task
eval = listOMLEvaluationMeasures()
head(eval)
# you can change the evaluation measure
taskCV$input$evaluation.measures = "area_under_roc_curve"
# and re-run
runs = runMultipleLearnersOnTask(taskCV, list(lrn1, lrn2))
runs$runs
runs$benchmark

# mlr's visualizing function
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
