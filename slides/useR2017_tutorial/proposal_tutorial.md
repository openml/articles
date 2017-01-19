---
title: "OpenML"
author: |
  | Joaquin Vanschoren^1^,  Heidi Seibold^2^ and Bernd Bischl^3^
  |
  | 1. Eindhoven University of Technology
  | 2. University of Zurich
  | 3. LMU Munich
  
institute:
- $^1$Department of Mathematics and Computer Science
- $^2$Epidemiology, Biostatistics and Prevention Institute
- $^3$Department of Statistics 
output: html_document
bibliography: openml_citations.bib
---

**Keywords**: Machine Learning, Online Platform, Collaboration, Open Science, Reproducible Research


[*OpenML*](http://www.openml.org/) [@Vanschoren2014openml] is an online
platform for collaborative and - as the name says - open machine learning.
Users can upload, organize, search and download data sets and corresponding
prediction tasks; they can run algorithms (flows) on the tasks and upload these
runs for everyone to see and compare to other solutions.  By connecting data,
tasks, flows and runs online, *OpenML* allows for easy and fast collaboration
to solve prediction tasks.

# Aim of the tutorial
In this tutorial we want to introduce *R* users to the [**OpenML** *R*
package](https://github.com/openml/openml-r) [@Casalicchio2017openml] and show
how everyone can easily make use of *OpenML* in their work, and share it with
others online. At the end of the tutorial we want every attendee to be able to
interact with the platform. We want to accomplish this by working hands-on.

# Tutorial content

The tutorial will introduce the **OpenML** concept, the web interface of the
server and how to interact with it from *R* scripts. A large part of the
tutorial will demonstrate the different objects and features of the **OpenML**
*R* package.  Participants will learn how to run dozens of different machine
learning algorithms from the [**mlr** *R*
package](http://github.com/mlr-org/mlr) on many **OpenML** datasets and tasks
with very few lines of code, and upload their experiments automatically to the
server to share them with others. The last hour of the tutorial will be devoted
to construct a demo project together with the participants to answer a
realistic question from machine learning together with **OpenML** and *R*.

- Overview of the online platform (web interface)
- Data, tasks, flows and runs
- Becoming a member
- The social aspects of *OpenML*
- **OpenML** and **mlr**
- The *R* package
    + Installation and configuration
    + Listing information
    + Downloading **OpenML** datasets, tasks and runs 
    + Creating runs 
    + Uploading and Tagging
    + Further features
- Your first *OpenML* project


# Target audience and prerequisites
We aim to address a broad audience, since OpenML is interesting for many
different people, such as people who 

- have data (possibly with a prediction task they want to solve collaboratively), 
- analyze data, 
- develop and compare algorithms, 
- want to learn about machine learning, or 
- teach machine learning.

The only prerequisite required is a very basic understanding of machine
learning and of *R*.


# The instructors

[Joaquin Vanschoren](http://www.win.tue.nl/~jvanscho/) is the founder of
*OpenML* and professor of machine learning at the Eindhoven University of
Technology.

[Heidi
Seibold](http://www.ebpi.uzh.ch/en/aboutus/departments/biostatistics/teambiostats/seibold.html)
is a PhD candidate in biostatistics at the University of Zurich.

[Bernd Bischl](http://www.compstat.statistik.uni-muenchen.de/people/bischl/) is
a professor for computational statistics at the LMU Munich, a long-term member
of the OpenML project and the creator of the [**mlr** package for machine
learning](http://github.com/mlr-org/mlr).

*OpenML* is an open source community project. We gladly represent the amazing
[*OpenML* team](http://www.openml.org/guide#!team).


# OpenML at useR!
We believe that many useR! attendees will be interested in using *OpenML* for
their work, research and studies. The open source philosophy of *R* aligns with
[*OpenML*](https://github.com/openml). The form of a hands-on tutorial to
introduce *OpenML* is perfect, since the platform is especially useful for
people if they can actively participate.  The **OpenML** *R* package makes
participation easy for *R* users and three hours should get everyone into a
state where they can use and benefit from the package.

 <!-- - Goals/Aims/Learning objectives -->
 <!-- - Justification for running the tutorial at useR! 2017 -->
 <!-- - Description of the tutorial -->
 <!-- - Outline of the tutorial content -->
 <!-- - Pre-requisites -->
 <!-- - Potential attendees -->
 <!-- - Instructor biograph(y/ies) or link to online profile(s) -->
 <!-- - References -->
 


# References
