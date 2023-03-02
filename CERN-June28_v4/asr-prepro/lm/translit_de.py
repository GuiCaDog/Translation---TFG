#!/usr/bin/env python 
# -*- coding: utf-8 -*-

import sys,re,string
import fileinput
from NumberToSpokenTxtDe import *

if __name__ == "__main__":
  n2spen = NumberToSpokenTxtDe()
  number = re.compile(r"^([[:space:]]+)?-?(\d*)((\.|,)\d+)?\b$")
  for sentence in fileinput.input():
    print " ".join(n2spen.convert(w) if number.match(w) else w for w in sentence.split())
