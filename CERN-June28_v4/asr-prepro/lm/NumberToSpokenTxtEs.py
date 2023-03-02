#!/usr/bin/env python 
# -*- coding: utf-8 -*-

# Changelog 
# 2013-06-04 Jesus Andres Ferrer
#  - Class generated 
# 2013-06-06 Jesus Andres Ferrer
#  - fixed errors


import sys,re,string
import fileinput


class NumberToSpokenTxtEs:
    def __init__(self):
        self.cientos=[""," ", " doscientos", " trescientos", " cuatrocientos" ," quinientos", " seiscientos" ," setecientos", " ochocientos", " novecientos", \
                " diez", " once", " doce", " trece", " catorce", " quince", " dieciséis", " diecisiete", " dieciocho", " diecinueve" ]; # 
        self.ones=[""," uno", " dos", " tres", " cuatro" ," cinco", " seis" ," siete", " ocho", " nueve", \
                " diez", " once", " doce", " trece", " catorce", " quince", " dieciséis", " diecisiete", " dieciocho", " diecinueve" ]; # 
        self.ones1=[""," un", " dos", " tres", " cuatro" ," cinco", " seis" ," siete", " ocho", " nueve", \
                " diez", " once", " doce", " trece", " catorce", " quince", " dieciséis", " diecisiete", " dieciocho", " diecinueve" ]; # 
        self.suffix=["","uno", "dós", "trés", "cuatro" ,"cinco", "seis" ,"siete", "ocho", "nueve" ];
        self.vsuffix=["","ún", "dós", "trés", "cuatro" ,"cinco", "seis" ,"siete", "ocho", "nueve" ];
        self.tens=["", "", " veint", " treinta", " cuarenta", " cincuenta", " sesenta", " setenta", " ochenta"," noventa" ];
        self.miles=[ "", " mil"];
        self.llones=[ "",  " millones", " billones", " trillones", " cuatrillones", " quintillones" ];
        self.llones1=[ "", " millón", " billón", " trillón", " cuatrillón", " quintillón" ];
    def convertTri(self,num,mil=0,llon=0,right=0):
        #  
        a=int(num)/1000;
        rr=int(num)%1000;
        b=(int(num)/100)%10;
        c=num%100; 
        out=""; 
        if (b > 0):
            if (b==1): 
                if( c == 0): out=" cien"; 
                else: out=" ciento";
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
            if (c == 20): out +="e";
            else: 
                if ( mil == 0 and llon==0): out += "i" + self.suffix[c%10];
                else:           out += "i" + self.vsuffix[c%10];
        else:
            if ( c%10 ==0 ): out = out + self.tens[ int(c/10) ];
            else:
                if ( mil == 0 and llon==0): 
                    out = out + self.tens[ int(c/10) ]+" y" + self.ones[c%10];
                else:            
                    out = out + self.tens[ int(c/10) ]+" y" + self.ones1[c%10];
        if (out != ""):
            #write miles if necessary
            if mil==1 and c==1 and b==0:
                pass;
            else:
                out = out + self.miles[mil];

            if mil == 1 and llon%2==1 and right == 0:
                out = out + self.llones [llon];
            #write millon 
            if (mil ==0):
                if ( (num == 1) and (a==0) ): out = out + self.llones1[llon];
                else:                         out = out + self.llones [llon];


        if (a>0):
            if (mil==1): 
                mil=0; 
                llon+=1;
            else: 
                mil+=1;
            return self.convertTri(a,mil,llon,right) + out;
        else: 
            return out;

    def convert(self,snumber):
        tmp=snumber.replace(",",".");

        try:
            number=float(tmp); 
            num=int(number);
        except:
            return " NUM<{}>".format(tmp)


        parts=tmp.split('.');
        out = ""
        if (num > 999999999999999999999999999999999999): return " NUM<{}>".format(num);
        if (-num > 999999999999999999999999999999999999): return " NUM<{}>".format(num);
        if (num < 0 ):  out = " menos"+self.convertTri(-num);
        elif (num==0): out = " cero";
        else: out=self.convertTri(num);

        if ( len(parts) == 2 and len(parts[1])>36 ): return " NUM<{}>".format(number);

        if ( len(parts) == 1 ): return out;
        else:
            right=parts[1];
            if ( ( len( right.split('E') )>1 ) or ( len( right.split('e') )>1 ) ):
                return " NUM<{}>".format(snumber);
            r=int(right);
            if snumber.find(",")>=0:
                infix=" coma";
            else:
                infix=" punto";
                
            if (r==0): return out+infix+" cero";
            else:      return out+infix+self.convertTri(int(r));

if __name__ == "__main__":
    n2spen = NumberToSpokenTxtEs() 
    
    nums = [ "0", "1", "21", "31", "200","300","201","301","211","311","221","331","221972","341219","74211221",
             "741211221","1000001",
             "1000000000000","19876543212121",  "888999999999198765432121216543212121",
             "-17.378","21.345","32,457", "27153043797268594724521016708503331078688082431255827492661812611709902401961251089237571968441228355796675724502153879044401055376990858706861576744716750777540716813569449491519565615982921543007305512813672467715956357831002867169854178545645186483443829294949757214281676231871722101411186433884745541235861865432824865550288222602", 
             "3.1415927", "3.1415926535897932384626433832795028841971693993751",  "0.12345", "0.0001100110011001100110011001100110011001100110011"];
    #nums = [ "0.2532", "0.0001100110011001100110011001100110011001100110011" ]

    for n in nums: 
        print "{} {}".format(n,n2spen.convert(n));



