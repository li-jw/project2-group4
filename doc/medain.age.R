
 ##graph!!!
 
 age=read.csv("age.csv",header=t)
 ggplot(age, aes(x=Year, y=Age, colour=Borough, group=age$Borough)) +
   geom_line(size=1.75)
 
 
 

 
 
 
 
 