# Maxtract - Extract LaTeX source from pdf files
This is an attempt to put into a working docker the Maxtract program.
The executable are [downloaded from official site](http://www.cs.bham.ac.uk/research/groupings/reasoning/sdag/maxtract_lin32.tgz) and are put in a working environment inside a docker.

## How to build the docker
```
docker build . -t maxtract
```

## How to use the docker
Create the directory `data` into which you can put some pdf files.
In this repository there is the default `test.pdf` file from Maxtract.
```
docker run -v $(pwd)/data:/data -it maxtract:latest ./process_file.sh test.pdf
```

This should produce a file `test.pdf.tex` inside the `data` folder.

## Caveats

- I'm not the author of Maxtract, I just put together a working image because I needed it.

- The produced LaTeX files are good but need some tuning by hand to be more usable.

- If you want to know how the original program works, you should look at the paper or [at the code in other repositories](https://github.com/zorkow/MaxTract).
  If you want to know how I got it to work, look at the file in `maxtract/process_file.sh`.
  No magic involved, I just read the help of all given commands and figured out a way to get it to work.

- To compile the resulting tex file you can use as preamble:
  ```
  \documentclass[a4paper,11pt]{article}
  \usepackage{ifthen}
  \usepackage{amsmath,amssymb}
  
  \begin{document}
  ```
  Then insert the whole tex file produced and after it:
  ```
  \end{document}
  ```

## Additional Usage
	By default we use the latex output, but you can change this using the settings of the `process_file.sh` script.
	In particular the script input is:
	```
	process_file.sh PDF_FILE_TO_PROCESS DRIVER LAYOUT TYPE
	```
	where the defaults are `DRIVER=latex2`, `LAYOUT=latex`, `TYPE=LINES`.
	Be aware that many combinations do produce errors and so look carefully at the terminal output.

	For convenience the relevant help of `anderson_post.opt` is reported here (do not ask me what they mean because I don't have an idea):
	```
	$ ./anderson_post.opt -drivers
    dummy:       A dummy expression driver that serves as default. 
    festival:    A basic driver for the Festival Speech Synthesis System based
                 exclusively on character information. 
    index:       A driver to provide XML annotation for Indexing. 
    latex:       A simple LaTeX driver based exclusively on character information.
                 (Retained for compatibility!) 
    latex2:      A complex LaTeX driver, using font and spacing information.
                 (Retained for compabitility!) 
    latex_com:   A complex LaTeX driver, using font and spacing information. 
    latex_med:   A medium LaTeX driver, using some font and size information. 
    latex_sim:   A simple LaTeX driver based exclusively on character information. 
    mathml:      A simple MathML driver based exclusively on character information. 
    pdf:         A LaTeX driver that adds Latex and MathML annotations for math
                 expressions in PDF. 
    pdf_latex:   A LaTeX driver that adds Latex annotations for math expressions in
                 PDF. 
    pdf_mathml:  A LaTeX driver that adds MathML annotations for math expressions
                 in PDF. 
    word:        A simple Word driver ignoring all Math. 
    xml:         A simple XML translation with linearity and minimal argument tags 
    xml_bbox:    A complex XML translation with linearity, minimal argument tags
                 and bounding box information for all sub-expressions. 
    xml_tree:    A simple XML translation faithful to the tree structure 

	$ ./anderson_post.opt -layouts
    dummy:           A dummy layout driver that serves as default. 
                     Implements: 
    festival:        Layout analysis for Festival documents. 
                     Implements: EXPR EXPRS LINE LINES AREA PAGE DOC 
    festival_latex:  Layout analysis for Latex documents to simple text. 
                     Implements: EXPR EXPRS CEXPRS LEXPRS LINE LINES AREA PAGE DOC 
    gts:             Ground truth data. 
                     Implements: EXPR EXPRS LINE LINES AREA PAGE DOC 
    index:           Layout analysis to provide XML annotation for Indexing. 
                     Implements: EXPR EXPRS LINE LINES AREA PAGE DOC 
    latex:           Layout analysis for Latex documents. 
                     Implements: EXPR EXPRS CEXPRS LEXPRS LINE LINES AREA PAGE DOC 
    legacy:          Invoking legacy drivers. 
                     Implements: MKM09-latex MKM09-mathml DAS10-latex EuDML-latex
                                 EuDML-mathml ICDAR11-latex ICDAR11-gts 
    mathml:          Layout analysis for Mathml documents. 
                     Implements: EXPR EXPRS CEXPRS LINE LINES AREA PAGE DOC 
    pdf_both:        Multilayer PDF documents containing LaTeX code and normal text
                     underneath. 
                     Implements: EXPR EXPRS LINE LINES AREA PAGE DOC 
    pdf_code:        Multilayer PDF documents containing LaTeX code underneath. 
                     Implements: EXPR EXPRS LINE LINES AREA PAGE DOC 
    pdf_text:        Multilayer PDF documents containing plain text underneath. 
                     Implements: EXPR EXPRS LINE LINES AREA PAGE DOC 
    tralics:         Translation to MathML using Tralics via a given Latex driver. 
                     Implements: LINE LINES AREA PAGE DOC 
    word:            Getting Words out of documents, etc. 
                     Implements: LINE LINES AREA PAGE DOC 
    xml:             Layout analysis for Latex documents. 
                     Implements: EXPR EXPRS CEXPRS LEXPRS LINE LINES AREA PAGE DOC 

	$ ./anderson_post.opt -types
    AREA:    Parsing an area. 
             Implemented by drivers: festival festival_latex gts index latex mathml
                                     pdf_both pdf_code pdf_text tralics word xml 
    CEXPRS:  Parsing expressions for comparison with image files. 
             Implemented by drivers: festival_latex latex mathml xml 
    DOC:     Parsing an entire document. 
             Implemented by drivers: festival festival_latex gts index latex mathml
                                     pdf_both pdf_code pdf_text tralics word xml 
    EXPR:    Parsing single Math expressions. 
             Implemented by drivers: festival festival_latex gts index latex mathml
                                     pdf_both pdf_code pdf_text xml 
    EXPRS:   Parsing several Math expressions. 
             Implemented by drivers: festival festival_latex gts index latex mathml
                                     pdf_both pdf_code pdf_text xml 
    LEXPRS:  Parsing expressions separately and including separate files into a
             master file (rather than including the actual expressions). 
             Implemented by drivers: festival_latex latex xml 
    LINE:    Parsing a single line. 
             Implemented by drivers: festival festival_latex gts index latex mathml
                                     pdf_both pdf_code pdf_text tralics word xml 
    LINES:   Parsing several lines. 
             Implemented by drivers: festival festival_latex gts index latex mathml
                                     pdf_both pdf_code pdf_text tralics word xml 
    PAGE:    Parsing a page. 
             Implemented by drivers: festival festival_latex gts index latex mathml
                                     pdf_both pdf_code pdf_text tralics word xml 
    Some drivers might implement other, undocumented layout types.
	```

## Conclusions and other things
	Have fun with such thing.
	If you are one of the author of the original project, please provide the community with working source files as well as drivers description and differences.
