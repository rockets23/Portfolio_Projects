library (tidyverse)
library (plyr)

   ###Exploring and Cleaning Data using Rstudio


movies <- read_csv("movies.csv")  # Reading our CSV file containing Data about movies and putting it in a variable named movies



       ### Variables types 

glimpse(movies)

class(movies$score) #gives the type of a specific variable

unique(movies$genre) #gives what can be found in a particular variable

sum(is.na(movies)) #counting the Null cells

sum(is.na(movies$rating))  #counting the missing values in a specific column

movies$budget <- as.integer(movies$budget)  #changing the data type

temp <- sub(".*, ", "", movies$released)# retrieving the year of release from released column

releasedYear <- substr(temp, 1, 4)      # released column format is "month day, year (country)"

movies$releasedYear <- releasedYear     # creating a new column in our dataset

movies <- movies[order(movies$budget),]  # sorting our dataset with the budget column in a increasing order


    ### Finding correlations in our dataset

# building a scatter plot with budget vs gross revenue

ggplot(data= movies) + geom_point(mapping= aes(x= budget, y = gross), color="orange")+ 
ggtitle("Budget vs Gross earnings")+
  theme(plot.title = element_text(hjust = 0.5))+
labs(y="Gross earnings", x="Movie Budget")+
geom_smooth(mapping = aes(x =budget, y = gross))

#making a correlation table

budget2 <-movies$budget
gross2 <-movies$gross
score2 <-movies$score
votes2 <-movies$votes

correlation <-data.frame(budget2, gross2, score2, votes2) #creating a new data frame with numeric variables only
my_color<-colorRampPalette(c("yellow", "red"))
heatmap(cor(correlation, use="complete.obs"), Rowv=NA, Colv=NA, col=my_color(100))

#giving every company a numeric value to add it to the correlation table
 
n_distinct(movies$company) 

movies$companyNum <- as.numeric(format(factor(movies$company, labels = 1:2385)))

correlation$company <- movies$companyNum #adding the company column to the correlation table

view(cor(correlation, use="complete.obs"))