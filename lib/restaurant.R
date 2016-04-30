library("dplyr")
library("data.table")

colsToKeep <- c("BORO", "ZIPCODE", "ACTION", "SCORE")
restau <- fread("Restaurant_Inspection.csv", select = colsToKeep)
restau <- na.omit(restau) %>%
          filter(BORO == "MANHATTAN") %>%
          filter(ACTION == "Violations were cited in the following area(s).") %>%
          group_by(ZIPCODE) %>%
          summarise(Num_Violation = n(), Ave_Score = mean(SCORE))
