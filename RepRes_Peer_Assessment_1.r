my.data <- read.csv(file="activity.csv", header=TRUE, sep=",", na.string="NA")
my.data$date <- as.Date(my.data$date)
my.data.aveSteps <- aggregate(formula = steps ~ date,  data = my.data, FUN = mean)
require(ggplot2)
ggplot(data=my.data.aveSteps, aes(x=date, y=steps)) +
  geom_histogram(stat="identity", fill="lightblue", colour="black")

my.data.aveIntervalSteps <- aggregate(formula = steps ~ interval, data = my.data, FUN = mean)
my.data.maxIntervalSteps <- my.data.aveIntervalSteps[which.max(my.data.aveIntervalSteps$steps),]

DailySteps.mean <- mean(my.data.aveSteps$steps)
DailySteps.median <- median(my.data.aveSteps$steps)

my.data.sansNA <- my.data
for (index in 1:nrow(my.data.sansNA)){
  if(is.na(my.data.sansNA$steps[index])){
    my.data.sansNA$steps[index]<- my.data.aveIntervalSteps$steps[my.data.aveIntervalSteps$interval == my.data.sansNA$interval[index]]
  }
} 

is.weekday <- function(date) {
  day.test <- weekdays(date)
  if (day.test %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"))
    return("weekday")
  else if (day.test %in% c("Saturday", "Sunday"))
    return("weekend")
  else
    stop("invalid date")
}
my.data.sansNA$wday <- sapply(my.data.sansNA$date, FUN=is.weekday)
my.data.wday.aveIntervalSteps <- aggregate(formula = steps ~ interval + wday, data = my.data.sansNA, FUN = mean)

ggplot(data=my.data.wday.aveIntervalSteps, aes(x=interval, y=steps)) +
  facet_grid(wday ~ . ) +
  geom_line(colour="red", size=0.5) +
  xlab("5-min interval") +
  ylab("average steps taken")