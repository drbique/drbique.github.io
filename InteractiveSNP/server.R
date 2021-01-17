#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(tidyr)
library(dplyr)
library(tidyquant)
library(tidyverse)
library(plotly)
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$p <- renderPlotly({

        # Fetch desired time frame
        from_date = input$slider
        
        # Data processing
        index <- as.data.frame(tq_get("^GSPC", from=from_date, to=Sys.Date(), 
                                      get = "stock.prices")) 
        index <- index[c("date","volume","adjusted")] 
        index <- index %>% rename(close=adjusted)

        plot_ly(index) %>%
            add_trace(x =~date, y=~volume, type='bar', name = 'Volume',
                      marker = list(color = '#90EE90'),
                      hoverinfo = "text",
                      text = ~paste(volume)) %>%
            add_trace(x = ~date, y = ~close, type="scatter", mode = "lines", 
                      name = 'Index', yaxis = 'y2',
                      line = list(color = ' #013220'),
                      hoverinfo = "text",
                      text = ~paste(close)) %>% 
            layout(title = "S & P 500",
                   xaxis = list(title = "Date"),
                   yaxis = list(side = 'right', title = 'Volume', 
                                showgrid = FALSE, zeroline = FALSE),
                   yaxis2 = list(side = 'left', overlaying = "y", 
                                 title = 'Index', showgrid = TRUE,
                                 zeroline = FALSE))

    })

})
