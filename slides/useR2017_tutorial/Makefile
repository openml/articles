

proposal_tutorial.html: proposal_tutorial.md  
	cp ../../openml_citations.bib .
	Rscript -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc'); rmarkdown::render('proposal_tutorial.md')"


all: proposal_tutorial.html

clean: 
	rm -rf *.html


