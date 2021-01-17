#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

# Load libraries
library(tidyr)
library(dplyr)
library(lubridate)
library(shiny)

# Date Calculations
start_date <- as.Date("1928-01-02")
start_year <- year(start_date)
end_date <- Sys.Date()
current_year <- year(end_date)
hlist <- c("USNewYearsDay","USMLKingsBirthday",
           "USWashingtonsBirthday","USGoodFriday","USMemorialDay",
           "USIndependenceDay","USLaborDay","USThanksgivingDay","USChristmasDay")        
trading_holidays <- dates(as.character(holiday(start_year:current_year,hlist)),format="Y-M-D")
max_date <- as.Date("2021-01-18") # end_date
while(is.holiday(max_date,trading_holidays) || isWeekend(max_date, wday = 1:5)) max_date <- max_date - 1
max_date <- max_date - 1
while(is.holiday(max_date,trading_holidays) || isWeekend(max_date, wday = 1:5)) max_date <- max_date - 1
default_date = end_date - 6
today <- format(end_date, "%B %d, %Y")


# Define UI for application that draws a plot of SNP with volume for desired time frame
shinyUI(fluidPage(

    # Application title
    titlePanel("Interactive Chart of the S&P 500 (^GSPC)"),
    
    p(strong("Specify the starting date for the date range to change the chart.",style="color:green")),

    # Sidebar with a slider input for time frame of plot
    sidebarLayout(
        sidebarPanel(
            sliderInput("slider", "Slide ball to select starting date:", 
                        min = start_date,
                        max = max_date,
                        value = default_date)
        ),

        # Show a plot of the SNP for specified time frame
        mainPanel(
            plotlyOutput(outputId = "p")
        )
    )
))
