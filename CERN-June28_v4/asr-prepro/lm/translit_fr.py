#!/usr/bin/env python 
# -*- coding: utf-8 -*-

import sys,re,string
import fileinput
from NumberToSpokenTxtFr import *

if __name__ == "__main__":
    n2spen = NumberToSpokenTxtFr()
    number=re.compile(r"^([[:space:]]+)?-?(\d*)((\.|,)\d+)?\b$");
    for sentence in fileinput.input():
        out="";
        for word in sentence.split():
            if number.match(word):
                out+=n2spen.convert(word);
            else:
                out+= " "+word;
        print out.strip();
