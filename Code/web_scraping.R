library(rvest)
library(dplyr)




#Sand box to test individual pieces of the for loop
nba_rookie_url = "https://www.basketball-reference.com/leagues/NBA_2020_rookies-career-stats.html"
nba_rookie_list = rvest::read_html(nba_rookie_url)
nba_rookie_df = nba_rookie_list %>% rvest::html_table()

nba_rookie_href =nba_rookie_list %>% 
  rvest::html_nodes("#fs-sidewall-right-container , .right+ .left") %>%
  rvest::html_nodes('a') %>%
  rvest::html_attr("href")

individual_url = "https://www.basketball-reference.com/players/a/alexaco02.html#all_advanced-playoffs_advanced"
individual_list = rvest::read_html(individual_url)
individual_name = individual_list %>% rvest::html_nodes("h1 span") %>% rvest::html_text()
individual_tables = individual_list %>% rvest::html_nodes("#advanced_sh h2") %>% rvest::html_table()
individual_Stats = cbind(Name=individual_name, as.data.frame(individual_list %>% rvest::html_nodes(xpath='//*[@id="div_advanced"]') %>% rvest::html_table()))




individual_Stats$Season = as.integer(gsub("-.*$", "", individual_Stats$Season) )
individual_Stats = individual_Stats[!is.na(individual_Stats$Season),]

test =individual_Stats %>%   group_by(Name,Season,Pos) %>%
  summarize(BPM = mean(BPM),MP=sum(MP))

## Sand box Ends Here





#Scraping the first four years of Basketball Reference BPM for players drafted from 2000 to 2019

#setting up data frame that will store all of the data
ncol = length(colnames(test)) + 2
all_players_stats = data.frame(matrix(nrow = 0, 
                           ncol = ncol)) 
colnames(all_players_stats) = c(colnames(test),'through_4_years','after_2010')

sportref_url = "https://www.basketball-reference.com"
nba_base_url = "https://www.basketball-reference.com/leagues/NBA_"

#for loop that loops through the 2000-2001 season through the 2019-2020 season
for (year in c(2001:2020)) {
    
  #Obtain all the URLs to the players pages for rookies
    nba_rookie_list = nba_base_url %>%
    paste0(paste0(toString(year),'_rookies-career-stats.html')) %>%
    rvest::read_html()
    
    nba_rookie_href =nba_rookie_list %>% 
      rvest::html_nodes("#fs-sidewall-right-container , .right+ .left") %>%
      rvest::html_nodes('a') %>%
      rvest::html_attr("href")
    
   #logic to assign the variable indicating whether a player is a post 2010 era player
    if (year>=2010) {
      after_2010 = 1
    }
    else{
      after_2010 = 0
    }
    
    
    for (player in nba_rookie_href) {
      individual_list =  sportref_url %>%
      paste0(player) %>% 
      paste0('#all_advanced-playoffs_advanced') %>%
      rvest::read_html()
      
      #Getting player name
      individual_name = individual_list %>% rvest::html_nodes("h1 span") %>% rvest::html_text()
      #Getting player advanced statistics
      individual_stats = cbind(Name=individual_name, as.data.frame(individual_list %>% rvest::html_nodes(xpath='//*[@id="div_advanced"]') %>% rvest::html_table()))
      
      #Changing the season variable from string to integer type
      individual_stats$Season = as.integer(gsub("-.*$", "", individual_stats$Season) )
      individual_stats = individual_stats[!is.na(individual_stats$Season),]
      
      #logic to check if a player made through rookie contract period
      if (any(individual_stats$Season >= (year + 2)) == TRUE) {
        individual_stats = cbind(individual_stats,through_4_years=1,after_2010 = after_2010)
        
      }
      
      else if (all(individual_stats$Season < (year + 2)) == TRUE) {
        individual_stats = cbind(individual_stats,through_4_years=0,after_2010 = after_2010)
      }
      
      #collapse stats from same season, take average of BPM from same year and sum up the minutes played
      individual_stats =  individual_stats %>%  
        group_by(Name,Season,Pos,through_4_years,after_2010) %>%
        summarize(BPM = mean(BPM),MP=sum(MP))
      
      
      #appending individual player stats to overall data frame
      all_players_stats =  rbind(all_players_stats,individual_stats)
    }
    #Subset stats from first 4 years
    all_players_stats = all_players_stats[all_players_stats$Season<=(year+2),]
    saveRDS(all_players_stats,file=paste0("upto_",toString(year)))
}

write.csv(all_players_stats,file = "all_players_stats.csv")
    

