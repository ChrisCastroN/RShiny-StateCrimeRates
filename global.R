# =========================================================================
# Load libraries and scripts
# =========================================================================
library(shiny)
library(ggplot2)
library(scales)
source("data/parser.R")


# =========================================================================
# GET parsed data from parser.R script into dataframes
# =========================================================================
dataframes <- list(
    
    # la funcion get_crime_data, que esta en parser.R lee los datos del csv y les hace un tratamiento:
    crimes = as.data.frame(get_crime_data("data/prueba1.csv"))
)


# =========================================================================
# ui.R variables
# =========================================================================
choices <- list(
    crimes = unique(dataframes$crimes$crime),
    years = unique(dataframes$crimes$year),
    states = unique(dataframes$crimes$state),
    state_names = unique(dataframes$crimes$state_name)
)

recessions <- c(1973, 1974, 1975, 2007, 2008, 2009)