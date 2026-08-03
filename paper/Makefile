LATEX := latexmk
FLAGS := -pdf -shell-escape -interaction=nonstopmode -synctex=1 -outdir=.build

.PHONY: all paper clean

all: paper

paper: main.tex main.bib
	$(LATEX) $(FLAGS) $<

clean:
	$(RM) -rf .build/
