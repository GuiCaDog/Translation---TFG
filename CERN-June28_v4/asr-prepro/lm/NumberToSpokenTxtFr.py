#!/usr/bin/env python 
# -*- coding: utf-8 -*-

import sys,re,string
import fileinput


class NumberToSpokenTxtFr:
    def __init__(self):
        self.ones=[""," un", " deux", " trois", " quatre" ," cinq", " six" ," sept", " huit", " neuf",
                   " dix", " onze", " douze", " treize", " quatorze", " quinze", " seize", " dix-sept", " dix-huit", " dix-neuf" ]; # 
        self.tens=["", "", " vingt", " trente", " quarante", " cinquante", " soixante" ];
        self.miles=[ "", " mille"];
        ## FALTA EL MILLIARDO !!! =(
        self.llones=[ "",  " millions", " billions", " trillions", " quatrillions", " quintillions" ];
        self.llones1=[ "", " million", " billion", " trillion", " quatrillion", " quintillion" ];
    def convertTri(self,num,mil=0,llon=0,right=0):
        #  
        a=int(num)/1000;
        rr=int(num)%1000;
        b=(int(num)/100)%10;
        c=num%100; 
        out=""; 
        if (b > 0):
            if b==1: out= ' cent'
            else:    out= self.ones[b] + (' cents' if c==0 else ' cent')
        if (c < 20):
            if ( mil == 0 and llon==0 ): out = out+self.ones[c]; 
            else:
                if mil==1 and c==1 and out=="": 
                    out = out+" mille";
                else:
                    out = out+self.ones[c];
        elif c<70:
            out+= self.tens[c/10]
            tmp= c%10
            if tmp==1:   out+= ' et un'
            elif tmp!=0: out+= '-'+self.ones[tmp][1:]
        elif c<80:
            tmp= c%10
            if tmp==1: out+= ' soixante et onze'
            else:      out+= ' soixante-'+self.ones[tmp+10][1:]
        elif c==80:
            out+= ' quatre-vingts'
        else:
            out+= ' quatre-vingt-'+self.ones[c%20][1:]
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
        if (num < 0 ):  out = " moins"+self.convertTri(-num);
        elif (num==0): out = " zéro";
        else: out=self.convertTri(num);

        if ( len(parts) == 2 and len(parts[1])>36 ): return " NUM<{}>".format(number);

        if ( len(parts) == 1 ): return out;
        else:
            right=parts[1];
            if ( ( len( right.split('E') )>1 ) or ( len( right.split('e') )>1 ) ):
                return " NUM<{}>".format(snumber);
            r=int(right);
            if snumber.find(",")>=0:
                infix=" virgule";
            else:
                infix=" point";
                
            if (r==0): return out+infix+" zéro";
            else:      return out+infix+self.convertTri(int(r));

if __name__ == "__main__":
    n2spen = NumberToSpokenTxtFr() 
    
    nums = [ "0", "1", "21", "31", "200","300","201","301","211","311","221","331","221972","341219","74211221",
             "741211221","1000001",
             "1000000000000","19876543212121",  "888999999999198765432121216543212121",
             "-17.378","21.345","32,457", "27153043797268594724521016708503331078688082431255827492661812611709902401961251089237571968441228355796675724502153879044401055376990858706861576744716750777540716813569449491519565615982921543007305512813672467715956357831002867169854178545645186483443829294949757214281676231871722101411186433884745541235861865432824865550288222602", 
             "3.1415927", "3.1415926535897932384626433832795028841971693993751",  "0.12345", "0.0001100110011001100110011001100110011001100110011"];
    #nums = [ "0.2532", "0.0001100110011001100110011001100110011001100110011" ]

    for n in nums: 
        print "{} {}".format(n,n2spen.convert(n));
