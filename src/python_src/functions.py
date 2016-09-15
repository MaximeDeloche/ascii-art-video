#! /usr/bin/env python3
# -*- coding: utf-8 -*-

from PIL import Image, ImageDraw, ImageFont

import sys
from os.path import dirname


def load_symbols_list(filename):
    directory = dirname(sys.argv[0])
    if directory == '':
        path = filename
    else:
        path = directory + '/' + filename

    symbols = []
    symbols_file = open(path, "r")

    for line in symbols_file:
        symbols.append(line[0])

    symbols_file.close()
    return symbols


def load_picture(filename):
    # TODO => use PixelAccess class instead ?
    img = Image.open(filename).convert('L')
    (x, y) = img.size
    pixels = list(img.getdata())
    img.close()
    return (pixels, x, y)


def create_ascii_picture(pixels, symbols, dest_name, x_size, y_size):
    scale = 20 # number of pixels per character in the final picture
    border = 50 # size of the white border (in pixels)

    img = Image.new('L',
                    (x_size*scale + 2*border, 
                     y_size*scale + 2*border), 
                    255)
    fnt = ImageFont.truetype('DejaVuSansMono.ttf', int(scale*1.2))
    t = ImageDraw.Draw(img)

    x = border
    y = border

    for j in range(y_size):
        for i in range(x_size):
            t.text( (x, y),
                    symbols[int(pixels[j*x_size + i]/256 * len(symbols))],
                    font=fnt,
                    fill=0)
            x += scale
        x = border
        y += scale

    img.save(dest_name, "JPEG")

