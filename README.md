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
