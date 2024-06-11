library(tidyverse)
library(ggplot2)
library(babynames)
bb_names <- babynames
marie <- bb_names %>% 
  filter(name=="Marie")

ggplot((data=bb_names %>% 
          filter(name=="Marie",year>=1982)),aes(x=year))+geom_histogram()

ggplot((data=bb_names %>% 
       filter(name=="Joe")),aes(x=year,y=prop,color=sex))+geom_line(alpha=0.5,linewidth=2)+
       labs(x="Year",                                                                                         y="Proportion of Joe Names",
       color="Experience in R", 
       title="Year vs. Proportion of Joe Names",
       subtitle="It's so Joever, es ist joebei")
#es ist joebei

ggplot((data=bb_names %>% filter(name %in% c("Marie","Emma","Hanna","Ana","Jordan"),sex=="F",year==2002)),aes(x=name,y=n))+geom_col()

ggplot((data=bb_names %>% filter(name=="Mark",sex=="F",year==2003)),aes(x=name,y=n))+geom_col()


ggplot((data=bb_names %>% filter(name %in% c("Marie","Emma","Hanna","Ana","Jordan"),sex=="F",year==2002)),aes(x=name,y=n,fill=name))+geom_col(alpha=0.3)

the_nineties <- bb_names %>% filter(year>=1990 & year<2000)

#we got yap sesh tuesday over here

#write_csv(the_nineties,"datalab_2024.rproj")

ggplot((data=bb_names %>% filter(name %in% c("Joseph","Srijan","Kyle","Gavin"),year==2005)),aes(x=name,y=n,fill=name))+geom_col(alpha=0.3)

srijan05 <- bb_names %>% 
  filter(name=="Srijan",year==2005)

ggplot((data=bb_names %>% filter(name =="Kyle")),aes(x=year,y=n,col=sex))+geom_line(alpha=1,fill="darkblue",size=1.5)
