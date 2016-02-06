#
# Due to the size of this file, we are going to loop over each line 
# rather than storing everything in RAM.  A bit slower but the 
# file is huge since it is TOTALLY A GREAT IDEA TO STORE HUGE
# AMOUNTS OF DATA IN ASCII FORMAT.  IT'S NOT INEFFICIENT AT ALL!!!
#
# UPDATE: Not worth the trouble.  Just read the darn thing and
#         subset.  Whatever.
#

read_file <- function(
  filename="./DONTPUSH/household_power_consumption.txt") {
  huge_data <- read.table(filename, sep=";", header=TRUE,
                          na.strings="?",
                          comment.char="") # speeds it up
  return(huge_data[((as.character(huge_data$Date) == "1/2/2007") | 
                    (as.character(huge_data$Date) == "2/2/2007")),])
}

read_and_convert_times <- function(
  filename="./DONTPUSH/household_power_consumption.txt") {
  
  subset <- read_file(filename)
  
  # Have to install chron package!
  times <- chron(dates=as.character(subset$Date), 
                 times=as.character(subset$Time), 
                 format=c('d/m/y', 'h:m:s'))
  subset$dateTime <- times
  return(subset)
}

plot_2_data <- function() {
  print("Loading Chron Package (*you may need to install it!)*")
  library(chron)
  print("Reading data and adding chron time field")
  data <- read_and_convert_times()
  print("making plot")
  png(file='plot2.png')
  days <- as.Date(as.character(as.vector(data$Date)), '%d/%m/%Y')
  #days
  days_ticks <- c(as.Date("1/2/2007", format='%d/%m/%Y'), 
                  as.Date("2/2/2007", format='%d/%m/%Y'), 
                  as.Date("3/2/2007", format='%d/%m/%Y'))
  days_labels <- c("Thu", "Fri", "Sat")
  plot(x=data$dateTime, y=data$Global_active_power,
       ylab='Global Active Power (kilowatts)',
       xlab='',
       main='', type='l',
       col='black', xaxt="n")
  axis(side=1, at=days_ticks, labels=days_labels)
  dev.off()
}

#plot_2_data()