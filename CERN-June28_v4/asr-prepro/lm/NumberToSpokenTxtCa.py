#!/usr/bin/env python 
# -*- coding: utf-8 -*-

# Changelog 
# 2013-06-04 Jesus Andres Ferrer
#  - Class generated 
# 2013-06-06 Adria A. Martinez Villaronga
#  - Modifications for catalan transliterator

import sys,re,string
import fileinput


class NumberToSpokenTxtCa:
    def __init__(self):
        self.cientos=[""," ", " dos-cents", " tres-cents", " quatre-cents" ," cinc-cents", " sis-cents" ," set-cents", " huit-cents", " nou-cents", \
                " deu", " onze", " dotze", " tretze", " catorze", " quinze", " setze", " dèsset", " dihuit", " dèneu" ];  
        self.ones=[""," u", " dos", " tres", " quatre" ," cinc", " sis" ," set", " huit", " nou", \
                 " deu", " onze", " dotze", " tretze", " catorze", " quinze", " setze", " dèsset", " dihuit", " dèneu" ]; 
        self.ones1=[""," un", " dos", " tres", " quatre" ," cinc", " sis" ," set", " huit", " nou", \
                 " deu", " onze", " dotze", " tretze", " catorze", " quinze", " setze", " dèsset", " dihuit", " dèneu" ]; 
        self.tens=["", "", " vint", " trenta", " quaranta", " cinquanta", " seixanta", " setanta", " huitanta"," noranta" ];
        self.miles=[ "", " mil"];
        self.llones=[ "",  " milions", " bilions", " trilions", " quatrilions", " quintilions" ];
        self.llones1=[ "", " milió", " bilió", " trilió", " quatrilió", " quintilió" ];
    def convertTri(self,num,mil=0,llon=0, right=0):
        a=int(num)/1000;
        rr=int(num)%1000;
        b=(int(num)/100)%10;
        c=num%100; 
        out=""; 
        if (b > 0):
            if (b==1): 
                if( c == 0): out=" cent";
                else: out=" cent"; 
            else:
                out= self.cientos[b];
        if (c < 20):
            if ( mil == 0 and llon==0 ): out = out+self.ones[c]; 
            else:   
                if mil==1 and c==1 and out=="": 
                    out = out+" mil";
                else:
                    out = out+self.ones1[c];

        elif (c<30):
            out +=self.tens[2];
            if (c != 20):
                if ( mil == 0 and llon==0): out += "-i-" + self.ones[c%10][1:];
                else:            out += "-i-"+self.ones1[c%10][1:];
        else:
            if ( c%10 == 0 ) : sep=""
            else: sep="-"
            if ( mil == 0 and llon==0): out = out + self.tens[ int(c/10) ]+sep + self.ones[c%10][1:];
            else:
                out = out + self.tens[ int(c/10) ]+sep + self.ones1[c%10][1:];
        if (out != ""):
            #write miles if necessary
            if mil==1 and c==1 and b==0:
                pass;
            else:
                out = out + self.miles[mil];

            if mil==1 and llon%2==1 and right == 0:
                out=out+self.llones[llon];
            #write milio
            if (mil==0):
                if ( (num==1) and (a==0) ):  out = out + self.llones1[llon];
                else:  out = out + self.llones[llon];



        if (a>0):
            if (mil==1): 
                mil=0; 
                llon+=1;
            else: 
                mil+=1;
            return self.convertTri(a,mil,llon, rr) + out;
        else: 
            return out;

    def convert(self,snumber):
        number=float(snumber); 
        num= int(number);
        remainder=number-num;
        out = ""
        if (num> 999999999999999999999999999999999999): return " NUM<{}>".format(num);
        if (-num>999999999999999999999999999999999999): return " NUM<{}>".format(num);
        if (num <0 ):  out = " menys"+self.convertTri(-num);
        elif (num==0): out = " zero";
        else: out=self.convertTri(num);
        remainder=float(number)-int(number);
        if (remainder == 0): return out;
        else:
            right=snumber.split('.')[1];
            if ( ( len( right.split('E') )>1 ) or ( len( right.split('e') )>1 ) ):
                return " NUM<{}>".format(snumber);
            r=int(right);
            return out+" coma"+self.convertTri(int(r));

if __name__ == "__main__":
    n2spen = NumberToSpokenTxtCa() 
    
    nums = [ 0, 1, 21, 31, 200,300,201,301,211,311,221,331,221972,341219,74211221,
             741211221,1000001,
             1000000000000,19876543212121,  888999999999198765432121216543212121,
             -17.378,21.345];
    for n in nums: 
        print "{} {}".format(n,n2spen.convert(str(n)));



