#!/usr/bin/env python 
# -*- coding: utf-8 -*-

# Changelog 
# 2013-06-04 Jesus Andres Ferrer
#  - Class generated 
# 2013-06-06 Jesus Andres Ferrer
#  - fixed errors
# 2013-06-10 Jesus Andres Ferrer
#  - Added the , as a possible separator for english, it is used for separating mil(,->"")


import sys,re,string
import fileinput


class NumberToSpokenTxtEn:
    def __init__(self):
        self.ones=[""," one", " two", " three", " four" ," five", " six" ," seven", " eight", " nine", \
                " ten", " eleven", " twelve", " thirteen", " fourteen", " fifteen", " sixteen", " seventeen", " eighteen", " nineteen" ];
        self.tens=["", "", " twenty", " thirty", " forty", " fifty", " sixty", " seventy", " eighty"," ninety" ];
        self.trip=[ "", " thousand", " million", " billion", " trillion", " quadrillion", " quintillion", " sextillion", " septillion", " octillion",  "nonillion" ];
    def convertTri(self,num,tri=0):
        #  
        a=int(num)/1000;
        b=(int(num)/100)%10;
        c=num%100; 
        out=""; 
        if (b > 0):
            out= self.ones[b]+" hundred";
        if (c < 20):
            out = out+self.ones[c];
        else:
            out = out + self.tens[ int(c/10) ] + self.ones[c%10];
        if (out != ""):
            out = out + self.trip[tri];

        if (a>0):
            return self.convertTri(a,tri+1) + out;
        else: 
            return out;

    def convert(self,snumber):
        tmp=snumber.replace(",","");
        try:
            number=float(tmp); 
            num=int(number);
        except:
            return " NUM<{}>".format(tmp)
        remainder=number-num;
        out = ""
        if (num>999999999999999999999999999999999): return " <NUM_{}>".format(num);
        if (-num>999999999999999999999999999999999): return " <NUM_{}>".format(num);
        if (num <0 ):  out = " minus"+self.convertTri(-num);
        elif (num==0): out = " zero";
        else: out=self.convertTri(num);

        parts=tmp.split('.')

        if ( len(parts) == 2 and len(parts[1])>36 ): return " NUM<{}>".format(number);

        if ( len(parts) == 1 ): return out;

        #if (remainder == 0): return out;
        else:
            right=snumber.split('.')[1];
            if ( ( len( right.split('E') )>1 ) or ( len( right.split('e') )>1 ) ):
                return " <NUM_{}>".format(snumber);
            r=int(right);
            return out+" point"+self.convertTri(int(r));

if __name__ == "__main__":
    n2spen = NumberToSpokenTxtEn() 

    #nums=[ "0", "-1" , "7", "17","21","221","2121","21000","21987654","999999999999999999999999999999999",
    #                                               "1000000000000000000000000000000000",
    #       "-21.345","21.3459","32,001"];
    nums = [ "0", "1", "21", "31", "200","300","201","301","211","311","221","331","221972","341219","74211221",
             "741211221","1000001",
             "1000000000000","19876543212121",  "888999999999198765432121216543212121",
             "-17.378","21.345","32,457", "27153043797268594724521016708503331078688082431255827492661812611709902401961251089237571968441228355796675724502153879044401055376990858706861576744716750777540716813569449491519565615982921543007305512813672467715956357831002867169854178545645186483443829294949757214281676231871722101411186433884745541235861865432824865550288222602", 
             "3.1415927", "3.1415926535897932384626433832795028841971693993751",  "0.12345", "0.0001100110011001100110011001100110011001100110011"];

    for n in nums: 
        print "{} {}".format(n,n2spen.convert(n));



