#!/usr/bin/env python 
# -*- coding: utf-8 -*-

#Transcribe aceptablemente hasta miles de millones
import sys,re,string
import fileinput


class NumberToSpokenTxtEt:
    def __init__(self):
        self.ones=[""," üks", " kaks", " kolm", " neli" ," viis", " kuus" ," seitse", " kaheksa", " üheksa", \
            " kümme", " üksteist", " kaksteist", " kolmteist", " neliteist", " viisteist", " kuusteist", " seitseteist", " kaheksateist", " üheksateist" ]; # 
        self.prefix=[""," ", " kaks", " kolm", " neli" ," viis", " kuus" ," seitse", " kaheksa", " üheksa" ];
    def convertTri(self,num,mil=0):
        a=(int(num)/1000);
        b=(int(num)/100)%10;
        c=(int(num)/10)%10;
        d=(num%10);
        out=""; 
        point="";
        if(mil == 0):
          if(a%1000) != 0:
            point = " tuhat"
          else:
            point = ""
        elif(mil == 1):
          if(a%1000) != 0:
            point = " miljon"
          else:
            point = ""
        elif(mil == 2):
          if(a%1000) != 0:
            point = " miljard"
          else:
            point = ""

        if (a > 9):
          return self.convertTri(num/1000,mil+1)+point+self.convertTri(num%1000,mil)
        if (mil <= 0):
          if (a > 0):
            out=out+self.prefix[a]+" tuhat"
        else:
          if (a > 0):
            if (mil==1):
              out=out+self.prefix[a]+" miljon"
            else:
              out=out+self.prefix[a]+" miljard"
        if (b > 0):
          out=out+self.prefix[b]+"sada"
        if (c <= 1):
          out=out+self.ones[c*10+d]
        else:
          out=out+self.prefix[c]+" kümmend"
        if (int(num) == 0):
          out = "null"
        elif (c >= 2):
          out=out+self.ones[d]
        return out

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
        if (num < 0 ):  out = " vähemalt"+self.convertTri(-num);
        elif (num==0): out = " null";
        else: out=self.convertTri(num);

        if ( len(parts) == 2 and len(parts[1])>36 ): return " NUM<{}>".format(number);

        if ( len(parts) == 1 ): return out;
        else:
            right=parts[1];
            if ( ( len( right.split('E') )>1 ) or ( len( right.split('e') )>1 ) ):
                return " NUM<{}>".format(snumber);
            r=int(right);
            if snumber.find(",")>=0:
                infix=" koma";
            else:
                infix=" punkti";
                
            if (r==0): return out+infix+" null";
            else:      return out+infix+self.convertTri(int(r));

if __name__ == "__main__":
    n2spen = NumberToSpokenTxtEt() 
    
    nums = [ "0", "1", "21", "31", "100", "157", "200","300","201","301","211","311","221","331","1002", "3541", "22239", "542210", "1235015", "3000001", "50213223", "220003040", "1733450581", "3000010001", 
        "0,23", "21.3"];

    for n in nums: 
        print "{} {}".format(n,n2spen.convert(n));
