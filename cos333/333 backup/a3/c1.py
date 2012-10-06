#!/usr/bin/python
import sys
def main():
    line = sys.stdin.readline()
    i = 0
    mylist = []
    while(line != ""):
        mytuple = ()
        try:
            [name, stat1str, stat2str, index] = line.split()
        except:
            line = sys.stdin.readline()
            continue
        stat1 = float(stat1str) * 1000
        stat2 = float(stat2str) * 1000
        length = len(name)
        rest = name[2: length]
        mytuple = (name, rest, stat1, stat2)
        mylist.append(mytuple)
        i = i + 1
        line = sys.stdin.readline()

    print i,
    sortedlist = mylist    
    lastname = ""
    for item in sortedlist:
        i = 0
        currname = item[0]
        while i < len(lastname) and i < len(currname) and lastname[i] == currname[i]:
            i = i + 1
        if i > 0:
            printname = currname[i:len(currname)]
            print "%d%s" % (i, printname),
        else:
            print currname,
        lastname = currname
    last = 0 
    for i in range(len(sortedlist)):
        item = sortedlist[i]
        if i == 0:
            firststat = item[3]
            print firststat,
            last = item[3]
            continue
        stat = item[3] - last
        stat = round(stat, 3)
        if stat == item[2]:
            print stat,
        if stat < item[2]:
            print "%d%s" % ( stat,"l"),
        if stat > item[2]:
            print "%d%s" % ( stat, "g"),
        last = item[3]
    index  
main()