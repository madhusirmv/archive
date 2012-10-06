library("lme4")

data <- read.csv("data.csv")
data <- subset(data, ch1>0 & ch2 > 0) # omit trials without choice
len <- nrow(data)

# recode the variables of interest

data$mn <- 2*data$mn-1
data$rare <- 2 * as(data$ch1 != (data$st-1),"numeric") - 1

# dependent variable: stay/switch
data$stay <- c(data$ch1[2:len] == data$ch1[1:len-1],NaN) # whether the
#subsequent ch1 was a switch rel to current
data[diff(data$trial)<1,]$stay = NaN # erase this variable where it
#catches the switch from one subject to the next

# model
fit = glmer(stay ~ rare * mn + (1+rare*mn|sub),data=data,family="binomial")
summary(fit)
