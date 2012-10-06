#!/usr/bin/python

#for use with sqltest.txt
import sys
import random

def main():
    
    line = sys.stdin.readline()

    mylist = []
    while(line != ""):
        
        line = line.strip()
        mylist.append(line)     
        line = sys.stdin.readline()
    
    mystring = ""
    
    for i in range(0, 1000):
        rand2 = random.randint(1, 3)
        mystring = ""
        for j in range(0, rand2):
            rand1 = random.randint(0, len(mylist) - 1)
            
            mystring = mystring + " " + mylist[rand1]
            
        print mystring
            
main()
            