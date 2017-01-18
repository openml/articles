

proposal_tutorial.html: proposal_tutorial.Rmd  
	cp ../../openml_citations.bib .
	Rscript -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc'); rmarkdown::render('proposal_tutorial.Rmd')"


all: proposal_tutorial.html

clean: 
	rm -rf *.html


