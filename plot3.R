# plot3
# Data from the UC Irvine Machine Learning Repository
# Please download and unzip the data file on your R working directory.
################################
print(paste("File size(MB): ",file.size("./household_power_consumption.txt")/1024^2))

print("Reading data...")
library(data.table)
library(lubridate)
hpc <- fread("./household_power_consumption.txt",
           colClasses = list(character = 3:8), na.strings = c("NA", "?"))
## Read 2075259 rows and 9 (of 9) columns from 0.124 GB file in 00:00:03

hpcc <- hpc[complete.cases(hpc),]

# Change column "Global_active_power","Global_reactive_power",
#   "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2"
#   to numeric
hpcc[,names(hpc)[3:8]:=lapply(.SD,as.numeric),.SDcols=names(hpc)[3:8]]

hpcd<-hpcc[dmy(Date)>=ymd("2007-02-01") & dmy(Date)<=ymd("2007-02-02"),]

##------------------------------------------------------------------------
print("Outputing plot3.png file...")
png(file="plot3.png",bg="transparent")
#rotating axis labels
par(mfcol=c(1,1),las=0)

plot(dmy_hms(paste(hpcd$Date,hpcd$Time)),hpcd$Sub_metering_1,type="l",xlab="",
     ylab="Energy sub metering",cex.lab=0.98,cex.axis=1,mgp=c(2.4, 0.75, 0),
     fg="grey50",col="grey20")
axis(1,at=c(dmy_hms("01/02/2007 00:00:00"),dmy_hms("01/02/2007 23:59:59"),
            dmy_hms("02/02/2007 23:59:59")),col="black",labels=FALSE)
axis(2,col="black",labels=FALSE)
points(dmy_hms(paste(hpcd$Date,hpcd$Time)),hpcd$Sub_metering_2,type="l",col="red")
points(dmy_hms(paste(hpcd$Date,hpcd$Time)),hpcd$Sub_metering_3,type="l",col="blue")
legend("topright",col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lwd=1,cex=0.98)

dev.off()
print("plot3.png saved at:")
print(paste(getwd(),"/plot3.png",sep=""))