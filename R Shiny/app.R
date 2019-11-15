library(shiny)
library(leaflet)
library(dplyr)
library(leaflet.extras)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- navbarPage("Institutional Information",
                 
                             
                #Description Tab
                tabPanel("Description", h4("Looking at College and University Data across the U.S."),
                          textOutput("text")),
                
                #Interactive Map Tab - Filter based on level of control 
                tabPanel("Map", leafletOutput("Map"), hr(), 
                         fluidRow(
                             column(3, 
                                    selectInput("state", label = "Select State:",
                                                choices = c("All",
                                                            "Alabama" = "AL",
                                                            "Alaska" = "AK",
                                                            "Arizona" = "AZ",
                                                            "Arkansas" = "AR",
                                                            "California" = "CA",
                                                            "Colorado" = "CO",
                                                            "Connecticut" = "CT",
                                                            "Delaware" = "DE",
                                                            "District of Columbia" = "DC",
                                                            "Florida" = "FL",
                                                            "Georgia" = "GA",
                                                            "Hawaii" = "HI",
                                                            "Idaho" = "ID",
                                                            "Illinois" = "IL",
                                                            "Indiana" = "IN",
                                                            "Iowa" = "IA",
                                                            "Kansas" = "KS",
                                                            "Kentucky" = "KY",
                                                            "Louisiana" = "LA",
                                                            "Maine" = "ME",
                                                            "Maryland" = "MD",
                                                            "Massachusetts" = "MA",
                                                            "Michigan" = "MI",
                                                            "Minnesota" = "MN",
                                                            "Mississippi" = "MS",
                                                            "Missouri" = "MO",
                                                            "Montana" = "MT",
                                                            "Nebraska" = "NE",
                                                            "Nevada" = "NV",
                                                            "New Hampshire" = "NH",
                                                            "New Jersey" = "NJ",
                                                            "New Mexico" = "NM",
                                                            "New York" = "NY",
                                                            "North Carolina" = "NC",
                                                            "North Dakota" = "ND",
                                                            "Ohio" = "OH",
                                                            "Oklahoma" = "OK",
                                                            "Oregon" = "OR",
                                                            "Pennsylvania" = "PA",
                                                            "Rhode Island" = "RI",
                                                            "South Carolina" = "SC",
                                                            "South Dakota" = "SD",
                                                            "Tennessee" = "TN",
                                                            "Texas" = "TX",
                                                            "Utah" = "UT",
                                                            "Vermont" ="VT",
                                                            "Virgina" = "VA",
                                                            "Washington" = "WA",
                                                            "West Virginia" = "WV",
                                                            "Wisconsin" = "WI",
                                                            "Wyoming" = "WY"),
                                                multiple = FALSE
                                                ),

                                    selectInput("level", label = "Select Institution Level", 
                                                choices = c("All", 
                                                            "4 or More years" = 1,
                                                            "At least 2 but less than 4 years" = 2,
                                                            "Less than 2 years" = 3)
                                                ),

                                    selectInput("hbcu", label = "Historically Black College or University",
                                                choices = c("All",
                                                            "Yes" = 1,
                                                            "No" = 2)
                                                ),
                                    
                                    selectInput("tribal", label = "Tribal College",
                                                choices = c("All",
                                                            "Yes" = 1,
                                                            "No" = 2)
                                                ),
                                    selectInput("land", label = "Land Grant Instittution",
                                                choices = c("All",
                                                            "Yes" = 1,
                                                            "No" = 2)
                                                ),
                                    
                                    selectInput("urban", label = "Degree of Urbanization",
                                                choices = c("All",
                                                            "Large City" = 11,
                                                            "Midsize City" = 12,
                                                            "Small City" = 13,
                                                            "Large Suburb" = 21,
                                                            "Midsize Suburb" = 22,
                                                            "Small Suburb" = 23,
                                                            "Fringe Town" = 31,
                                                            "Distant Town" = 32,
                                                            "Remote Town" = 33,
                                                            "Fringe Rural" = 41,
                                                            "Distant Rural" = 42,
                                                            "Remote Rural" = 43)
                                                )
                                    ),
                             column(5, offset = 0,
                                    tableOutput("table2"))
                )),
                
                tabPanel("Institution by State (Plot)", plotOutput("plot"), hr(),
                         fluidRow(
                             column(3, 
                                    checkboxGroupInput("sector",
                                                       "Types of Sectors:",
                                                       choices = list('Administrative Unit' = 0,
                                                                      'Public, 4-yr or Above' = 1,
                                                                      "Private not-for-profit, 4-yr or Above" = 2,
                                                                      "Private for-profit, 4-yr or Above" = 3,
                                                                      "Public, 2-yr" = 4,
                                                                      "Private not-for-profit, 2-yr" = 5,
                                                                      "Private for-profit, 2-yr" = 6,
                                                                      "Public, Less than 2-yr" = 7,
                                                                      "Private not-for-profit, less than 2-yr" = 8,
                                                                      "Private for-profit, less than 2-yr" = 9),
                                                       selected = c("Administrative Unit" = 0, 
                                                                    "Public, 4-yr or Above" = 1,
                                                                    "Private not-for-profit, 4-yr or Above" = 2,
                                                                    "Private for-profit, 4-yr or Above" = 3,
                                                                    "Public, 2-yr" = 4,
                                                                    "Private not-for-profit, 2-yr" = 5,
                                                                    "Private for-profit, 2-yr" = 6,
                                                                    "Public, Less than 2-yr" = 7,
                                                                    "Private not-for-profit, less than 2-yr" = 8,
                                                                    "Private for-profit, less than 2-yr" = 9)
                                                       )
                                    
                                    ))
                           ),

                tabPanel("List of Institutions",
                         fluidRow(
                             column(3, 
                                    selectInput("state2", label = "Select State:",
                                       choices = c("All",
                                                   "Alabama" = "AL",
                                                   "Alaska" = "AK",
                                                   "Arizona" = "AZ",
                                                   "Arkansas" = "AR",
                                                   "California" = "CA",
                                                   "Colorado" = "CO",
                                                   "Connecticut" = "CT",
                                                   "Delaware" = "DE",
                                                   "District of Columbia" = "DC",
                                                   "Florida" = "FL",
                                                   "Georgia" = "GA",
                                                   "Hawaii" = "HI",
                                                   "Idaho" = "ID",
                                                   "Illinois" = "IL",
                                                   "Indiana" = "IN",
                                                   "Iowa" = "IA",
                                                   "Kansas" = "KS",
                                                   "Kentucky" = "KY",
                                                   "Louisiana" = "LA",
                                                   "Maine" = "ME",
                                                   "Maryland" = "MD",
                                                   "Massachusetts" = "MA",
                                                   "Michigan" = "MI",
                                                   "Minnesota" = "MN",
                                                   "Mississippi" = "MS",
                                                   "Missouri" = "MO",
                                                   "Montana" = "MT",
                                                   "Nebraska" = "NE",
                                                   "Nevada" = "NV",
                                                   "New Hampshire" = "NH",
                                                   "New Jersey" = "NJ",
                                                   "New Mexico" = "NM",
                                                   "New York" = "NY",
                                                   "North Carolina" = "NC",
                                                   "North Dakota" = "ND",
                                                   "Ohio" = "OH",
                                                   "Oklahoma" = "OK",
                                                   "Oregon" = "OR",
                                                   "Pennsylvania" = "PA",
                                                   "Rhode Island" = "RI",
                                                   "South Carolina" = "SC",
                                                   "South Dakota" = "SD",
                                                   "Tennessee" = "TN",
                                                   "Texas" = "TX",
                                                   "Utah" = "UT",
                                                   "Vermont" ="VT",
                                                   "Virgina" = "VA",
                                                   "Washington" = "WA",
                                                   "West Virginia" = "WV",
                                                   "Wisconsin" = "WI",
                                                   "Wyoming" = "WY"),
                                       multiple = TRUE,
                                       selected = "Disrict of Columbia")
                )),
                hr(),
                tableOutput("table")
        )
)

