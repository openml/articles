library(mlr)
library(OpenML)
options(width = 80)

# You have to register yourself at openml.org
authenticateUser(username = "openml.rteam@gmail.com", 
                 password = "testpassword")

################################################################################
### Explore Data and Tasks #####################################################
################################################################################
# get a list of all data sets
datasets = listOMLDataSets()
str(datasets)
head(datasets[,1:6])

# select a data set that meets your requirements
req = which(with(datasets, NumberOfFeatures %in% 15:20 & 
                   NumberOfInstances %in% 800:1000 &
                   NumberOfMissingValues == 0 &
                   NumberOfClasses == 2))
str(datasets[req, ])

# remember ID of those datasets for later usage
did = datasets[req, "did"]
did

# what tasks are available for these datasets?
tasks = listOMLTasks()
str(tasks, vec.len = 2) 
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
taskCV$input$data.set
str(taskCV$input$data.set$data)

taskCV$input$estimation.procedure
taskCV$input$evaluation.measures

################################################################################
### Register Learners with mlr #################################################
################################################################################
library(mlr)
set.seed(1)
lrn1 = makeLearner("classif.rpart", predict.type = "prob")
lrn2 = makeLearner("classif.randomForest", predict.type = "prob")
runs = runMultipleLearnersOnTask(taskCV, list(lrn1, lrn2))

# provides OpenML Run Objects that can be uploaded to the server
runs$runs
# provides mlr benchmark results (default measure: accuracy)
runs$benchmark

# there are several evaluation measures for OpenML task
eval = listOMLEvaluationMeasures()
head(eval)
# you can change the evaluation measure
taskCV$input$evaluation.measures = c("area_under_roc_curve", "predictive_accuracy")
# and re-run
runs = runMultipleLearnersOnTask(taskCV, list(lrn1, lrn2))
runs$runs
runs$benchmark

# mlr's visualizing function
library(gridExtra)
grid.arrange(plotBenchmarkResult(runs$benchmark, acc, pretty.names = FALSE),
             plotBenchmarkResult(runs$benchmark, acc, pretty.names = FALSE), ncol = 2)
plotROCRCurvesGGVIS(generateROCRCurvesData(runs$benchmark))
plotViperCharts(runs$benchmark)

################################################################################
### Upload Runs ################################################################
################################################################################
(id1 = uploadOMLRun(runs$runs$classif.rpart))
(id2 = uploadOMLRun(runs$runs$classif.randomForest))

################################################################################
### Explore your own and other people's results ################################
################################################################################
runresults = listOMLRunResults(task.id = taskCV$task.id)
tail(runresults[,1:8])
