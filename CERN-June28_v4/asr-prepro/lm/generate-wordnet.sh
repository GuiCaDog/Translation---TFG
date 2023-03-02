#!/bin/bash

# De Nico

awk 'BEGIN{j=0; s[j++]="SP"}
  {
    for(i=1;i<=NF;i++) 
    { 
      s[j++]=$i; s[j++]="SP";
    }
  } 
  END{
    #print header
    printf("VERSION=1.0\n");
    printf("N=%d L=%d\n",j+2,((j-1)/2-0.5)+((j-1)/2-1.5)*2+7);

    #print nodes
    printf("I=0 W=<s>\n");
    for(i=0;i<j;i++) 
      printf("I=%d W=%s\n",i+1,s[i])
    printf("I=%d W=</s>\n",j+1);

    #print edges
    n=0;
    printf("J=%d S=0 E=1 l=0.0\n",n++);
    printf("J=%d S=0 E=2 l=0.0\n",n++);
    printf("J=%d S=1 E=2 l=0.0\n",n++);
    for(i=1;i<j;i+=2) 
    {
      printf("J=%d S=%d E=%d l=0.0\n",n++,i+1,i+2);
      printf("J=%d S=%d E=%d l=0.0\n",n++,i+1,i+3);
      printf("J=%d S=%d E=%d l=0.0\n",n++,i+2,i+3);
    }
  }'
