options(stringsAsFactors = FALSE)
library(lubridate)
library(reshape2)
library(stringr)
library(plyr)
source("xtable.r")

#

raw.bill <- read.csv("https://raw.githubusercontent.com/hadley/tidy-data/master/data/billboard.csv")
raw.bill <- raw.bill[,c("year", "artist.inverted", "track", "time", "date.entered", "x1st.week", "x2nd.week", "x3rd.week", "x4th.week", "x5th.week", "x6th.week", "x7th.week", "x8th.week", "x9th.week", "x10th.week", "x11th.week", "x12th.week", "x13th.week", "x14th.week", "x15th.week", "x16th.week", "x17th.week", "x18th.week", "x19th.week", "x20th.week", "x21st.week", "x22nd.week", "x23rd.week", "x24th.week", "x25th.week", "x26th.week", "x27th.week", "x28th.week", "x29th.week", "x30th.week", "x31st.week", "x32nd.week", "x33rd.week", "x34th.week", "x35th.week", "x36th.week", "x37th.week", "x38th.week", "x39th.week", "x40th.week", "x41st.week", "x42nd.week", "x43rd.week", "x44th.week", "x45th.week", "x46th.week", "x47th.week", "x48th.week", "x49th.week", "x50th.week", "x51st.week", "x52nd.week", "x53rd.week", "x54th.week", "x55th.week", "x56th.week", "x57th.week", "x58th.week", "x59th.week", "x60th.week", "x61st.week", "x62nd.week", "x63rd.week", "x64th.week", "x65th.week", "x66th.week", "x67th.week", "x68th.week", "x69th.week", "x70th.week", "x71st.week", "x72nd.week", "x73rd.week", "x74th.week", "x75th.week", "x76th.week")]
names(raw.bill)[2] <- "artist"

raw.bill$artist <- iconv(raw.bill$artist, "MAC", "ASCII//translit")
raw.bill$track <- str_replace(raw.bill$track, " \\(.*?\\)", "")
names(raw.bill)[-(1:5)] <- str_c("wk", 1:76)
raw.bill <- arrange(raw.bill, year, artist, track)

long_name <- nchar(raw$track) > 20
raw.bill$track[long_name] <- paste0(substr(raw.bill$track[long_name], 0, 20), "...")

xtable(raw.bill[c(1:3, 6:10), 1:8], "billboard-raw.tex")

clean.bill <- melt(raw.bill, id = 1:5, na.rm = T)
clean.bill$week <- as.integer(str_replace_all(clean.bill$variable, "[^0-9]+", ""))
clean.bill$variable <- NULL

clean.bill$date.entered <- ymd(clean.bill$date.entered)
clean.bill$date <- clean.bill$date.entered + weeks(clean.bill$week - 1)
clean.bill$date.entered <- NULL
clean.bill <- rename(clean.bill, c("value" = "rank"))
clean.bill <- arrange(clean.bill, year, artist, track, time, week)
clean.bill <- clean.bill[c("year", "artist", "time", "track", "date", "week", "rank")]

clean_out.bill <- mutate(clean.bill, 
                    date = as.character(date))
xtable(clean_out.bill[1:15, ], "billboard-clean.tex")


song <- unrowname(unique(clean.bill[c("artist", "track", "time")]))
song$id <- 1:nrow(song)

narrow.bill <- song[1:15, c("id","artist", "track", "time")]
xtable(narrow.bill, "billboard-song.tex")

rank <- join(clean.bill, song, match = "first")
rank <- rank[c("id", "date", "rank")]
rank$date <- as.character(rank$date)
xtable(rank[1:15, ], "billboard-rank.tex")

