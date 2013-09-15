# Makefile for lualibs.

NAME = lualibs
DTX = $(wildcard *.dtx)
DOC_DTX = $(patsubst %.dtx, %.pdf, $(DTX))
LUALIBS	= $(wildcard lualibs-*.lua)
MODULES = $(filter-out $(UNPACKED),$(LUALIBS))

# Files grouped by generation mode
TESTSCRIPT 		= test-lualibs.lua
DIFFSCRIPT 		= whatsnew.lua
SCRIPTS			= $(TESTSCRIPT) $(DIFFSCRIPT)
UNPACKED		= lualibs.lua lualibs-extended.lua lualibs-basic.lua
COMPILED 		= $(DOC_DTX)
GENERATED 		= $(UNPACKED) $(DOC_DTX) $(MERGED)
SOURCE 			= $(DTX) $(MODULES) $(SCRIPTS) LICENSE README Makefile NEWS
MERGED 			= lualibs-basic-merged.lua lualibs-extended-merged.lua

# Files grouped by installation location
RUNFILES = $(UNPACKED) $(MODULES)
DOCFILES = $(DOC_DTX) LICENSE README NEWS
SRCFILES = $(DTX) $(SRC_TEX) Makefile $(SCRIPTS)

# The following definitions should be equivalent
# ALL_FILES = $(RUNFILES) $(DOCFILES) $(SRCFILES)
ALL_FILES = $(SOURCE) $(filter-out $(SOURCE),$(GENERATED))

# Installation locations
FORMAT = luatex
RUNDIR = $(TEXMFROOT)/tex/$(FORMAT)/$(NAME)
DOCDIR = $(TEXMFROOT)/doc/$(FORMAT)/$(NAME)
SRCDIR = $(TEXMFROOT)/source/$(FORMAT)/$(NAME)
DISTDIR = ./lualibs
TEXMFROOT = ./texmf

CTAN_ZIP = $(NAME).zip
TDS_ZIP = $(NAME).tds.zip
ZIPS = $(CTAN_ZIP) $(TDS_ZIP)

DO_TEX 			= luatex     --interaction=batchmode $< >/dev/null
DO_PDFLATEX 	= latexmk -pdf -e '$$pdflatex = q(lualatex %O %S)' -silent $< >/dev/null
DO_MAKEINDEX 	= makeindex  -s gind.ist $(subst .dtx,,$<) >/dev/null 2>&1
DO_PACKAGE 		= mtxrun     --script package --merge $< >/dev/null

all: $(GENERATED) $(DOC_TEX)
doc: $(COMPILED)
unpack: $(UNPACKED)
ctan: check $(CTAN_ZIP)
tds: $(TDS_ZIP)
world: all ctan

check: $(TESTSCRIPT)
	@texlua $(TESTSCRIPT)

news: $(DIFFSCRIPT)
	@texlua $(DIFFSCRIPT)

.PHONY: all doc unpack ctan tds world check news

%.pdf: %.dtx
	$(DO_PDFLATEX)
	$(DO_MAKEINDEX)
	$(DO_PDFLATEX)
	$(DO_PDFLATEX)

%-merged.lua: %.lua
	$(DO_PACKAGE)

$(UNPACKED): lualibs.dtx
	$(DO_TEX)

define make-ctandir
@if [ -d $(DISTDIR) ] ; \
 then \
     rm -r $(DISTDIR) ; \
 fi
@mkdir $(DISTDIR) && cp $(ALL_FILES) $(DISTDIR)
endef

$(CTAN_ZIP): $(ALL_FILES) $(TDS_ZIP)
	@echo "Making $@ for CTAN upload."
	@$(RM) -- $@
	$(make-ctandir)
	@zip -r -9 $@ $(DISTDIR) $(TDS_ZIP) >/dev/null

define run-install
@mkdir -p $(RUNDIR) && cp $(RUNFILES) $(RUNDIR)
@mkdir -p $(DOCDIR) && cp $(DOCFILES) $(DOCDIR)
@mkdir -p $(SRCDIR) && cp $(SRCFILES) $(SRCDIR)
endef

$(TDS_ZIP): TEXMFROOT=./tmp-texmf
$(TDS_ZIP): $(ALL_FILES)
	@echo "Making TDS-ready archive $@."
	@$(RM) -- $@
	$(run-install)
	@cd $(TEXMFROOT) && zip -9 ../$@ -r . >/dev/null
	@$(RM) -r -- $(TEXMFROOT)

.PHONY: install manifest clean mrproper

install: $(ALL_FILES)
	@echo "Installing in '$(TEXMFROOT)'."
	$(run-install)

manifest: 
	@echo "Source files:"
	@for f in $(SOURCE); do echo $$f; done
	@echo ""
	@echo "Derived files:"
	@for f in $(GENERATED); do echo $$f; done

clean: 
	@$(RM) -- *.log *.aux *.toc *.idx *.ind *.ilg

mrproper: clean
	@$(RM) -- $(GENERATED) $(ZIPS)
	@$(RM) -r $(DISTDIR)

merge: $(MERGED)
