namespace 'scrape' do
  require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
  require 'net/http'
  require 'csv'
  
  task :import_player_file do
    file_name = "#{Rails.root}/tmp/databasebasketball2009/players.csv"
    
    f = File.open(file_name)
    while (c = f.gets)
      line_array = c.split(",")
      
      player = Player.find_by_pid(line_array[0])
      if player.nil?
        player = Player.new
      end
      
      player.pid          = line_array[0]
      player.first_name   = line_array[1]
      player.last_name    = line_array[2]
      player.position     = line_array[3]
      player.height_inches  = line_array[6].to_i*12 + line_array[7].to_i
      player.weight_pounds  = line_array[8]
      player.college      = line_array[9] 
      player.birthday     = line_array[10]
      player.save
    end
  end
  
  task :import_team_file do
    file_name = "#{Rails.root}/tmp/databasebasketball2009/teams.csv"
    
    f = File.open(file_name)
    while (c = f.gets)
      line_array = c.split(",")
      
      team = Team.find_by_pid(line_array[0])
      if team.nil?
        team = Team.new
      end
      
      team.pid          = line_array[0]
      team.city         = line_array[1]
      team.franchise_name    = line_array[2]
      if line_array[3] == "N"
        team.league     = "NBA"
      elsif line_array[3] == "A"
        team.league     = "ABA"
      else
        team.league    = line_array[3]
      end
      team.save
    end
  end
  
  task :import_team_stats_file do
    file_name = "#{Rails.root}/tmp/databasebasketball2009/team_season.csv"
    season_type = "regular"
    
    f = File.open(file_name)
    while (c = f.gets)
      line_array = c.split(",")
      
      team = Team.find_by_pid(line_array[0])
      if !team.nil?
        team_stat = TeamStats.find(:first, :conditions => {:team_id => team.id, :year => line_array[1], :season_type => season_type})
        if team_stat.nil?
          team_stat = TeamStats.new
          team_stat.team_id = team.id
          team_stat.year = line_array[1]
          team_stat.season_type = season_type
        end
        team_stat.fg  = line_array[3]
        team_stat.fga = line_array[4]
        team_stat.ft  = line_array[5]
        team_stat.fta = line_array[6]
        team_stat.orb = line_array[7]
        team_stat.drb = line_array[8]
        team_stat.trb = line_array[9]
        team_stat.ast = line_array[10]
        team_stat.pf  = line_array[11]
        team_stat.stl = line_array[12]
        team_stat.tov = line_array[13]
        team_stat.blk = line_array[14]
        team_stat.tfg = line_array[15]
        team_stat.tfga  = line_array[16]
        team_stat.pts   = line_array[17]
        team_stat.o_fg  = line_array[18]
        team_stat.o_fga = line_array[19]
        team_stat.o_ft  = line_array[20]
        team_stat.o_fta = line_array[21]
        team_stat.o_orb = line_array[22]
        team_stat.o_drb = line_array[23]
        team_stat.o_trb = line_array[24]
        team_stat.o_ast = line_array[25]
        team_stat.o_pf  = line_array[26]
        team_stat.o_stl = line_array[27]
        team_stat.o_tov = line_array[28]
        team_stat.o_blk = line_array[29]
        team_stat.o_tfg = line_array[30]
        team_stat.o_tfga  = line_array[31]
        team_stat.o_pts   = line_array[32]
        team_stat.pace  = line_array[33]
        team_stat.wins  = line_array[34]
        team_stat.losses  = line_array[35]
        team_stat.save
      end
    end
  end
  
  task :import_player_stats_file do
    file_array = Array.new
    file_array << {:file_name => "#{Rails.root}/tmp/databasebasketball2009/player_regular_season.csv", :season_type => "regular"}
    file_array << {:file_name => "#{Rails.root}/tmp/databasebasketball2009/player_playoffs.csv", :season_type => "playoff"}
    
    file_array.each do |fa|
      file_name = fa[:file_name]
      season_type = fa[:season_type]
      
      f = File.open(file_name)
      while (c = f.gets)
        line_array = c.split(",")
        ppid = line_array[0].strip
        player = Player.find(:first, :conditions => {:pid => ppid})
        team_stat = TeamStats.find_by_team_and_year(line_array[4], line_array[1])
        if !player.nil? && !team_stat.nil?
          stat = Stats.find(:first, :conditions => {:player_id => player.id, :team_stat_id => team_stat.id, :season => line_array[1], :season_type => season_type})
          if stat.nil?
            stat = Stats.new
            stat.player_id = player.id
            stat.season = line_array[1]
            stat.team_stat_id = team_stat.id
            stat.season_type = season_type
          end
          stat.league = line_array[5]
          stat.g      = line_array[6]
          stat.mp  = line_array[7]
          stat.pts = line_array[8]
          stat.orb = line_array[9]
          stat.drb = line_array[10]
          stat.trb = line_array[11]
          stat.ast = line_array[12]
          stat.stl = line_array[13]
          stat.blk = line_array[14]
          stat.tov = line_array[15]
          stat.pf  = line_array[16]
          stat.fga = line_array[17]
          stat.fg  = line_array[18]
          if stat.fga > 0
            stat.fgpercent = stat.fg.to_f/stat.fga.to_f
          end
          stat.fta = line_array[19]
          stat.ft  = line_array[20]
          if stat.fta > 0
            stat.ftpercent = stat.ft.to_f/stat.fta.to_f
          end
          stat.tfga = line_array[21]
          stat.tfg  = line_array[22]
          if stat.tfga > 0
            stat.tfgpercent = stat.tfg.to_f/stat.tfga.to_f
          end
          stat.save
        end
      end
      
    end
  end

  task :import_coaches_file do
    file_name = "#{Rails.root}/tmp/databasebasketball2009/coaches_career.csv"
    
    f = File.open(file_name)
    while (c = f.gets)
      line_array = c.split(",")
      
      cpid = line_array[0].strip
      coach = Coach.find(:first, :conditions => {:pid => cpid})
      if coach.nil?
        coach = Coach.new
        coach.pid = cpid
        coach.first_name = line_array[1]
        coach.last_name = line_array[2]
      end
      coach.nba_career_reg_wins = line_array[3]
      coach.nba_career_reg_losses = line_array[4]
      coach.nba_career_playoff_wins = line_array[5]
      coach.nba_career_playoff_losses = line_array[6]
      coach.save
    end
  end
    
  task :import_coach_year_file do
    file_name = "#{Rails.root}/tmp/databasebasketball2009/coaches_data.csv"
    
    f = File.open(file_name)
    while (c = f.gets)
      line_array = c.split(",")
      
      league = "N"
      
      cpid = line_array[0].strip
      year = line_array[1]
      if year == "204"
        year = "2004"
      end
      tpid = line_array[9].strip
      coach = Coach.find(:first, :conditions => {:pid => cpid})
      team_stat = TeamStats.find_by_team_and_year(tpid, year)
      puts coach.first_name if !coach.nil?
      puts team_stat.year if !team_stat.nil?
      if !coach.nil? && !team_stat.nil?
        coach_year = CoachYear.find_by_coach_and_year(cpid, tpid) 
        if coach_year.nil?  
          coach_year = CoachYear.new
          coach_year.coach_id = coach.id
          coach_year.team_stats_id = team_stat
          coach_year.year = year
        end
        coach_year.yr_order = line_array[2]
        coach_year.league = league
        coach_year.season_wins = line_array[5]
        coach_year.season_losses = line_array[6]
        coach_year.playoff_wins = line_array[7]
        coach_year.playoff_losses = line_array[8]
        coach_year.save
      end
    end
  end
  
  task :import_draft do
    
  end

end
