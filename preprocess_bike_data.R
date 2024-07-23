# Load the required libraries
library(ggplot2)
library(dplyr)
library(zoo)

# Read the data
df <- readRDS("data/df.rds")

# Rename columns for simplicity
df <- df %>%
  rename(
    point_id = `Identifiant du point de comptage`,
    point_name = `Nom du point de comptage`,
    count = `Comptage horaire`,
    datetime = `Date et heure de comptage`,
    link = `Lien vers photo du point de comptage`,
    coords = `Coordonnées géographiques`,
    instal_date = `Date d'installation du point de comptage`
  )

# Get unique points of comptage
unique_points <- unique(df$point_id)

# Plot each time series separately
plots <- lapply(unique_points, function(point_id) {
  
  # Filter data for the current point of comptage
  df_subset <- df[df$point_id == point_id, ]
  
  # Create ggplot for the current subset
  ggplot(df_subset, aes(x = datetime, y = count)) +
    geom_line() +
    labs(x = "Datetime", y = "Hourly Count",
         title = paste("Time Series Plot for Point", point_id)) +
    theme_minimal()
})

# Print each plot
for (i in seq_along(plots)) {
  print(plots[[i]])
}

# Convert POSIXct to Date and sum daily count per point_id
df_daily_sum <- df %>%
  mutate(Date = as.Date(datetime)) %>%
  group_by(Date, point_id) %>%
  summarise(Total_Count = sum(count, na.rm = TRUE)) %>%
  ungroup()

# Function to find counters with 14-day rolling sum of Total_Count equal to 0
find_filtered_counters <- function(df) {
  df %>%
    group_by(point_id) %>%
    mutate(rolling_sum = rollsum(Total_Count == 0, 14, align = "right", fill = NA)) %>%
    filter(rolling_sum == 14) %>%
    summarize()
}

# Get filtered counters
filtered_counters <- find_filtered_counters(df_daily_sum)

# Filter df to exclude counters in filtered_counters
filtered_df <- df %>%
  anti_join(filtered_counters, by = "point_id") 

# View the filtered dataset
head(filtered_df)

# Sort data by point_id and datetime
filtered_df <- filtered_df %>%
  arrange(point_id, datetime)

# Split data frame into a list of data frames by point_id
df_list <- split(filtered_df, f = filtered_df$point_id)

# Optionally, assign names to the list elements based on point_id
names(df_list) <- paste("df_", names(df_list), sep = "")

saveRDS(df_list, file = "data/df_list.rds")