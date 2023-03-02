#!/usr/bin/env python 
# -*- coding: utf-8 -*-

# Changelog 
# 2013-06-04 Jesus Andres Ferrer
#  - Class generated 
# 2013-06-06 Jesus Andres Ferrer
#  - fixed errors

import sys,re,string
import fileinput
from NumberToSpokenTxtEs import *

if __name__ == "__main__":
    n2spen = NumberToSpokenTxtEs()
    number=re.compile(r"^([[:space:]]+)?-?(\d*)((\.|,)\d+)?\b$");
    for sentence in fileinput.input():
        out="";
        for word in sentence.split():
            if number.match(word):
                out+=n2spen.convert(word);
            else:
                out+= " "+word;
        print out.strip();


