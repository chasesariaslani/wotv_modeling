dashboardPage(
  dashboardHeader(title = "WOTV Modeling"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName='about', icon=icon('address-card')),
      menuItem("Scatterplot", tabName='scatterplot', icon=icon('running')),
      menuItem('Character Stats Bar Graph', tabName='stats_graph', icon=icon('chart-bar')),
      menuItem('Limited Comparison Box Plot', tabName='boxplot_graph', icon=icon('box')),
      menuItem('Stats by Release Month', tabName='month_graph', icon=icon('calendar-week')),
      menuItem("Database", tabName='database', icon=icon('database'))
    )
  ),
  dashboardBody(
    
    tabItems(
    tabItem(tabName='about',
            h1('FFBE: War of the Visions'),
            p('Final Fantasy Brave Exvius: War of the Visions (FFBE: WOTV) is the successor and tangential game to Final Fantasy Brave Exvius (FFBE).
              The game follows mechanics quite similar to Final Fantasy Tactics, a 1997 cult classic made by Squaresoft (now Square-Enix).
              This freemium game was originally released in Japan in late 2019 and came out globally on March 25th, 2020. This game was made in tandem
              with Alim/Gumi and published by Square-Enix. The game collaborates with many Final Fantasy characters such as Final Fantasy 1 and Final Fantasy 4.
              Unfortunately, sales data is difficult to track but on the Android alone during the month of July, it has been downloaded over 60,000 times and has made 2 million
              dollars, a sign that a game months after release is making profits (Sensor Tower).'),
            p('This application is to help make informative decisions about in-game purchases of characters in the game. Gumi in its previous game, Brave Frontier, was notorious 
              for power creeping. Meaning, as time went on, prior characters became obselete and unable to measure up with PvP (Player vs Player) and PVE (Player vs Environment).
              The graphs are to judge if limited-time characters are signifcantly better than non-limited characters as well as see progressions of characters during
              the months since its release.'),
            img(src='Mont_Image.png', height='30%', width='30%')
            ),
    tabItem(tabName='scatterplot',
            h1('Stat Comparison Scatterplot'),
            varSelectInput('x_axis', 'X-stat', subset(character_scatterplot, select=c(-rarity, -full.name, -limited))),
            varSelectInput('y_axis', 'Y-stat', subset(character_scatterplot, select=c(-rarity, -full.name, -limited))),
            selectInput('rareness', 'Rarity', choices=unique(character_scatterplot$rarity)),
            h4("Character Stats Scatterplot", align='center'),
            plotOutput("wotv_scatterplot", click="plot_click"),
            verbatimTextOutput('click_info')),
    tabItem(tabName='stats_graph',
            h1('Comparison Between Characters'),
            selectInput("name1", "1st Character Name", choices = character_list$full.name),
            selectInput("name2", "2nd Character Name", choices = character_list$full.name),
            selectInput("name3", "3rd Character Name", choices = character_list$full.name),
            selectInput("name4", "4th Character Name", choices = character_list$full.name),
            selectInput("name5", "5th Character Name", choices = character_list$full.name),
            h4('Total Stats by Name Bar Graph', align='center'),
            plotOutput("wotv_bar_graph")),
    tabItem(tabName = 'boxplot_graph',
            h1('Limited Vs Non-Limited'),
            varSelectInput('limited_stats', 'Limit Stats', subset(character_scatterplot, select=c(-rarity, -full.name, -limited))),
            h4("UR Characters Limited vs Non-limited Boxplot", align='center'),
            plotOutput('wotv_boxplot')),
    tabItem(tabName='month_graph',
            h1('Stat Comparision Since Release (Global Only)'),
            varSelectInput('monthly_stats', 'Stats', subset(characters_by_month, select=c(-global_release, -release.month, -full.name))),
            h4('Character Stats by Month', align='center'),
            plotOutput("wotv_month_graph", click='plot_click2'),
            verbatimTextOutput('click_info2')),
    tabItem(tabName='database',
            fluidRow(column(4,
                            selectInput("rarity",
                                        "Rarity:",
                                        c(
                                          "All",
                                          unique(character_list$rarity)
                                        ))),
                     column(4,
                            selectInput(
                              "name",
                              "Character Name:",
                              c("All",
                                unique(character_list$full.name))
                            )),
                     column(4,
                            selectInput(
                              "region",
                              "Current Region:",
                              c("All",
                                unique(character_list$region))
                            ))),
    # Create a new row for the table.
    DT::dataTableOutput("table")
    )
    )
  )
)
