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
    #sortedlist = sorted(mylist, key=lambda row: row[0])   
    sortedlist = mylist
    print i,
    #j = 0
    #past = 0
    #switch = 0
    #for item in sortedlist:
    #    (tz2, time2, rank2) = item
    #    if tz2 == 1 and past == 0:
    #        switch = j
    #    past = tz2
    #    j = j + 1
    #print switch,
    lasttime = 0
    lasttzcode = 0
    for i in range(len(sortedlist)):
        item2 = sortedlist[i]    
        (tz2, time2, rank2, tzcode) = item2
        #print "time2 = " + str(time2) + " lasttime = " + str(lasttime)
        time = time2 - lasttime - 3600
        #time3 = None
        #if (i + 1 < len(sortedlist)):
        #    item3 = sortedlist[i+1]
        #    time3 = item3[1]
        #    time3 = time3 - time2 -3600
        #lasttime = time2
        #print "time = " + str(time)
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
main()
