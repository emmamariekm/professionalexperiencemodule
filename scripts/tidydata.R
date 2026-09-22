#start tidy data & pivot wider 
install.packages("tidyr")
library(tidyr)

library(arrow)
data <-read_parquet("PCV_Stacked.parquet")

#check how many parameters
unique(data$parameter)
#132 parameters

#count each time a batch number & parameter combination occurs)
max(table(data$batch_number, data$parameter)
#returns 1, no duplicated batches, contains some zeros which refer to missingness (I think)

#create pivoted wider dataset, 
tidied_data <- pivot_wider(
  data,
  names_from = parameter,
  values_from = weighted_avg_value
)
#dataset will have 132 columns as parametera & 13608 rows for each unique batch
head(tidied_data)
colnames(tidied_data)
ncol(tidied_data) #140 columns (original 10 columns + parameter cols) )
nrow(tidied_data) #76122 rows ? more than one row per batch ? 
nrow(unique(data[c(
  "batch_number",
  "material_number",
  "manufacture_site",
  "product_name",
  "sub_product_name",
  "mbc_batch_number",
  "variant",
  "date_of_manufacture"
)]))
#count unique combinations of parameter & batch number
#76122 aka batch number appearing with multiple distinct average weighted values for parameters being measured.

nrow(unique(data[c("batch_number", "product_name")]))
#15178 unique combinations of a batch no & product name
nrow(unique(data[c("batch_number", "manufacture_site")]))
#13608   - only one manufacture site per batch number
nrow(unique(data[c("batch_number", "material_number")]))
#13616   - only some have more than one material number 
nrow(unique(data[c("batch_number", "variant")]))
#62985 - batches can have multiple variants
nrow(unique(data[c("batch_number", "sub_product_name")]))
#17013 - only some batches have multiple sub product names
nrow(unique(data[c("batch_number", "mbc_batch_number")]))
#62985 - many MBC numbers
nrow(unique(data[c("batch_number", "date_of_manufacture")]))
#13815 - some batches have multiple ????
table(table(data$batch_number))
#needs to be visualised in RStudio to see how many batches have how many rows. 

#investigate how many rows per variant
table(data$variant)
#  S01    S03    S04   S09V   S18C   S19A 
#192366 228551 232914 181039 230719 25019

#we can say the dataset is pivoted wider now.
#we must also note that we have multiple rows per batch.

#NA count 
sum(is.na(tidied_data)) #count sum of every cell with NA
#8782234
colSums(is.na(tidied_data)) #how many NA's per column, except this returns ALL 140 cols
colSums(is.na(tidied_data))[colSums(is.na(tidied_data)) > 0]
#too many columns to  efficiently count
sum(colSums(is.na(tidied_data)) == 0)
#ONLY 7 columns with 100% complete data 
mean(is.na(tidied_data)) 
#82% has missing data 

#large majority of columns have missing data
#we cannot omit 82% of the data

#investigate how many rows aka batches have NA
rowSums(is.na(tidied_data))
# high levels of NAs eg 131/140 cols, missing 

mean(rowSums(is.na(tidied_data)))
# average number of missing values per row is 115 out 140 columns, so 82% of the data is missing per row on average.

summary(rowSums(!is.na(tidied_data)))
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#8.00   26.00   27.00   24.63   28.00   34.00
#only seeing maximum 34 columns with data


#Questions: 
#Have I pivoted correctly?
#Why did i go from 3.8% missing data to this??? Is this because I have pivoted wider and now each row is a batch, so the missingness is more apparent?
#am i removing rows or columns based on missingness? surely, rows as these are batches I cant use,  rather than parameters. 


