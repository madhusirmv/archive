#!/usr/bin/python

import sys

def fourchartolong (instr) :
    atobdict = {"\n": 0, "=":0, "A":0, "R":17, "i":34, "z":51, "B":1, "S":18, "j":35, "0":52, "C":2, "T":19, "k":36, "1":53, "D":3, "U":20, "l":37, "2":54, "E":4, "V":21, "m":38, "3":55, "F":5, "W":22, "n":39, "4":56, "G":6, "X":23, "o":40, "5":57, "H":7, "Y":24, "p":41, "6":58, "I":8, "Z":25, "q":42, "7":59, "J":9, "a":26, "r":43, "8":60, "K":10, "b":27, "s":44, "9":61, "L":11, "c":28, "t":45, "+":62, "M":12, "d":29, "u":46, "/":63, "N":13, "e":30, "v":47, "O":14, "f":31, "w":48, "P":15, "g":32, "x":49, "Q":16, "h":33, "y":50} 
    first = 0
    second = 0
    third = 0
    fourth = 0
    if(len(instr) == 4):
        if(atobdict.has_key(instr[3])):
            first = atobdict[instr[3]]
        if(atobdict.has_key(instr[2])):
            second = atobdict[instr[2]]
            second <<= 6
        if(atobdict.has_key(instr[1])):
            third = atobdict[instr[1]]
            third <<= 12
        if(atobdict.has_key(instr[0])):
            fourth = atobdict[instr[0]]
            fourth <<= 18
        return (long(first + second + third + fourth))
    elif(len(instr) == 3):
        if(atobdict.has_key(instr[2])):
            first = atobdict[instr[2]]
            first <<= 6
        if(atobdict.has_key(instr[1])):    
            second = atobdict[instr[1]]
            second <<= 12
        if(atobdict.has_key(instr[0])):    
            third = atobdict[instr[0]]
            third <<= 18
        return (long(first + second + third))
    elif(len(instr) == 2):
        if(atobdict.has_key(instr[1])):
            first = atobdict[instr[1]]
            first <<= 12
        if(atobdict.has_key(instr[0])):
            second = atobdict[instr[0]]
            second <<= 18
        return (long(first + second))
    elif (len(instr) == 1):
        if(atobdict.has_key(instr[0])):
            first = atobdict[instr[0]]
            first <<= 18
        return (long(first))
    else:
        return 0

def main():
    filein = sys.stdin.read()
    #sys.stdout.write(entirefile)
    #print "printing entire file"
    #print filein
    entirefile = filein.replace('\n', '')
    entirefile = entirefile.replace('=', '')
    #print "reprinting entire file"
    #print entirefile
    #sys.stdout.write(entirefile)
    i = 0
    length = len(entirefile)
    eightmask = 0b11111111
    
    while(i + 4 < length):
        frame = entirefile[i: i + 4]
        longframe = fourchartolong(frame)
        
        j = 2
        while(j >= 0):
            currbits = longframe >> (8 * j)
            eightbits = eightmask & currbits
            sys.stdout.write(chr(eightbits))
            j = j - 1
        i = i + 4
        
    frame = entirefile[i: length]
    #print i
    #print length
    longframe = fourchartolong(frame)
    j = 2
    length = length - i
    #print 4 - length
    while(j >= 4 - len(frame)):
        currbits = longframe >> (8 * j)
        eightbits = eightmask & currbits
        sys.stdout.write(chr(eightbits))
        j = j - 1

    #sys.stdout.write("\n")

if __name__ == '__main__':
    main()
