#!/usr/bin/env python
from os import environ
import sys
import re
from MySQLdb import connect
from MySQLdb import cursors

def printrow(row):
    (dept, coursenum, area, days, starttime, endtime, bldg, roomnum, title, profname) = row
    starttime = starttime.replace(" PM", "")
    starttime = starttime.replace(" AM", "")
    endtime = endtime.replace(" PM", "")
    endtime = endtime.replace(" AM", "")
    print "%3s %2s %2s %s %s-%s %s %s %s %s" % (dept, coursenum, area, days, starttime, endtime, bldg, roomnum, title, profname)

def main():
        HOST = 'publicdb.cs.princeton.edu'
        PORT = 3306
        DATABASE = 'cos333'
        USER = 'cos333'
        PASSWORD = 'cos333'
        distcodes = ("la" , "sa" , "ha", "em", "ec" , "qr" , "st" , "stx")
        daycodes = ("m" , "t" , "w", "th" , "f", "mw" , "mwf" , "tth", "mtwthf")
        regexplist = []
        printall = False
        printnone = False
        hasdist = False
        hasday = False
        hascoursenumber = False
        hasdept = False
        coursenumber = None
        daycode = None
        department = None
        distcode = None
        hasregexp = False
        
        if len(sys.argv) == 1:
            printall = True


        #Override the host if DB_SERVER_HOST is set
        host = HOST
        if 'DB_SERVER_HOST' in environ:
                host = environ['DB_SERVER_HOST']

        i = 0
        #print sys.argv
        for args in sys.argv:
            #print "arg = " + args
            if i == 0:
                i = i + 1
                continue
            lowerargs = (sys.argv)[i].lower()
            #print "lower args = " + lowerargs
            if lowerargs in distcodes:
                if hasdist is False and distcode != lowerargs:
                    distcode = lowerargs
                    hasdist = True
                    i = i + 1
                    continue
                else:
                    printnone = True
            if lowerargs in daycodes:
                if hasday is False and daycode != lowerargs:
                    daycode = lowerargs
                    #print "daycode = " + daycode
                    hasday = True
                    i = i + 1
                    continue
                else:
                    printnone = True
            if len(lowerargs) == 3 and lowerargs[0:3].isdigit():
                if hascoursenumber is False and coursenumber != lowerargs[0:3]:
                    coursenumber = lowerargs[0:3]
                    hascoursenumber = True
                    #print "has cn " + lowerargs
                    i = i + 1
                    continue
                else:
                    printnone = True
            if len(lowerargs) == 3 and lowerargs.isalpha():
                
                if hasdept is False and department != lowerargs:
                    department = lowerargs
                    hasdept = True
                    #print "has dept = " + lowerargs
                    i = i + 1
                    continue
                else:
                    printnone = True
            if len(lowerargs) > 3:
                regexplist.append((sys.argv)[i])
                hasregexp = True
                i = i + 1
                continue
            if len(lowerargs) == 1 or len(lowerargs) == 2 or len(lowerargs) == 3:
                printnone = True
                i = i + 1
                continue
            i = i + 1
        connection = connect(host=host, port=PORT, user=USER, passwd=PASSWORD, db=DATABASE)
        cursor = connection.cursor()#cursors.DictCursor)
        #                         0   1          2     3        4          5     6     7         8     9
        cursor.execute('select dept, coursenum, area, days, starttime, endtime, bldg, roomnum, title, profname from classes as a, courses as b, crosslistings as c, coursesprofs as d, profs as e where a.courseid = b.courseid and b.courseid = c.courseid and c.courseid = d.courseid and d.profid = e.profid')

        row = cursor.fetchone()
        while row:
                if printnone:
                    row = cursor.fetchone()
                    continue
                if printall:
                    printrow(row)

                    row = cursor.fetchone()
                    continue
                if hasdist:
                    lowerdist = row[2].lower()
                    #print "has dist = " + lowerdist + " **********#"
                    if distcode != lowerdist:
                        row = cursor.fetchone()
                        continue

                if hasday:
                    lowerday = row[3].lower()
                    #print "hasday " + lowerday + "     ****************"
                    if daycode != lowerday:
                        row = cursor.fetchone()
                        continue

                if hascoursenumber:
                    #print " has cn " + coursenumber + "     ******************* "
                    cn = row[1]
                    if cn[0:3] != coursenumber:
                        row = cursor.fetchone()
                        continue

                if hasdept:
                    dept = row[0]
                    #print "has dept " + dept + "*********8"
                    if dept.lower() != department:
                        row = cursor.fetchone()
                        continue
                    ###################################### WORK ON THIS #####################    
                if hasregexp:
                    #print "has regexp  ****************"
                    allregmatched = True
                    for regexp in regexplist:
                        currregmatched = False
                        for field in row:
                            #restr = ".*" + regexp + ".*"
                            regularexp = re.compile(regexp, re.IGNORECASE)
                            match = re.search(regularexp, field)
                            #print "pre regexp = " + regexp +" field = " +  field
                            if match != None and match:
                                currregmatched = True
                                #print "regexp = "+ "\"" + restr +"\"" " field = " + field + " match = " + str(match)
                        allregmatched = allregmatched and currregmatched
                    if allregmatched is False:
                        row = cursor.fetchone()
                        continue

                #print row
                printrow(row)
                row = cursor.fetchone()

        cursor.close()
        connection.close()

main()
