#This script expands upon the code that was set up in stress1_leafsize_df_scratchwork
#by applying the code across all stress1 plant analysis files, instead of several samples.

setwd("C:/Users/ekine/PlantCV_images/2023/2023-ar_wave2/results/")

#library(tidyverse)
library(stringr)
library(readr)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(dplyr)

#function for parsing strings
#This will need to change if the replicate is different than 0-10
parse_rep <- function(rep) {
  sub_rep <- substr(rep, start=1, stop=str_length(rep)-4)
  sub_rep_split <- strsplit(sub_rep, "")[[1]]
  rep_list <- list()
  
  for(char in sub_rep_split){
    if (char == "1"){
      rep_list <- append(rep_list, paste0(char,"0"))
    }
    else{
      rep_list <- append(rep_list, char)
    }
  }
  #print(rep_list)
  return(rep_list)
}

#Create a list of the files in the input folder.
file_list <- list.files(path="C:/Users/ekine/PlantCV_images/2023/2023-ar_wave2/results/")

for(file_name in file_list){
  ###Create a df with area values
  #Read in the file
  raw_dat <- read.csv(file_name)
  #Of this data, pull out the rows with area values
  area_dat <- rbind(raw_dat[c(2,20,38,56),])
  
  ###Use the file name to get day, genotype, and treatment info
  #Split the file name by the underscore character
  split_name <- strsplit(file_name, split="_")
  
  #Access day information and remove
  if (split_name[[1]][3] == "tuesday"){
    day <- "1 week after freeze"
  }
  else if (split_name[[1]][3] == "before"){
    day <- "2 days before freeze"
  }
  else if (split_name[[1]][3] == "recovery"){
    day <- "2 days after freeze"
  }
  else {
    print("error")
    #do nothing
  }
  
  
  #day <- split_name[[1]][3]
  #print(day)
  
  #Access genotype information
  geno <- split_name[[1]][2]
  #print(geno)
  
  #Access treatment information and remove the number from the end of the treatment entry
  treatment <- split_name[[1]][1]
  #print(treatment)
  
  #Access replicate information
  rep <- split_name[[1]][4]
  rep_list <- parse_rep(rep)

  ###Add columns for day, genotype, and treatment to the area df
  area_dat$Day <- day
  area_dat$Genotype <- geno
  area_dat$Treatment <- treatment
  
  ###Remove unnecessary columns and rename existing columns to be more descriptive
  area_dat$trait <- NULL
  area_dat$label <- NULL
  
  colnames(area_dat)[1] <- "Replicate"
  area_dat$Replicate[1] <- unlist(rep_list)[1]
  area_dat$Replicate[2] <- unlist(rep_list)[2]
  area_dat$Replicate[3] <- unlist(rep_list)[3]
  area_dat$Replicate[4] <- unlist(rep_list)[4]

  colnames(area_dat)[2] <- "Area_pix"
  
  ###Re-order the columns to match the order of the master df
  col_order <- c(3,4,5,1,2)
  area_dat_cleaned <- cbind(area_dat[col_order])

  ###Check if your master df already exists. If it does, add your current df to it.
  #If it doesn't, rename your current df as the master df.
  if(exists("stress1_plant_area")){
    stress1_plant_area <- rbind(stress1_plant_area,area_dat_cleaned)
  } else {
    stress1_plant_area <- area_dat_cleaned
  }
}

#removes the entire row if it finds a single na
stress1_plant_area <- na.omit(stress1_plant_area)

#Re-number the rows of your master area df
rownames(stress1_plant_area) <- c(1:length(stress1_plant_area$Area_pix))

#Save the df with pixel area information as an RData file
setwd("C:/Users/ekine/PlantCV_images/2023/2023-ar_wave2/R_results/")
save(stress1_plant_area, file = "rec_stress1_plant_area.RData")
write.csv(stress1_plant_area, "rec_stress1_plant_area.csv", row.names=FALSE)

colorchip = 25001
df = stress1_plant_area %>%  mutate(SqCM = sqrt(Area_pix/colorchip) * 6.4516)


# df %>% 
#   ggplot(aes(x = Genotype, y =  SqCM)) +
#   geom_histogram(stat = "Identity")

# df %>% 
#   ggplot(aes(x = Genotype, y =  SqCM, group = interaction(Genotype,Treatment))) +
#   geom_boxplot(aes(fill = Treatment), alpha = .8) +
#   scale_fill_manual(values = c("rosybrown3", "paleturquoise3")) +
#   theme_bw() +
#   ylab("square inches") +
#   xlab("") +
#   ggtitle("Plant area by treatment for Arabidopsis genotypes (before)")

