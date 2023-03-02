#!/usr/bin/env python 
# -*- coding: utf-8 -*-
# Write number, German edition, spiqueras

import sys, re, string
import fileinput

class NumberToSpokenTxtDe:
    def __init__(self):
        self.ones=["","eins", "zwei", "drei", "vier" ,"fünf", "sechs" ,"sieben", "acht", "neun",
                   "zehn", "elf", "zwölf", "dreizehn", "vierzehn", "fünfzehn", "sechzehn", "siebzehn", "achtzehn", "neunzehn"];
        self.tens=["", "", "zwanzig", "dreißig", "vierzig", "fünfzig", "sechzig", "siebzig", "achtzig", "neunzig"];
        self.llones=["tausend", " millionen ", " milliarden ", 
                                " billionen ", " billiarden ", 
                                " trillionen ", " trilliarden ", 
                                " quadrillionen ", " quadrilliarden ", 
                                " quintillionen ", " quintilliarden "];
        self.llones1=["tausend", " million ", " milliarde ",
                                 " billion ", " billiarde ",
                                 " trillion ", " trilliarde ",
                                 " quadrillion ", " quadrilliarde ",
                                 " quintillion ", " quintilliarde "];

    def convertTri(self, num, mil=0, llon=0, right=0):
        a = int(num)/1000;
        b = (int(num)/100)%10;
        c = num % 100; 
        out=""; 
        if b > 0:
            if b==1: out = "einhundert"
            else:    out = self.ones[b] + "hundert"
        if c < 20:
            out = out + self.ones[c];
        else:
            tmp = c%10
            if tmp == 1:   out += self.ones[tmp][:-1] + "und"
            elif tmp != 0: out += self.ones[tmp] + "und"
            out += self.tens[c/10]
        if out != "" and llon + mil > 0:
            if c == 1 and b == 0:
                if llon > 0:
                    out = out[:-1] + "e" + self.llones1[llon*2 + mil - 1];  # einE Million, einE Milliarde, etc.
                else: 
                    out = out[:-1] + self.llones1[llon*2 + mil - 1];  # eintausend
            else:   out = out + self.llones [llon*2 + mil - 1];

        if a > 0:
            if mil == 1:
                mil = 0; 
                llon += 1;
            else: 
                mil += 1;
            return self.convertTri(a, mil, llon, right) + out;
        else: 
            return out;

    def convert(self,snumber):
        tmp = snumber.replace(",",".");
        parts = tmp.split('.');
        if len(parts) > 2: return "NUM<{}>".format(snumber);
        try: 
            num = map(int, parts)[0];
        except:
            return "NUM<{}>".format(tmp)

        out = ""
        if (abs(num) > 999999999999999999999999999999999999):
            return "NUM<{}>".format(num);

        if (num < 0):  out = "minus " + self.convertTri(-num);
        elif (num==0): out = "null";
        else: out = self.convertTri(num);

        if len(parts) == 1: return out;

        if len(parts[1]) > 36: return "NUM<{}>".format(tmp);
        else:
            right = parts[1];
            if ( ( len( right.split('E') )>1 ) or ( len( right.split('e') )>1 ) ):
                return " NUM<{}>".format(snumber);
            r = int(right);
            infix = " Komma ";
                
            if (r==0): return out + infix + "null";
            else:      return out + infix + self.convertTri(r);


if __name__ == "__main__":
    n2spen = NumberToSpokenTxtDe() 
    if len(sys.argv) > 1:
        for n in sys.argv[1:]:
            print "{} {}".format(n,n2spen.convert(n))
        exit()
    
    nums = [ "0", "1", "21", "31", "200","300","201","301","211",
             "311","221","331","221972","341219","74211221",
             "741211221","1000001","1000000000000","19876543212121", 
             "888999999999198765432121216543212121","-17.378","21.345","32,457", "27153043797268594724521016708503331078688082431255827492661812611709902401961251089237571968441228355796675724502153879044401055376990858706861576744716750777540716813569449491519565615982921543007305512813672467715956357831002867169854178545645186483443829294949757214281676231871722101411186433884745541235861865432824865550288222602", 
             "3.1415927", "3.1415926535897932384626433832795028841971693993751",
             "0.12345", "0.0001100110011001100110011001100110011001100110011"];

    for n in nums:
        print "{} {}".format(n,n2spen.convert(n))
