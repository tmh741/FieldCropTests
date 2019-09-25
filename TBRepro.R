library(reshape2)
library(plyr)
library(stringr)
source("xtable.r")
options(stringsAsFactors = FALSE)

#Hello! This is me.
#I basically recreated what Wickham did using his code as a reference.
#A link to his github will be here:
#https://github.com/hadley/tidy-data/blob/master/data/tb.r

raw.tb <- read.csv("https://raw.githubusercontent.com/hadley/tidy-data/master/data/tb.csv", na.strings = "")
raw.tb$new_sp <- NULL
raw.tb <- subset(raw.tb, year == 2000)
names(raw.tb)[1] <- "country"

names(raw.tb) <- str_replace(names(raw.tb), "new_sp_", "")
raw.tb$m04 <- NULL
raw.tb$m514 <- NULL
raw.tb$f04 <- NULL
raw.tb$f514 <- NULL

xtable(raw.tb[1:10, 1:11], file = "Raw-TB.tex")

clean.tb <- melt(raw.tb, id = c("country", "year"), na.rm = TRUE)
names(clean.tb)[3] <- "column"
names(clean.tb)[4] <- "cases"

clean.tb <- arrange(clean.tb, country, column, year)
xtable(clean.tb[1:15, ], file = "Clean-TB.tex")


clean.tb$sex <- str_sub(clean.tb$column, 1, 1)

ages <- c("04" = "0-4", "514" = "5-14", "014" = "0-14", "1524" = "15-24", "2534" = "25-34", "3544" = "35-44", "4554" = "45-54", "5564" = "55-64", "65"= "65+", "u" = NA)

clean.tb$age <- factor(ages[str_sub(clean.tb$column, 2)], levels = ages)

clean.tb <- clean.tb[c("country", "year", "sex", "age", "cases")]

xtable(clean.tb[1:15, ], file = "Clean-TB2.tex")


