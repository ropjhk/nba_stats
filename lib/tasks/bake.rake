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
  
  task :game_stat_season do
    games = Game.find(:all)
    games.each do |g|
      game_stats = GameStat.find(:all, :conditions => {:game_id => g.id})
      game_stats.each do |gs|
        gs.season = g.season
        gs.save
      end
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
  
  task :validate_playoffs do
    games = Game.find(:all, :conditions => {:game_type => "playoff"}, :order => :date_played )
    
    games.each do |g|
      home_team_id = g.home_team_id
      away_team_id = g.away_team_id
      ps = PlayoffSeries.get_playoff_series(home_team_id, away_team_id, g.season)
      if ps.nil?
        ps = PlayoffSeries.new
        ps.favoured_team_id = home_team_id
        ps.underdog_team_id = away_team_id
        ps.year = g.season
        ps.save
      end
      ps.insert_next_game(g.id, home_team_id)
    end
    
    playoff_series = PlayoffSeries.find(:all, :order => "id desc")
    playoff_series.each do |ps|
      series_wins = 0
      series_winner = nil
      
      if !ps.game_7_id.nil?
        ps.games_played = 7
        series_winner = ps.game_7.winner
        series_wins += 1
      end
      if !ps.game_6_id.nil?
        ps.games_played = 6 if ps.games_played.nil?
        series_winner = ps.game_6.winner if series_winner.nil?
        if series_winner == ps.game_6.winner
          series_wins += 1
        end
      end
      if !ps.game_5_id.nil?
        ps.games_played = 5 if ps.games_played.nil?
        series_winner = ps.game_5.winner if series_winner.nil?
        if series_winner == ps.game_5.winner
          series_wins += 1
        end
      end
      if !ps.game_4_id.nil?
        ps.games_played = 4 if ps.games_played.nil?
        series_winner = ps.game_4.winner if series_winner.nil?
        if series_winner == ps.game_4.winner
          series_wins += 1
        end
      end
      if !ps.game_3_id.nil?
        ps.games_played = 3 if ps.games_played.nil?
        series_winner = ps.game_3.winner if series_winner.nil?
        if series_winner == ps.game_3.winner
          series_wins += 1
        end
      end
      if !ps.game_2_id.nil?
        ps.games_played = 2 if ps.games_played.nil?
        series_winner = ps.game_2.winner if series_winner.nil?
        if series_winner == ps.game_2.winner
          series_wins += 1
        end
      end
      if !ps.game_1_id.nil?
        ps.games_played = 1 if ps.games_played.nil?
        series_winner = ps.game_1.winner if series_winner.nil?
        if series_winner == ps.game_1.winner
          series_wins += 1
        end
      end
      ps.series_winner_id = series_winner
      
      if series_wins == 1
        ps.best_of = 1
      elsif series_wins == 2
        ps.best_of = 3
      elsif series_wins == 3
        ps.best_of = 5
      elsif series_wins == 4
        ps.best_of = 7
      end
      
      ps.save
    end
    
  end
  
  task :bake_playoff_series do
    playoff_series = PlayoffSeries.find(:all, :order => "id desc")
    playoff_series.each do |ps|
      ps.round_from_finals = -1
      ps.save
    end
    year = 99999
    playoff_series.each do |ps|
      if ps.year < year
        ps.round_from_finals = 0
        year = ps.year
      else
        series_winner_id = ps.series_winner_id
        next_series = PlayoffSeries.find(:first, :conditions => "(favoured_team_id = #{series_winner_id} or underdog_team_id = #{series_winner_id}) and year = #{ps.year} and round_from_finals != -1",:order => "id")
        if next_series.nil?
          ps.round_from_finals = 0
        else
          round = next_series.round_from_finals + 1
          ps.round_from_finals = round
        end
      end
      
      ps.save
    end
  end
  
  task :setup_last_name_aka do
    players = Player.find(:all)
    players.each do |p|
      last_name = p.last_name
      lns = last_name.split(" ")
      if lns.length > 1 && p.last_name_aka.nil?
        p.last_name_aka = lns[lns.length-1]
        p.save
      end
    end
  end
  
  task :setup_stats_team_id do
    stats = Stats.find(:all)
    stats.each do |s|
      team_stat = s.team_stats
      puts team_stat.id
      team = team_stat.team
      s.team_id = team.id
      s.save
    end
  end
  
  task :draft_data do
    players = Player.find(:all)
    players.each do |p|
      drafts = p.drafts.find_all_by_league("N")
      if !drafts.nil? && drafts.length == 1
        draft = drafts[0]
        p.draft_round = draft.draft_round
        p.draft_position = draft.selection
        p.draft_year = draft.year
        p.save
      end
    end
  end
  
  task :validate_box_scores do
    games=Game.find(:all, :conditions => "home_fg > 0 and validated <> 1")
    games.each do |game|
      game.validated = vbs(game)
      game.save
    end
  end
  
  def vbs(game)
    valid = true #assume true
    away_game_stats = GameStat.find(:all, :conditions => {:game_id => game.id, :team_id => game.away_team_id})
    tm = summate(away_game_stats)
    valid = false if game.away_pts != tm[:pts]
    valid = false if game.away_trb != tm[:trb]
    valid = false if game.away_ast != tm[:ast]
    valid = false if game.away_stl != tm[:stl]
    valid = false if game.away_tov != tm[:tov]
    valid = false if game.away_pf != tm[:pf]
    
    home_game_stats = GameStat.find(:all, :conditions => {:game_id => game.id, :team_id => game.home_team_id})
    tm = summate(home_game_stats)
    valid = false if game.home_pts != tm[:pts]
    valid = false if game.home_trb != tm[:trb]
    valid = false if game.home_ast != tm[:ast]
    valid = false if game.home_stl != tm[:stl]
    valid = false if game.home_tov != tm[:tov]
    valid = false if game.home_pf != tm[:pf]
    return valid
  end
  
  def summate(game_stats)
    test_matrix = {:pts=>0, :trb=>0, :ast=>0,:stl=>0,:tov=>0,:pf=>0}
    game_stats.each do |gs|
      test_matrix[:pts] += gs.pts
      test_matrix[:trb] += gs.trb
      test_matrix[:ast] += gs.ast
      test_matrix[:stl] += gs.stl
      test_matrix[:tov] += gs.tov
      test_matrix[:pf] += gs.pf
    end
    return test_matrix
  end
  
  task :resolve_neutrality do
    #games = Game.find(:all, :conditions => :neutral => 1, :order => "notes, date_played")
    #[{"Bethlehem, PA", 63},{"Camden, NJ", 63}, {"Dayton, OH", 17}]
    #games.each do |g|
  end
  
end