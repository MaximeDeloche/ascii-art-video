#! /usr/bin/env python3
# -*- coding: utf-8 -*-

# Parameters :
#   - source directory (containing thumbnails)
#   - destination directory (will contain ascii-pictures)

import sys, os

from functions import *

# Initialisation ###############################################################

# load the list of symbols, ordered by decreasing degree of darkness
symbols = load_symbols_list("symbols.txt")

# Computation and drawing ######################################################

src_dir = sys.argv[1]
dest_dir = sys.argv[2]

picts_list = sorted(os.listdir(src_dir))
nb_of_picts = len(picts_list)
i = 0

for picture in picts_list:
    # get the pixels tabular
    (pixels, x_size, y_size) = load_picture(src_dir + "/" + picture)

    # draw these strings in an SVG picture
    create_ascii_picture(   pixels,
                            symbols, 
                            dest_dir + "/" + picture, 
                            x_size, 
                            y_size)

    print(" Ascii picture : {} / {}".format(i, nb_of_picts), end = '\r')
    i += 1

print("All Ascii pictures generated.")