server <- function(input, output) {
  
    data <- read.csv("16_University_Data.csv", header = TRUE)
    
    #Create Output Table
    output$table <- renderTable({
        
        #Save data as data frame
        table <- data.frame(data)
        
        if(is.null(table))
            return(NULL)
        
        else {
            if(is.null(input$state2))
                print(table %>% select(UnitID, Institution, City, State) %>% arrange(State))
            
            else {
                #Filter for different states selected by user
                table <- table[table$State %in% input$state2,]
                
                #Filter out columns and Arrange by State
                table <- table %>% select(UnitID,Institution, City, State) %>% arrange(State)
                
                
                print(table)
            }
        }
    })
    
    
    #Create Plot
    output$plot <- renderPlot({
        
        #Filter Data based on selected Sectors
        plot_data <- data[data$Sector %in% c(input$sector),]
        
        #Create ggplot
        plot <- ggplot(plot_data,aes(x = State)) + geom_bar()  +
            ylab("Number of Universities") + xlab("States")
        
        #plot
        plot
    })
    
    
    #Create map
    output$Map <- renderLeaflet({
        pal = colorFactor(palette = c("red", "blue", "green"), 
                          levels = c(1,2,3))
        
        #Filter Data for Map
        data_map <- data
        
        if ("All" %in% input$state)
            data_map = data_map
        
        else 
            data_map = data_map %>% filter(State == input$state)
        
        if ("All" %in% input$level)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(Level == input$level)
        
        if ("All" %in% input$hbcu)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(HBCU == input$hbcu)
        
        if("All" %in% input$tribal)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(Tribal == input$tribal)
        
        if ("All" %in% input$land)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(Land_Grant == input$land)
        
        if ("All" %in% input$urban)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(Urbanization == input$urban)

        #Create Map
        data_map %>% leaflet() %>% 
            
            #Add map tiles from wikimedia
            addProviderTiles(providers$Wikimedia) %>% 
            
            #Add map markers
            addCircleMarkers(label = ~Institution, 
                             lat = data_map$Latitude, lng = data_map$Longitude, 
                             weight = 1,
                             radius = 8,
                             col = ~pal(Control)) %>%
            
            #Add mini map to bottom left corner
            addMiniMap(position = "bottomleft") %>% 
            
            #Add legend in top right corner for Instution control
            addLegend(position = "topright", values = c(1,2, 3), colors = c("red","blue","green"),
                      labels = c("Public", "Private not-for-profit", "Private for-profit"))
    })
    
    #Create table to display alongside map
    output$table2 <- renderTable({
        
        #SFilter data
        data_map <- data
        
        if ("All" %in% input$state)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(State == input$state)
        
        if ("All" %in% input$level)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(Level == input$level)
        
        if ("All" %in% input$hbcu)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(HBCU == input$hbcu)
        
        if("All" %in% input$tribal)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(Tribal == input$tribal)
        
        if ("All" %in% input$land)
            data_map = data_map
        
        else
            data_map = data_map %>% filter(Land_Grant == input$land)
        
        if ("All" %in% input$urban)
            data_map = data_map
        
        else 
            data_map = data_map %>% filter(Urbanization == input$urban)

        
        #Print the table
        print(data_map %>% select(UnitID, Institution, City, State))
    })
    
    output$text <- renderText({
        "This application analyzes institutional data from IPEDS.
        The focus of the analysis is on Sector, Institutional levels, HBCU, Tribal Institutions, Degree of Urbanization, Land_Grant and Control of University.
        Application allows for users to look at universities geographically based on State, Institutional level, if it is a HBCU,
        if it is a Tribal College, if it is a land grant institution, and the degree of urbanization around the campus. 
        It also lets the user look at the number of institutions in a state based on the sector type. 
        And finally allows users to view a list of instititutions based on the state."
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
