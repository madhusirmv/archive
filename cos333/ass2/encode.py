#!/usr/bin/python

import sys

def threechartolong (instr) :
    if(len(instr) == 3):
        first = ord(instr[2])
        second = ord(instr[1])
        second <<= 8
        third = ord(instr[0])
        third <<= 16
        return (long(first + second + third))
    elif(len(instr) == 2):
        first = ord(instr[1])
        first <<= 8
        second = ord(instr[0])
        second <<= 16
        return (long(first + second))
    elif(len(instr) == 1):
        first = ord(instr[0])
        first <<= 16
        return (long(first))
    else:
        return 0

def main():
    entirefile = sys.stdin.read()
    #print entirefile
    btoadict = {0:"A", 17:"R", 34:"i", 51:"z", 1:"B", 18:"S", 35:"j", 52:"0", 2:"C", 19:"T", 36:"k", 53:"1", 3:"D", 20:"U", 37:"l", 54:"2", 4:"E", 21:"V", 38:"m", 55:"3", 5:"F", 22:"W", 39:"n", 56:"4", 6:"G", 23:"X", 40:"o", 57:"5", 7:"H", 24:"Y", 41:"p", 58:"6", 8:"I", 25:"Z", 42:"q", 59:"7", 9:"J", 26:"a", 43:"r", 60:"8", 10:"K", 27:"b", 44:"s", 61:"9", 11:"L", 28:"c", 45:"t", 62:"+", 12:"M", 29:"d", 46:"u", 63:"/", 13:"N", 30:"e", 47:"v", 14:"O", 31:"f", 48:"w", 15:"P", 32:"g", 49:"x", 16:"Q", 33:"h", 50:"y"}
    sixmask = 0b111111
    
    i = 0
    charcount = 0
    
    length = len(entirefile)
    
    
    while(i + 3 < length):
        frame = entirefile[i: i + 3]
        longframe = threechartolong(frame)
        
        j = len(frame)
        while(j >= 0):
            currbits = longframe >> (6 * j)
            sixbits = sixmask & currbits
            sys.stdout.write(btoadict[int(sixbits)])
            j = j - 1
            charcount = charcount + 1
            if(charcount == 64):
                print
                charcount = 0
        i = i + 3
    frame = entirefile[i: length]
    if(length != 0):
        longframe = threechartolong(frame)
        j = 3
        while(j >= 3 - len(frame)):
            currbits = longframe >> (6 * j)
            sixbits = sixmask & currbits
            sys.stdout.write(btoadict[int(sixbits)])
            j = j - 1
            charcount = charcount + 1
            if(charcount == 64):
                sys.stdout.write("\n")
                charcount = 0
        
        if(len(frame) == 1):
            sys.stdout.write("=")
            charcount = charcount + 1
            if(charcount == 64):
                sys.stdout.write("\n")
                charcount = 0
            sys.stdout.write("=")
        elif(len(frame) == 2):
            sys.stdout.write("=")
        if(charcount != 0):    
            sys.stdout.write("\n")
    else:
        sys.stdout.write("")

if __name__ == '__main__':
    main()
