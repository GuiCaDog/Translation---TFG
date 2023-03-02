#!/usr/bin/env python 
# -*- coding: utf-8 -*-

# Changelog 
# 2013-06-04 Jesus Andres Ferrer
#  - Class generated 

import sys,re,string
import fileinput
from NumberToSpokenTxtCa import *

if __name__ == "__main__":
    n2spen = NumberToSpokenTxtCa()
    number=re.compile(r"^([[:space:]]+)?-?(\d*)((\.|,)\d+)?\b$");
    #number=re.compile(r"^([[:space:]]+)?-?(\d*)((\.|,)\d+)?(\.|,)?\b$");
    for sentence in fileinput.input():
        out="";
        for word in sentence.split():
            #print "<{}> {} ".format(word,number.match(word));
            
            if number.match(word):
                #out+=" _NUM_"
                word=word.replace(",",".");
                out+=n2spen.convert(word);
            else:
                out+= " "+word;
        print out.strip();


