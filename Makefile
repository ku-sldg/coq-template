# Coq project makefile

# Documentation target.  Type "make DOC=all-gal.pdf" to make PDF.
DOC	?= gallinahtml

# File $(PROJ) contains the list of source files.
# See "man coq_makefile" for its format.
PROJ	= _CoqProject

# Generated makefile
COQMK	= coq.mk

TEMPLATE_REPO = https://github.com/coq-community/templates.git

COQBIN?=
ifneq (,$(COQBIN))
# add an ending /
COQBIN:=$(COQBIN)/
endif

all:	$(COQMK)
	$(MAKE) -f $(COQMK)
	$(MAKE) -f $(COQMK) $(DOC)

# Generates the meta files for the project
meta: 
	TMP=`mktemp -d` && \
	git clone $(TEMPLATE_REPO) $(TMP) && \
	$(TMP)/generate.sh

$(COQMK): $(PROJ)
	$(COQBIN)coq_makefile -o $(COQMK) -f $(PROJ)

$(PROJ):
	@echo make $@

%:	$(COQMK) force
	$(MAKE) -f $(COQMK) $@

clean:	$(COQMK)
	$(MAKE) -f $(COQMK) clean
	rm $(COQMK) $(COQMK).conf

.PHONY:	all clean force meta
