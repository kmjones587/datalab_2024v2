library(tidyverse)
library(ggplot2)
library(tidytext)
library(dplyr)
library(gsheet)
library(wordcloud2)
library(sentimentr)
library(lubridate)

survey <- gsheet::gsheet2tbl('https://docs.google.com/spreadsheets/d/1W9eGIihIHppys3LZe5FNbUuaIi_tfdscIq521lidRBU/edit?usp=sharing')

# 4. Take a look at the first few rows of the data. What is the unit of observation?
#   timestamps

# 5. Create a variable named date_time in your survey data. This should be based on the Timestamp variable. Use the mdy_hms variable to created a “date-time” object.
# 
survey1 <- survey %>% mutate(datetime=mdy_hms(survey$Timestamp))

# 6. Create a visualization of the date_time variable.
# 
ggplot(data=survey1,aes(x=datetime))+geom_histogram()
# 7. Create an object called sentiments by running the following:
#
sentiments <- get_sentiments('bing')
# 
# 8. Explore the sentiments object. How many rows? How many columns? What is the unit of observation.
# 6786 rows 2 columns unit of obs is the word's alphabetical order

# 9. Create an object named words by running the following:

words <- survey %>%
  dplyr::select(first_name,
                feeling_num,
                feeling) %>%
  unnest_tokens(word, feeling)
# 10. Explore words. What is the unit of observation.
# It is organized by who submitted their survey first, followed by their description of how theyre feeling word by word

# 11. Look up the help documentation for the function wordcloud2. What does it expect as the first argument of the function?
#   It expects the first argument to be a dataframe that has words and frequency


# 12. Create a dataframe named word_freq. This should be a dataframe which is conformant with the expectation of wordcloud2, showing how frequently each word appeared in our feelings.
# 
word_freq <- words %>% group_by(word) %>% tally()

# 13. Make a word cloud.
# 
wordcloud2(word_freq, size = 2.5, minSize = 0, gridSize =  0,
           fontFamily = 'Segoe UI', fontWeight = 'bold',
           color = 'random-dark', backgroundColor = "white",
           minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE,
           rotateRatio = 0.4, shape = 'circle', ellipticity = 0.65,
           widgetsize = NULL, figPath = NULL, hoverFunction = NULL)

# 14. Run the below to create an object named sw.
# 
sw <- read_csv('https://raw.githubusercontent.com/databrew/intro-to-data-science/main/data/stopwords.csv')

# 15. What is the sw object all about? Explore it a bit.

# sw is all of the words

# 16. Remove from word_freq any rows in which the word appears in sw.
#

word_freq1 <- anti_join(word_freq,sw,by="word")

# 17. Make a new word cloud.

wordcloud2(word_freq1)

# 18. Make an object with the top 10 words used only. Name this object top10.
# 
top10w <- head(word_freq1[order(-word_freq1$n),],10)

# 19. Create a bar chart showing the number of times the top10 words were used.
# 
ggplot(data=top10w,aes(x=word,y=n))+geom_col(fill="lightgreen")

# 20. Run the below to join word_freq with sentiments.
# 
sentiments1 <- left_join(sentiments,word_freq,by="word") #creates new sentiments1 dataset by left joining sentiments and word frequency by the specific word variable

# 21. Now explore the data. What is going on?
#   Most of the words do not have any particular frequency of use.
# 22. For the whole survey, were there more negative or positive sentiment words used?
#   
#there were more positive from a glance.

# 23. Create an object with the number of negative and positive words used for each person.
# 
sentiments2 <- sentiments1 %>% #creates new dataset
  group_by(sentiment) %>% #groups by positive or negative
  summarise(total_frequency = sum(n, na.rm = TRUE)) %>% #summarizes
  spread(key = sentiment, value = total_frequency, fill = 0) #makes columns based on frequency of positive or negative?? i think?

# 24. In that object, create a new variable named sentimentality, which is the number of positive words minus the number of negative words.
# 
sentiments2 <- sentiments2 %>% mutate(sentimentality=positive-negative)

# 25. Make a histogram of senitmentality
# 
ggplot(data=sentiments2,aes(x=sentimentality))+geom_histogram()

# 26. Make a barplot of sentimentality.
# 
ggplot(data=sentiments2,aes(x=sentimentality))+geom_bar()

  # 27. Create a wordcloud for the dream variable.
  # 
surveydream <- survey1 %>% select(first_name,
                  dream) %>%
    unnest_tokens(word, dream) #creates new surveydream dataset of just first names, and words
  
surveydream1 <- surveydream %>% group_by(word) %>% tally() #creates new dataset surveydream 1 from surveydream then grouping surveydream by word and tallying in the columns like before
  
wordcloud2(surveydream1) #makes a wordcloud

# 28. Create a barplot showing the top 16 words in our dreams.
# 
dreamtop16 <- head(surveydream1[order(-surveydream1$n),],16)
ggplot(data=dreamtop16,aes(x=word,y=n))+geom_col(fill="blue")

# 29. Which word showed up most in people’s description of Joe?
#   
#"i" followed by "a"

# 30. Make a histogram of feeling_num.
# 


# 31. Make a density chart of feeling_num.
# 


# 32. Change the above plot to facet it by gender.
# 


# 33. How many people mentioned Ryan Gosling in their description of Joe?
#   


# 34. Is there a correlation between the sentimentality of people’s feeling and their feeling_num

