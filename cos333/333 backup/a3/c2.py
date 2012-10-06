#!/usr/bin/python
import sys
from time import mktime
def main():
    mondict = {"Jan":1 , "Feb":2 , "Mar":3 , "Apr":4 , "May": 5, "Jun":6, "Jul":7, "Aug":8 , "Sep": 9, "Oct":10, "Nov":11, "Dec":12}
    tzdict = {"EDT":0, "EST":1}
    line = sys.stdin.readline()
    i = 0
    mylist = []
    while(line != ""):
        mytuple = ()
        try:
            [rank, day, mon, dn, time, tz, yr] = line.split()
        except:
            line = sys.stdin.readline()
            continue
        rank = rank.replace(',', '')
        [hr, minute, sec] = time.split(":")
        tzcode = tzdict[tz]
        moncode = mondict[mon]
        yrcode = int(yr) #- 2000
        hr = int(hr)
        dn = int(dn)
        minute = int(minute)
        sec = int(sec)
        rank = int(rank)
        i = int(i) 
        time = long(mktime((yrcode, moncode, dn, hr, minute, sec, 0, 0, 0))) 
        if i == 0:
            firsttime = time - 992524082
            print firsttime,
            firstrank = rank
            print firstrank,
        mytuple = (tzcode, time, rank, tzcode)
        mylist.append(mytuple)
        i = i + 1
        line = sys.stdin.readline()
    sortedlist = mylist
    print i,
    lasttime = 0
    lasttzcode = 0
    for i in range(len(sortedlist)):
        item2 = sortedlist[i]    
        (tz2, time2, rank2, tzcode) = item2
        time = time2 - lasttime - 3600
        if tzcode == lasttzcode:
            print str(time),
            lasttzcode = tzcode
        else:
            print "%d%s" % ( time, "s"),
            lasttzcode = tzcode
        lasttime = time2
    lastrank= 0
    for item2 in sortedlist:
        (tz2, time2, rank2, tzcode) = item2
        rank = rank2 - lastrank
        print rank,
        lastrank = rank2
    day
    tz2
main()