# df %>% 
#   ggplot(aes(x = Day, y =  SqCM, group = interaction(Genotype,Day))) +
#   geom_boxplot(aes(fill = Day), alpha = .8) +
#   facet_grid(~geno) +
#   scale_fill_manual(values = c("rosybrown3", "paleturquoise3", "purple")) +
#   theme_bw() +
#   ylab("square inches") +
#   xlab("") +
#   ggtitle("Plant area by day for Brassica rapa genotypes")

# df %>% 
#   ggplot(aes(x = Day, y =  SqCM)) +
#   geom_boxplot(aes(fill = Treatment), alpha = .8) +
#   facet_wrap(vars(Genotype), nrow = 2) +
#   scale_fill_manual(values = c("rosybrown3", "paleturquoise3", "purple")) +
#   theme_bw() +
#   ylab("square inches") +
#   xlab("") +
#   ggtitle("Plant area by day for Arabidopsis genotypes")
# 
# # Stats
# # Here we are looking at if "day column" affects plant area by genotype 
# myaov = aov(SqCM ~ Genotype * Day, data = df)
# summary(myaov)
# # post hoc test to see which genotypes differ within the "day column"
# TukeyHSD(myaov)

# df %>%
#   ggplot(aes(x = Day, y =  SqCM)) +
#   geom_boxplot(alpha = .8) +
#   facet_grid(Genotype ~ Treatment + Replicate) +
#   scale_fill_manual(values = c("rosybrown3", "paleturquoise3", "purple")) +
#   theme_bw() +
#   ylab("square inches") +
#   xlab("") +
#   ggtitle("Growth rate per plant for Arabidopsis genotypes")
# 

# df %>%
#   filter(Genotype == "A03") %>%
#   ggplot(aes(x = Treatment, y =  SqCM)) +
#   geom_boxplot(alpha = .8) +
#   facet_wrap(~ Day, ncol = 3) +
#   ylab("square inches") +
#   xlab("")
# 
# df %>%
#   filter(Genotype == "R500") %>%
#   ggplot(aes(x = Treatment, y =  SqCM)) +
#   geom_boxplot(alpha = .8) +
#   facet_wrap(~ Day, ncol = 3) +
#   ylab("square inches") +
#   xlab("")
# 

# Change the ordering of the day column while plotting
df$Day <- factor(df$Day, levels = c("2 days before freeze", "2 days after freeze", "1 week after freeze"))

# ALL GENOTYPES AND TREATMENTS
df %>%
  ggplot(aes(x = Treatment, y =  SqCM, color = Genotype, group = Genotype)) +
  geom_boxplot(alpha = .8) +
  facet_wrap(~ Day) +
  ylab("square CM") +
  xlab("")

################################
# INDIVIDUAL PLANTS LINE GRAPH
df %>%
  filter(Genotype == "Per-1") %>%
  filter(Treatment == "CTL") %>%
  ggplot(aes(x = Day, y =  SqCM, color = Replicate, group = Replicate)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ Genotype) +
  ylab("square CM") +
  xlab("")

df %>%
  filter(Genotype == "Per-1") %>%
  filter(Treatment == "FRZ") %>%
  ggplot(aes(x = Day, y =  SqCM, color = Replicate, group = Replicate)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ Genotype) +
  ylab("square CM") +
  xlab("")

df %>%
  filter(Genotype == "Rsch") %>%
  filter(Treatment == "CTL") %>%
  ggplot(aes(x = Day, y =  SqCM, color = Replicate, group = Replicate)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ Genotype) +
  ylab("square CM") +
  xlab("")

df %>%
  filter(Genotype == "Rsch") %>%
  filter(Treatment == "FRZ") %>%
  ggplot(aes(x = Day, y =  SqCM, color = Replicate, group = Replicate)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ Genotype) +
  ylab("square CM") +
  xlab("")

#############################
# BOX PLOT OF SPECIFIC GENOTYPES THAT ARE COLD TOLERANT AND INTOLERANT
df %>%
  filter(Genotype == "Per-1") %>%
  ggplot(aes(x = Treatment, y =  SqCM)) +
  geom_boxplot(alpha = .8) +
  facet_wrap(~ Day, ncol = 3) +
  ylab("square CM") +
  xlab("")

df %>%
  filter(Genotype == "Rsch") %>%
  ggplot(aes(x = Treatment, y =  SqCM)) +
  geom_boxplot(alpha = .8) +
  facet_wrap(~ Day, ncol = 3) +
  ylab("square CM") +
  xlab("")
