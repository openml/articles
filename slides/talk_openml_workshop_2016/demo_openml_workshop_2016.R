library(mlr)
library(OpenML)
options(width = 80)

################################################################################
### Explore Data and Tasks #####################################################
################################################################################
# what tasks are available for these datasets?
tasks = listOMLTasks()

# select a data set that meets your requirements
req = which(with(tasks, task.type == "Supervised Classification" &
    estimation.procedure == "10-fold Crossvalidation" &
    NumberOfFeatures %in% 8:10 & 
    NumberOfInstances %in% 500:1000 &
    NumberOfMissingValues == 0 &
    NumberOfClasses == 2))

# subset
tasks = tasks[req, ]
dim(tasks)
str(tasks)

################################################################################
### Download Data and Tasks ####################################################
################################################################################
taskCV = lapply(tasks$task.id, getOMLTask)
taskCV

################################################################################
### Register Learners with mlr #################################################
################################################################################
library(mlr)
set.seed(1)
lrn1 = makeLearner("classif.rpart", predict.type = "prob")
lrn2 = makeLearner("classif.randomForest", ntree = 10, predict.type = "prob")

run1 = lapply(taskCV, function(t) runTaskMlr(t, lrn1))
run2 = lapply(taskCV, function(t) runTaskMlr(t, lrn2))

bench1 = extractSubList(run1, element = "mlr.benchmark.result", simplify = FALSE)
bench2 = extractSubList(run2, element = "mlr.benchmark.result", simplify = FALSE)

res1 = do.call("mergeBenchmarkResultTask", bench1)
res2 = do.call("mergeBenchmarkResultTask", bench2)
res.all = mergeBenchmarkResultLearner(res1, res2)

plotBMRBoxplots(res.all)
plotBMRSummary(res.all)

################################################################################
### Upload Runs ################################################################
################################################################################
id1 = sapply(run1, uploadOMLRun)
id2 = sapply(run2, uploadOMLRun)

################################################################################
### Explore your own and other people's results ################################
################################################################################
runresults = listOMLRunEvaluations(run.id = c(id1, id2))
flows = listOMLFlows()

results = plyr::join(runresults, flows)

qplot(x = area.under.roc.curve, 
  colour = factor(full.name),
  y = factor(task.id), 
  data = results, ylab = "task.id")
