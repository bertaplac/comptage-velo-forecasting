# Load required packages
library(data.table)
library(dplyr)

######################################################################
######################### DATA LOAD ##################################
######################################################################

# Define the download directory
download_dir <- "C:/Users/BertaPla/Downloads/historique_comptage_velo"

# Create the directory if it doesn't exist
if (!file.exists(download_dir)) {
  dir.create(download_dir)
}

# Define the base URL and years
base_url <- "https://parisdata.opendatasoft.com/api/datasets/1.0/comptage-velo-historique-donnees-compteurs/attachments/"
years <- 2017:2023

# Define possible URL suffixes
url_suffixes <- c("_comptage_velo_donnees_sites_comptage_csv_zip/", 
                  "_comptage_velo_donnees_sites_comptage_zip/")

# Loop through each year and try to download the corresponding zip file
for (year in years) {
  success <- FALSE
  for (suffix in url_suffixes) {
    # Construct the URL for the current year
    url <- paste0(base_url, year, suffix)
    
    # Extract the filename from the URL
    filename <- paste0(year, "_comptage_velo.zip")
    
    # Construct the full path where the file will be saved
    filepath <- file.path(download_dir, filename)
    
    # Attempt to download the file
    tryCatch({
      download.file(url, destfile = filepath, mode = "wb")
      success <- TRUE
      cat(sprintf("Downloaded %s from %s\n", filename, url))
      break # Exit the loop if the download was successful
    }, error = function(e) {
      cat(sprintf("Failed to download from %s. Trying next option...\n", url))
    })
  }
  
  if (!success) {
    cat(sprintf("Failed to download %s after trying all options.\n", filename))
  }
}

cat("All files processed!\n")

# List all zip files in the directory
zip_files <- list.files(download_dir, pattern = "\\.zip$", full.names = TRUE)

# Function to extract only the CSV files and rename them
extract_csv <- function(zip_file) {
  # Create a temporary directory for extraction
  temp_dir <- tempdir()
  
  # Extract the zip file to the temporary directory
  unzip(zip_file, exdir = temp_dir)
  
  # Get the list of files in the temporary directory
  extracted_files <- list.files(temp_dir, full.names = TRUE)
  
  # Find the CSV file(s)
  csv_files <- grep("\\.csv$", extracted_files, value = TRUE)
  
  # If there are CSV files, move them to the download_dir and rename them
  if (length(csv_files) > 0) {
    for (csv_file in csv_files) {
      # Create a new name for the CSV file based on the zip file name
      zip_filename <- basename(zip_file)
      csv_filename <- sub("\\.zip$", ".csv", zip_filename)
      dest_file <- file.path(download_dir, csv_filename)
      
      # Move the CSV file to the destination directory
      file.copy(csv_file, dest_file, overwrite = TRUE)
      
      # Print a message indicating successful extraction
      cat(sprintf("Extracted %s to %s\n", csv_file, dest_file))
    }
  } else {
    cat(sprintf("No CSV file found in %s\n", zip_file))
  }
}

# Loop through each zip file and extract the CSV files
for (zip_file in zip_files) {
  extract_csv(zip_file)
}

# List all CSV files in the directory that match the pattern
csv_files <- list.files(download_dir, pattern = "\\d{4}_comptage_velo.csv", full.names = TRUE)

# Function to read and concatenate CSV files
df <- rbindlist(lapply(csv_files, fread, sep = ";"), fill = TRUE)

# Filter rows starting from 2020 to reduce size of df
df <- df %>%
  filter(year(df$`Date et heure de comptage`) >= 2020)

saveRDS(df, file = "data/df.rds")
