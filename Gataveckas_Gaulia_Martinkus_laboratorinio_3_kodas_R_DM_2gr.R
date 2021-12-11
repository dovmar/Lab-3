## ---- include=FALSE---------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(warning=FALSE,message=FALSE)


## ---------------------------------------------------------------------------------------------------------------------
library(tidyverse)
library(car)
library(readxl)
library(janitor)

x<-readxl::read_xlsx("HighSchool.xlsx",sheet = 1) %>% clean_names()


## ---------------------------------------------------------------------------------------------------------------------
x <- x %>%
  drop_na()


# Duomenys išsaugomi į failą
write_csv(x,"high_school_modified.csv")


# Koeficiento lygybės skirtingiems faktoriaus lygmenims patikrinimas
ggplot(x,aes(attendance,result,color=parental_education)) + geom_point() + geom_smooth(method="lm",se=FALSE) +
  theme_minimal()

ggplot(x,aes(daily_study_hours,result,color=parental_education)) + geom_point() + 
  geom_smooth(method="lm",se=FALSE) + theme_minimal() + scale_color_brewer(palette="Set2")


ggplot(x,aes(x=parental_education,y=daily_study_hours,color=special_coaching)) + geom_boxplot() + theme_minimal() +
scale_color_brewer(palette="Set2")


ggplot(x,aes(x=parental_education,y=attendance,color=special_coaching)) +
  geom_boxplot() + theme_minimal() + scale_color_brewer(palette="Set2")


## ---------------------------------------------------------------------------------------------------------------------
library(rstatix)

anova_test(result~attendance*parental_education + daily_study_hours*parental_education,data=x,type=3, detailed=TRUE) # Hipotezės apie koeficientų lygybę visiems faktoriaus lygmenims neatmetos


# Kovariacinės analizės modelio sukūrimas
model <- anova_test(result~attendance + daily_study_hours + parental_education,data=x,type=3, detailed=TRUE)
model


## ---------------------------------------------------------------------------------------------------------------------
model_lm <- lm(result~attendance + daily_study_hours + parental_education,data=x)

# Dispersijų lygybė grupėms
leveneTest(result~parental_education,data=x)
# Liekanų normalumas
shapiro.test(resid(model_lm))

plot(model_lm)
# Išskirtys
plot(cooks.distance(model_lm))
plot(hatvalues(model_lm))


## ---------------------------------------------------------------------------------------------------------------------
library(emmeans)

means <- emmeans_test(result~parental_education,covariate = c(daily_study_hours,attendance),p.adjust.method="tukey",data=x) 
means

get_emmeans(means)

