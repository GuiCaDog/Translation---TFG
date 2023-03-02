#!/usr/bin/env python 
# -*- coding: utf-8 -*-

import sys,re, string

lines=sys.stdin
pronoms=["i","you","she","he","it","we","they","can","won","shouldn","isn","hasn","haven","wouldn"];
contractions=["s","ll","re","d","ve","m","t"];
special_contractions=["s","t"];
notok_contractions=["'s","'ll","'re","'d","'ve","'m","'t","’s","’ll","’re","’d","’ve","’m","’t"];
debug=0
#debug=20
l=string.punctuation+"“”—£•�–…"
ll=string.punctuation+"0123456789"
table=string.maketrans("","");
l2=l.translate(table,"'");

def is_word_accent(w):
    if( (w=="'") or (w=="’")):
        return True;
    return False;

def is_word_number(w):
    w2=w.translate(table,ll); 
    if (len(w2)>0): 
        return False
    else:
        if ((debug>0)and (len(w2)==1)):
            print "<<< {} >>>".format(w2)
        return True

def is_word_punct(w):
    w2=w.translate(table,l); 
    if (len(w2)>0): 
        return False
    else:
        return True
    
def print_word(w):
    if (debug>20):
        print " printing word : <{}> ".format(w);
#    if ( not is_word_number(w) and not is_word_punct(w) ):
    if ( not is_word_punct(w) ):
        print w.lower(),

def print_words_app(w,w2):
    if (debug>20):
        print " printing word : <{}> ".format(w);
    if ( not is_word_number(w) and not is_word_punct(w) ):
        if ( not is_word_number(w2) and not is_word_punct(w2) ):
                print "{}'{}".format(w.lower(),w2.lower()),
        else:
            print w.lower(),
    else:
        if ( not is_word_number(w2) and not is_word_punct(w2) ):
            print w2.lower(),
    

def join_accents(s):
    prev=""; pprev=""; count=0;
    for word in s.split():
        count=count+1;
        if(debug>10):
            print "[[ pprev={} prev={} word={}".format(pprev,prev,word);
        if ( is_word_accent(prev) ):
            if( pprev.lower() in pronoms):
                if(word.lower() in contractions):
                    if (not ( (pprev.lower()=="i") and (word.lower()=="s") )):
                        if (debug>0):
                            print "******",
                        print "{}'{}".format(pprev.lower(),word.lower()),
                        pprev=prev="";
                        continue;
                    print_word(pprev),                   
                else:
                    print_word(pprev),
            elif (word.lower() in special_contractions):
                if (debug>0): print "++++++",
                print "{}'{}".format(pprev.lower(),word.lower()),
                pprev=prev="";
                continue;
            elif (pprev=="o"): # For strange names like:  o ' brian
                print "{}'{}".format(pprev.lower(),word.lower()),
                pprev=prev="";
                continue;
            else:
                print_word(pprev),
        elif (prev in notok_contractions):
            if (debug>0):
                print "-------",
            p=unicode(prev);
            if(p[0]==u'’'):
                p="'"+p[1:]
            else:
                p=prev;
            print "{}{}".format(pprev.lower(),p.lower()),
            pprev=""; 
            prev=word;
            continue;
        else:
            print_word(pprev),
        pprev=prev;
        if( is_word_accent(word) ):
            prev="'"
        else:
            prev=word;
        if(debug>10):
            print " ]] pprev={} prev={} word={}".format(pprev,prev,word);

    if( pprev!="" ):
        if (prev in notok_contractions):
            if (debug>0):
                print "-------",
            p=unicode(prev);
            if(p[0]==u'’'):
                p="'"+p[1:]
            else:
                p=prev;
            print "{}{}".format(pprev.lower(),p.lower()),
            pprev=""; 
        else:
            print_word(pprev),
            print_word(prev),
    else:
        if( prev!="" ):
            print_word(prev),
    print ""



if __name__ == "__main__":
    while 1:
        s=lines.readline();
        if s == "":
            break;
        join_accents(s);
