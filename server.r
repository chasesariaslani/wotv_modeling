function(input, output){
  
  output$table <- DT::renderDataTable(DT::datatable({
    
    data <- character_list
    
    if (input$rarity != 'All'){
      data <- data[data$rarity == input$rarity,]
    } 
    
    if (input$name != 'All'){
      data <- data[data$full.name == input$name,]
    }
    
    if (input$region != "All"){
      data <- data[data$region == input$region,]
    }
    data
  },
    options = list(scrollX = TRUE) # adds scrollbar
  ))
  
  
    
  
  output$wotv_bar_graph <- renderPlot({
    character_list %>%
      filter(full.name == input$name1 | full.name == input$name2 | full.name == input$name3 | full.name == input$name4 | full.name == input$name5) %>%
      ggplot() +
      geom_bar(aes(x=full.name, y=total.stats, fill = full.name), stat ='identity') +
      xlab('Character Name') +
      ylab('Total Stats') +
      theme(axis.title=element_text(size=16),legend.title=element_blank())
  })
  
  
  output$wotv_scatterplot <- renderPlot({
      filter(.data=character_scatterplot, input$rareness == rarity) %>%
      ggplot() +
      geom_point(aes(x=!!input$x_axis, y=!!input$y_axis)) +
      theme(axis.title=element_text(size=16))
  })
  
  output$wotv_boxplot <- renderPlot({
    character_scatterplot %>%
      filter(rarity == 'UR') %>%
      ggplot() +
      geom_boxplot(aes(x=limited, y=!!input$limited_stats, fill=limited), color='black') +
      theme(axis.title=element_text(size=16),legend.title=element_blank()) +
      xlab('Exclusivisity')
  })
  
  output$wotv_month_graph <- renderPlot({
    characters_by_month %>%
      ggplot() +
      geom_point(aes(x=release.month, y=!!input$monthly_stats)) +
      xlab('Month Released') +
      theme(axis.title=element_text(size=16))
  })
  
  output$click_info <-renderPrint({
    nearPoints(character_scatterplot, input$plot_click) # creates print out of info on scatterplot
  })
  
  output$click_info2 <-renderPrint({
    nearPoints(characters_by_month, input$plot_click2) #creates print out of info on characters by month plot.
  })
  
}
