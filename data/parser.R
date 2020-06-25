# https://github.com/chrisrzhou/RShiny-StateCrimeRates

library(dplyr)
library(reshape2)

# desactivar advertencias NA NO EXISTENTES innecesarias
options(warn=-1)


# =========================================================================
# function get_crime_data
#
# @description: get data from FBI url: 
# http://www.ucrdatatool.gov/Search/Crime/State/StatebyState.cfm
#               CSV data can be obtained by querying:
#                   - for 50 states (except District of Columbia)
#                   - "Violent crime rates" and "property crime rates"
#               The saved CSV is conveniently provided in this project as "data.csv"
# @return: reshaped dataframe of crime statistics by state, year and crime
# =========================================================================

get_crime_data <- function(file) {
    states <- c(
        "Alhue" = "AL",
        "Buin" = "AK",
        "Calera de tango" = "AZ"

    )
    
    # load data from csv
    df <- read.csv(
        file = file,
        header = FALSE,
        stringsAsFactors = FALSE,
        na.strings = c("", ".", "NA")
    )
    
    # limpiar datos CSV mal formados:
    
    # el encabezado de la columna está en la fila 4
    colnames(df) <- df[4,]  
    
    # remove columns containing all NAs in malformed csv
    df <- df[, colSums(is.na(df)) < nrow(df)]  
    df <- df %>%
        rename(year = Anio) %>%
        mutate(year = as.integer(year)) %>%
        # removes header rows (years not coerced to integer)
        na.omit() %>%  
        # manual observation: csv data is incomplete for years < 1965
        filter(year >= 1965)  
    
    # get number of years to add states column
    years <- unique(df$year)  
    
    # reshape df from wide to long
    df <- df %>% mutate(
            state = rep(unname(states), each = length(years)),
            state_name = rep(names(states), each = length(years))
        )  
    
    # add states column
    # melt from wide to long
    df <- melt(df, id = c("year", "state", "state_name")) %>%  
        rename(crime = variable) %>%
        mutate(crime = as.character(crime),
               value = as.numeric(value)) %>%
        filter(crime != "Population") %>%
        arrange(-year, crime, state)
    return(df)
}

