#!/usr/bin/python
import sys
def main():
    entirefile = sys.stdin.read()
    parsedfile = entirefile.split()
    length = long(parsedfile[0])
    firststat = parsedfile[length + 1]
    mylist = []
    lastname = ""
    partname = ""
    fullname = ""
    laststat = 0
    shared = 0
    for i in range(length):
        rawname = parsedfile[i+1]
        if len(rawname) >= 2 and rawname[0:2].isdigit():
            shared = int(rawname[0:2])
            partname = rawname[2:len(rawname) ]
        elif rawname[0].isdigit():
            shared = int(rawname[0])
            partname = rawname[1:len(rawname)]
        else:
            shared = 0
            partname = rawname
        if shared > 0:
            fullname = lastname[0:shared] + partname
        else:
            fullname = partname
        lastname = fullname 
        rawstat = parsedfile[1 + length + i]
        if rawstat[len(rawstat) -1 ] == "g":
            fullstat = float(rawstat[0:len(rawstat) - 1])
            code = "g"
        elif rawstat[len(rawstat) -1 ] == "l":
            fullstat = float(rawstat[0:len(rawstat) - 1])
            code = "l"
        else:
            fullstat = float(rawstat)
            code = ""
        if i == 0:
            stat2 = float(firststat)
            stat1 = float(firststat)
        else:
            stat2 = float(fullstat) + float(laststat)
            if code == "g":
                stat1 = float(fullstat) - 1
            elif code == "l":
                stat1 = float(fullstat) + 1
            else:
                stat1 = float(fullstat)
        laststat = float(stat2)
        stat1 = stat1/1000.0
        stat2 = stat2/1000.0
        mytuple = (fullname, stat1, stat2, i +1)
        mylist.append(mytuple)
    for item in mylist:
        (name, stat1, stat2,index) = item
        print "%-13s %6.3f %6.3f %6d" % (name, stat1, stat2, index)
main()  