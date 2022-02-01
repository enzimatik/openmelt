library(tidyverse)
library(reshape)
library(ggplot2)
library(plotly)
library(shiny)

hrm <- function(data, temp, ref) {
  # subset by temperature range
  data <- data[data$Temperature > temp[1] & data$Temperature < temp[2], ]

  # divide temp and values
  data.temperature <- data["Temperature"]
  data.value <- data[, -1]

  # normalize
  data.normal <- list()
  for (i in names(data.value)) {
    data.normal[[i]] <- (data.value[i] - min(data.value[i])) / (max(data.value[i]) - min(data.value[i])) * 100
  }
  data.normal <- do.call(cbind, data.normal)

  # delta
  data.delta <- list()
  for (i in names(data.value)) {
    data.delta[[i]] <- (c(0, diff(data.normal[[i]])))*(-1)
  }
  data.delta <- do.call(cbind, data.delta)
  
  # difference based on reference
  data.diff <- list()
  for (i in names(data.value)) {
    data.diff[[i]] <- data.normal[[i]] - data.normal[[ref]]
  }
  data.diff <- do.call(cbind, data.diff)
  
  # classification
  fit <- kmeans(t(data.diff), 2)
  class_ <- data.frame(
    variable = names(fit$cluster),
    class = fit$cluster,
    row.names = NULL
  )
  class_$class <- as.factor(class_$class)
  
  # bind dataframe
  data.ori <- cbind(data.temperature, data.value)
  data.ori <- melt(data.ori, id = "Temperature")
  data.normal <- cbind(data.temperature, data.normal)
  data.normal <- melt(data.normal, id = "Temperature")
  data.delta <- cbind(data.temperature, data.delta)
  data.delta <- melt(data.delta, id = "Temperature")
  data.diff <- cbind(data.temperature, data.diff)
  data.diff <- melt(data.diff, id = "Temperature")
  data.diff <- merge(data.diff, class_, by = "variable")
  
  # draw ggplot
  a <- ggplot(data.ori,
    aes(x = Temperature,
        y = value,
        group = variable,
        color = variable)) +
    geom_line() +
    theme(legend.position='none')

  b <- ggplot(data.normal,
    aes(x = Temperature,
        y = value,
        group = variable,
        color = variable)) +
    geom_line() +
    theme(legend.position='none')

  c <- ggplot(data.delta,
    aes(x = Temperature,
        y = value,
        group = variable,
        color = variable)) +
    geom_line() +
    theme(legend.position='none')

  d <- ggplot(data.diff,
    aes(x = Temperature,
        y = value,
        group = variable,
        color = class)) +
    geom_line() +
    theme(legend.position='none')

  return(list(a,b,c,d))
  
  # e <- plot_ly(data.diff, 
  #              x = ~Temperature, 
  #              y = ~value, 
  #              group = ~variable, 
  #              color = ~class,
  #              mode = 'lines')
  # return(e)
}

# hrm(data, c(75, 88), "J14")

## Shiny
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file", label = "Input", placeholder = "xls or csv files"),
    ),
    mainPanel(
      plotlyOutput("plot1"),
      plotlyOutput("plot2"),
      plotlyOutput("plot3"),
      plotlyOutput("plot4")
    )
  )
)

server <- function(input, output) {
  observe({
    file <- input$file
    if (!is.null(file)) {
      data <- read.csv(file$datapath)
      plots <- hrm(data, c(75, 88), "J14")

      output$plot1 <- renderPlotly({
        ggplotly(plots[[1]])
        # plot_ly(plots)
      })
      output$plot2 <- renderPlotly({
        ggplotly(plots[[2]])

      })
      output$plot3 <- renderPlotly({
        ggplotly(plots[[3]])

      })
      output$plot4 <- renderPlotly({
        ggplotly(plots[[4]])

      })
    }
  })
}

shinyApp(ui, server)
