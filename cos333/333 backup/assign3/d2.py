#!/usr/bin/python
import sys
import time
# from http://snippets.dzone.com/posts/show/584
def group(n, sep = ','):
    s = str(n)[::-1]
    groups = []
    i = 0
    while i < len(s):
        groups.append(s[i:i+3])
        i += 3
    return sep.join(groups)[::-1]
def main():
    tzdict = {0: "EDT",1 : "EST"}
    entirefile = sys.stdin.read()
    parsedfile = entirefile.split()
    firsttime = long(parsedfile[0]) + 992524082
    firstrank = long(parsedfile[1])
    length = int(parsedfile[2])
    i = 0
    lasttime = 0
    lasttzcode = 0
    lastrank = 0
    mylist = []
    tz = 0
    while i < length:
        mytimestr = parsedfile[i + 3]
        lentimestr = len(mytimestr)
        if mytimestr[lentimestr - 1] == "s":
            rawtime = long(mytimestr[0:lentimestr-1])
            if lasttzcode == 0:
                tz = 1
            else:
                tz = 0
        else:
            rawtime = long(mytimestr[0:lentimestr]) 
        if i == 0:
            mytime = firsttime - 3600
            rank = firstrank
        else:
            mytime = 3600 + lasttime + rawtime
        rank = int(parsedfile[i + 3 + length]) + lastrank
        mytuple = (tz, mytime, rank)
        mylist.append((mytuple))
        lasttime = mytime
        lastrank = rank
        lasttzcode = tz
        i = i + 1
    sortedlist = mylist
    for item in sortedlist:
        time1 = item[1]
        if item[0] == 1:
            time1 = time1 + 3600
        timestring = time.ctime(time1)
        tstuple = timestring.split()
        tzstring = tzdict[int(item[0])] 
        myrank = group(item[2])
        print "%s\t%s %s %s %s %s %s\n" % (myrank, tstuple[0], tstuple[1], tstuple[2], tstuple[3],tzstring, tstuple[4]),
main()
