import math

def inflatetime(time):
    time = float(time)
    print time
    milsec, sec = math.modf(time)
    milsec = milsec * 100
    print "milsec     " + str(milsec)
    print "sec before " + str(sec)
    minutes = int(sec) / int(60)
    print "minutes    " + str(minutes)
    sec =  sec - (minutes * 60)
    print "actual sec " + str(sec)
    if minutes is not 0:
        print "minute print " + str(minutes)
        inflated = '%d:%02d.%02d' % (minutes, sec, milsec)
    else:
        inflated = '%d.%02d' % (sec,milsec)
    return inflated
