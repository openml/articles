################################################################################
### Install and Configure OpenML ###############################################
################################################################################
# library(devtools)
# install_github("openml/openml-r", ref = "DataGeeksDataDay2016")

# configure OpenML, here we use a public read-only key
library(OpenML)
getOMLConfig()
setOMLConfig(
  server = "http://www.openml.org/api/v1", 
  apikey = "c1994bdb7ecb3c6f3c8f3b35f4b47f1f", 
  verbosity = 0
)

################################################################################
### Explore Data and Tasks #####################################################
################################################################################
# what tasks that meet the following requirements are available?
tasks = listOMLTasks(
  task.type = "Supervised Classification", 
  estimation.procedure = "10-fold Crossvalidation",
  number.of.classes = 2, 
  number.of.features = c(8, 12), 
  number.of.instances = c(501, 999), 
  number.of.missing.values = 0
)

tasks[, c("task.id", "name", "number.of.instances", "number.of.features")]

################################################################################
### Download Data and Tasks ####################################################
################################################################################
task.list = lapply(tasks$task.id, getOMLTask)
task.list

################################################################################
### Register Learners with mlr #################################################
################################################################################
library(mlr)
listLearners("classif", properties = c("factors"))[,1:2]

lrn.list = list(
  makeLearner("classif.rpart"),
  makeBaggingWrapper(makeLearner("classif.rpart"), bw.iters = 100),
  makeLearner("classif.randomForest", ntree = 100)
)

################################################################################
### Create Runs for each Task-Learner Combination ##############################
################################################################################
grid = expand.grid(task = seq_along(task.list), lrn = seq_along(lrn.list))
grid

runs = vector("list", nrow(grid))
for (i in 1:nrow(grid)) {
  cat(i, fill = TRUE)
  ind.task = grid$task[i]
  ind.lrn = grid$lrn[i]
  runs[[i]] = runTaskMlr(task.list[[ind.task]], lrn.list[[ind.lrn]], verbosity = 1)
}

# use some plotting functionality from mlr
bmr.list = lapply(runs, function(x) x$bmr)
bmr = do.call("mergeBMR", bmr.list)
bmr

plotBMRBoxplots(bmr)
plotBMRSummary(bmr, pretty.names = FALSE)
plotBMRRanksAsBarChart(bmr, pretty.names = FALSE)

################################################################################
### Upload Runs ################################################################
################################################################################
# you need an own apikey to upload stuff
# loadOMLConfig()
# run.ids = sapply(runs, uploadOMLRun, tags = "DataGeeksDataDay2016")

################################################################################
### Explore Results ############################################################
################################################################################
results = listOMLRunEvaluations(tag = "DataGeeksDataDay2016")

# server computes all possible measures, which can then be visualized
ggplot(results, aes(x = data.name, y = predictive.accuracy, 
  colour = flow.name, group = flow.name)) +
  geom_point() +  geom_line() +
  ylab("Predictive Accuracy")
