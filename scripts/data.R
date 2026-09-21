# arrow package allows large dataset .parquet files to be read in
install.packages("arrow")
library(arrow

# data stored in object       
data <-read_parquet("PCV_Stacked.parquet")
        
head(data) #inspect first lines of data
ncol(data) #10 variables
nrow(data)  #1315782 observations
names(data) #ie. batch numbers, sites, parameters, weighted average values ect.
str(data) #large R dataset table 
unique(data$product_name) # 3 products, Prevenar, 13 & 20
unique(data$sub_product_name) # 4 sub-products, drug product, PFS, MDV, SDV
unique(data$manufacture_site) #two sites - Grange Castle, Puurs
unique(data$variant) #6 variants, S01, S03, S04, S09V, S18C, S19A
length(unique(data$batch_number)) #13608 unique batch numbers <100 rows per batch
length(unique(data$parameter)) #132 unique parameters, multiple paramenters per batch
summary(data$weighted_avg_value) #misleading right-skewed distribution due to average of all parameter values measured at different scales
#also get number of NAs = 49848 = 3.8% missing data
table(data$product_name, data$variant) #creating a table isolating out two variables as an example
save(data, file = "data.RData") #save object in project folder

# day 2 agenda: 
#pivot the data wider
#investigate NAs, conduct binary classification based on threshold
#product distributions for individual parameters
#create histograms in r studio for these distributions
#investigate outliers & any skew-ness in the histograms
        
        

