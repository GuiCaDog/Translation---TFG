#!/usr/bin/env python 
# -*- coding: utf-8 -*

def number2text(n):
    # Useful: http://www.languagesandnumbers.com/how-to-count-in-slovene/en/slv/
    if n == 0:
        return u" nič"
    else:
        return u' '+trilions(n)

def units(n):
    if n == 1:
        return u"ena" 
    elif n == 2:
        return u"dve"
    elif n == 3:
        return u"tri"
    elif n == 4:
        return u"štiri"
    elif n == 5:
        return u"pet"
    elif n == 6:
        return u"šest"
    elif n == 7:
        return u"sedem"
    elif n == 8:
        return u"osem"
    elif n == 9:
        return u"devet"
    else:
        return u""

def tens(n):
    if n >= 10:
        if n == 10:
            return u"deset"
        elif n == 11:
            return u"enajst"
        elif n == 12:
            return u"dvanajst"
        elif n == 13:
            return u"trinajst"
        elif n == 14:
            return u"štirinajst"
        elif n == 15:
            return u"petnajst"
        elif n == 16:
            return u"šestnajst"
        elif n == 17:
            return u"sedemnajst"
        elif n == 18:
            return u"osemnajst"
        elif n == 19:
            return u"devetnajst"
        elif n == 20:
            return u"dvajset"
        elif n == 21:
            return u"enaindvajset" 
        elif n == 22:
            return u"dvaindvajset"
        elif n == 23:
            return u"triindvajset"
        elif n == 24:
            return u"štiriindvajset"
        elif n == 25:
            return u"petindvajset"
        elif n == 26:
            return u"šestindvajset"
        elif n == 27:
            return u"sedemindvajset"
        elif n == 28:
            return u"osemindvajset"
        elif n == 29:
            return u"devetindvajset"
        else:
            if n%10 > 0:
                return units(int(n%10)) + u"in" + units(int(n/10)) + u"deset"
            else:
                return units(int(n/10)) + u"deset"
    else:
        return units(n)

def hundreds(n):
    if n > 100:
        if int(n/100) == 1:
            return u"sto " + tens(int(n%100))
        else:
            return units(int(n/100)) + u"sto " + tens(int(n%100))
    elif n == 100:
        return u"sto"
    else:
        return tens(n)

def thousands(n):
    if n > 1000:
        if int(n/1000) == 1:
            return u"tisoč " + hundreds(int(n%1000))
        else:
            return hundreds(int(n/1000)) + u" tisoč " + hundreds(int(n%1000))
    elif n == 1000:
        return u"tisoč"
    else:
        return hundreds(n)

def milions(n):
    if n > 10**6:
        if int(n/10**6) == 1:
            return u"milijon " + thousands(int(n%10**6))
        elif int(n/10**6) == 2:
            return u"dva milijona " + thousands(int(n%10**6))
        else:
            return hundreds(int(n/10**6)) + u" milijonov " + thousands(int(n%10**6))
    elif n == 10**6:
        return u"milijon"
    else:
        return thousands(n)

def bilions(n):
    if n > 10**9:
        if int(n/10**9) == 1:
            return u"milijarda " + milions(int(n%10**9))
        else:
            return hundreds(int(n/10**9)) + u" milijardi " + milions(int(n%10**9))
    elif n == 10**9:
        return u"milijarda"
    else:
        return milions(n)

def trilions(n):
    if n > 10**12:
        if int(n/10**12) == 1:
            return u"bilijon " + bilions(int(n%10**12))
        else:
            return hundreds(int(n/10**12)) + u" bilijoni " + bilions(int(n%10**12))
    elif n == 10**12:
        return u"bilijon"
    else:
        return bilions(n)

class NumberToSpokenTxtSl:
    def __init__(self):
        pass
    def convert(self,snumber):
        tmp= snumber.replace(",",".")
        try:
            number= float(tmp); 
            num= int(number);
        except:
            return " NUM<{}>".format(tmp)
        
        if (num > 999999999999999999999999999999999999): return " NUM<{}>".format(num);
        if (-num > 999999999999999999999999999999999999): return " NUM<{}>".format(num);
        if (num < 0 ):  out = " vsaj "+number2text(num).encode('utf-8');
        else: out=number2text(num).encode('utf-8');
        parts=tmp.split('.');
        if ( len(parts) == 2 and len(parts[1])>36 ): return " NUM<{}>".format(number);
        
        if ( len(parts) == 1 ): return out;
        else:
            right=parts[1];
            if ( ( len( right.split('E') )>1 ) or ( len( right.split('e') )>1 ) ):
                return " NUM<{}>".format(snumber);
            r=int(right);
            infix=u" točka".encode('utf-8');

                
            if (r==0): return out+infix+" nič";
            else:      return out+infix+number2text(int(r));
