

library(dplyr)
library(wordcloud)
names1=read.csv("Most_Popular_Baby_Names_by_Sex_and_Mother_s_Ethnic_Group__New_York_City-3.csv",
                header=TRUE)
## for girls

girlname<-names1%>%
  filter(GNDR=="FEMALE")%>%
  group_by(NM) %>% 
  summarise(freq=mean(CNT))%>%
  arrange(desc(freq))


pal2 <- brewer.pal(8,"Dark2")
png("wordcloud_packages.png", width=1200,height=1200)
wordcloud(girlname$NM,girlname$freq, scale=c(8,.2),min.freq=20,
          max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)
dev.off()

##for boys, in similar way

boyname<-names1%>%
  filter(GNDR=="MALE")%>%
  group_by(NM) %>% 
  summarise(freq=mean(CNT))%>%
  arrange(desc(freq))


pal3 <- brewer.pal(111,"Dark2")
png("wordcloud_packages.png", width=1200,height=1200)
wordcloud(boyname$NM,boyname$freq, scale=c(8,.2),min.freq=20,
          max.words=Inf, random.order=FALSE, rot.per=.2,colors=pal3)
dev.off()

##for least popular names

##for boys, in similar way

boyname.l<-names1%>%
  filter(GNDR=="MALE")%>%
  group_by(NM) %>% 
  summarise(freq=mean(CNT))%>%
  arrange(freq)

boyname.l$freq=(max(boyname.l$freq)-boyname.l$freq)
#boyname.l=boyname.l[1:1000,]


pal3 <- brewer.pal(8,"Dark2")
png("wordcloud_packages.png", width=2100,height=2100)
wordcloud(boyname.l$NM,boyname.l$freq, scale=c(8,.1), min.freq=20,
          max.words=50,random.order=FALSE, rot.per=.2,colors=pal3)
dev.off()



##for girls, in similar way

girlname.l<-names1%>%
  filter(GNDR=="FEMALE")%>%
  group_by(NM) %>% 
  summarise(freq=mean(CNT))%>%
  arrange(freq)

girlname.l$freq=(max(girlname.l$freq)-girlname.l$freq)
#boyname.l=boyname.l[1:1000,]


pal3 <- brewer.pal(8,"Dark2")

png("wordcloud_packages.png", width=2100,height=2100)
wordcloud(girlname.l$NM,girlname.l$freq, scale=c(8,.1), min.freq=20,
          max.words=50,random.order=FALSE, rot.per=.2,colors=pal3)
dev.off()



