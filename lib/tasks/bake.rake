namespace 'bake' do
  require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
  require 'net/http'
  require 'csv'
  
  task :franchise_years do
    teams = Team.find(:all)
    
    teams.each do |team|
      team_stats = TeamStats.find(:all, :conditions => {:team_id => team.id})
      
      start_year = 999999
      end_year = 0
      
      if team_stats.kind_of?(Array)
        team_stats.each do |ts|
          start_year = ts.year if ts.year < start_year
          end_year = ts.year if ts.year > end_year
        end
      else
        start_year = team_stats.year
        end_year = team_stats.year
      end
      
      
      team.start_year = start_year
      team.last_year = end_year
      team.save
    end
  end
  
  
  task :game_season do
    games= Game.find(:all)
    games.each do |game|
      date = game.date_played
      if date.month < 9
        game.season = date.year
      else
        game.season = date.year + 1
      end
      game.save
    end
  end
  
  task :validate_team_seasons do
    team_stats = TeamStats.find(:all, :conditions => {:validated => nil})
    team_stats.each do |ts|
      ts.g = ts.wins + ts.losses
      ts.fgpercent  = ts.fg.to_f/ts.fga    if ts.fga > 0
      ts.tfgpercent = ts.tfg.to_f/ts.tfga  if ts.tfga > 0
      ts.ftpercent  = ts.ft.to_f/ts.fta    if ts.fta > 0
      ts.o_fgpercent  = ts.o_fg.to_f/ts.o_fga    if ts.o_fga > 0
      ts.o_tfgpercent = ts.o_tfg.to_f/ts.o_tfga  if ts.o_tfga > 0
      ts.o_ftpercent  = ts.o_ft.to_f/ts.o_fta    if ts.o_fta > 0
      
      games = Game.find(:all, :conditions => "season = #{ts.year} and game_type = '#{ts.season_type}' and (home_team_id = #{ts.team_id} or away_team_id = #{ts.team_id})", :order => :date_played)
      
      last_date = "1900-01-01"
      last_home_id = 0
      last_home_pts = 0
      last_away_id = 0
      last_away_pts = 0
      wins = 0
      losses = 0
      games.each do |game|
        if game.date_played.to_s == last_date && game.home_team_id == last_away_id && 
          game.away_team_id == last_home_id && game.home_pts == last_away_pts && game.away_pts == last_home_pts
          #puts "DOUBLE"
        else
          if game.home_team_id == ts.team_id 
            if game.home_pts > game.away_pts
              wins += 1
            else
              losses += 1
            end
          elsif game.away_team_id == ts.team_id 
            if game.home_pts > game.away_pts
              losses += 1
            else
              wins += 1
            end
          end
        end
        last_date, last_home_id, last_home_pts, last_away_id, last_away_pts = game.date_played.to_s, game.home_team_id, game.home_pts,game.away_team_id,game.away_pts
        #puts game.date_played.to_s + " " + game.home_team_id.to_s + " vs " + game.away_team_id.to_s + " " + game.home_pts.to_s + " " + game.away_pts.to_s
      end
      puts "Team: #{ts.team_id} Season: #{ts.year} WINS: #{wins} LOSSES: #{losses}"
      if ts.wins == wins && ts.losses == losses
        ts.validated = true
      end
      ts.save
      
    end
  end
  
end