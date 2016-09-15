ASCII-art Video Generator (Python)
==================================

Create an Ascii-art version of a given video (cf. 'examples' directory)

**Requirements** :

* Linux
* Python 3.X + Pillow library
* ffmpeg

How to use it
-------------

**Run** : `./main.sh source_video dest_file`

* `make` : run the program on the 'century-fox' example
* `make clean` cleans the 'src' directory (intermediate files)

**Filetypes available** : all those accepted by ffmpeg

The filetype in input can be different than the one in output (see ffmpeg -formats for more details)


**Optionnal parameters** :

* `-r N` : N images per second (default 24)

* `-t N` : thubmnails of size N (default 128)

* `-all` : do not erase intermediate pictures at the end

* `python_src/symbols.txt` : allow user to configure the characters used (the syntax is obvious and explained in the file)
