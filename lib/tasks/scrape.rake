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
  
  task :import_all_nba do 
    file_name = "#{Rails.root}/tmp/databasebasketball2009/all_nba.csv"
    
    f = File.open(file_name)
    
    f_pos = "sf"
    g_pos = "pg"
    while (c = f.gets)
      line_array = c.split(",")
      
      if line_array[0].include?("NBA") || line_array[0].include?("ABA")
        if line_array[0].include?("NBA")
          league = "N"
        else
          league = "A"
        end
        year = line_array[0][0..3].to_i + 1
      elsif line_array[0].include?("Team")
        team = line_array[0][0]
      else
        award = Awards.find(:first, :conditions=>{:year=>year,:league=>league})
        if award.nil?
          award = Awards.new
          award.year=year
          award.league=league
        end
        if year > 1955
          0.upto(1) do |i|
            if !line_array[i].nil?
              position = line_array[i][0].downcase
              if position == "f"
                position = f_pos
                if f_pos == "sf"
                  f_pos = "pf" 
                else
                  f_pos = "sf"
                end
              end
              if position == "g"
                position = g_pos
                if g_pos == "sg"
                  g_pos = "pg" 
                else
                  g_pos = "sg"
                end
              end
              player_name = line_array[i][3..line_array[i].length]
            end   
          end    

          if player_name != "" && player_name != "\n" && !player_name.nil?
            player_name = player_name.strip.gsub("\n","")
            first_name, last_name = Player.process_player_name(player_name)
            player = Player.find(:all, :conditions => "(first_name like \"#{first_name}\" or first_name_aka like \"#{first_name}\") and (last_name like \"#{last_name}\" or last_name_aka like \"#{last_name}\") and first_active_year <= #{year} and last_active_year >= #{year}")
            if player.length == 1
              player_id = player[0].id
            else
              player_id = -1
            end
            award["all_nba_#{team}_#{position}"] = player_id
            award.save
          end

        end
      end
      
    end
  end
  
  task :import_defensive_teams do
    file_name = "#{Rails.root}/tmp/databasebasketball2009/all_defense_teams.csv"
    
    f = File.open(file_name)
    while (c = f.gets)
      line_array = c.split(",")
      
      if line_array[0].include?("NBA") || line_array[0].include?("ABA")
        if line_array[0].include?("NBA")
          league = "N"
        else
          league = "A"
        end
        year = line_array[0][0..3].to_i + 1
      elsif line_array[0].include?("Team")
        team = line_array[0][0]
      else
        award = Awards.find(:first, :conditions=>{:year=>year,:league=>league})
        if award.nil?
          award = Awards.new
          award.year=year
          award.league=league
        end
        player_name = line_array[0]
        if player_name != "" && player_name != "\n"
          puts "|"+player_name+"|"
          first_name, last_name = Player.process_player_name(player_name)
          player = Player.find(:all, :conditions => {:first_name => first_name, :last_name => last_name})
          if player.length == 1
            player_id = player[0].id
          else
            player_id = -1
          end
          position = line_array[1].gsub("\n","")
          if award["all_defense_#{team}_#{position}"].nil?
            puts "#{award.id}|#{award.year}|#{award["finals_mvp"]} all_defense_#{team}_#{position} = #{player_id}"
            key = "all_defense_#{team}_#{position}"
            
            #award["all_defense_#{team}_#{position}"] = player_id 
            award[key.to_s] = player_id 
            puts award["all_defense_#{team}_pg"]
            award.save
          else
            award["all_defense_#{team}_extra"] = player_id
          end
          award.save
        end
      end
      
      
    end
  end
  
  task :import_awards_file do 
    file_name = "#{Rails.root}/tmp/databasebasketball2009/awards.csv"
    
    f = File.open(file_name)
    while (c = f.gets)
      line_array = c.split(",")
      if line_array[1]==""
        award_type = line_array[0]  
      else
        year = line_array[0]
        year = year[0..1]+year[5..6] if year.include?("-")
        year = '2000' if year == '1900'
        league = line_array[1][0]
        puts year + ":" + league
        award = Awards.find(:first, :conditions=>{:year=>year,:league=>league})
        if award.nil?
          award = Awards.new
          award.year=year
          award.league=league
        end
        puts line_array[3]
        team=Team.find_by_brid(line_array[3].strip)
        player=Player.find_player_name_team_season(line_array[2].strip,team.id,year)
        if player.nil?
          player_id =-1
        else
          player_id = player.id
        end
        award[award_type] = player_id
        award.save
      end
      
      
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
        team_stat = TeamStat.find(:first, :conditions => {:team_id => team.id, :year => line_array[1], :season_type => season_type})
        if team_stat.nil?
          team_stat = TeamStat.new
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
        teamid = line_array[4]
        year = line_array[1].to_i+1
        if teamid != "TOT"
          player = Player.find(:first, :conditions => {:pid => ppid})
          if player.nil?
            #try to find through exact fist and last name
            players = Player.find(:all, :conditions => {:first_name => line_array[2], :last_name => line_array[3]})
            if players.length == 1
              player = players[0]
              player.pid_aka = line_array[0]
              player.save
            end
          end
          team_stat = TeamStat.find_by_team_and_year(line_array[4], year)
          if !player.nil? && !team_stat.nil?
            stat = Stat.find(:first, :conditions => {:player_id => player.id, :team_stats_id => team_stat.id, :season => year, :season_type => season_type})
            if stat.nil?
              stat = Stat.new
              stat.player_id = player.id
              stat.season = year
              stat.team_stats_id = team_stat.id
              stat.season_type = season_type
            #end
            puts "INSERT #{ppid} #{line_array[2]} #{line_array[3]} #{line_array[4]}, #{year}"
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
            
          elsif player.nil?
            puts "Player Not Found: #{ppid} #{line_array[2]} #{line_array[3]} #{line_array[4]}, #{year}"
          elsif team_stat.nil?
            puts "Team Not Found: #{ppid} #{line_array[2]} #{line_array[3]} #{line_array[4]}, #{year}"
          end
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
      team_stat = TeamStat.find_by_team_and_year(tpid, year)
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
    file_name = "#{Rails.root}/tmp/databasebasketball2009/draft.csv"
    
    f = File.open(file_name)
    while (c = f.gets)
      line_array = c.split(",")
      
      draft_from = line_array[7]
      league = line_array[8]
      if league == "HS" || league == " HS" || league == "000)" || league == "100"
        draft_from += league
        league = line_array[9]
      end
      
      year = line_array[0]
      tpid = line_array[3]
      if tpid == "nyj"
        tpid = "nyn"
      end
      first_name = line_array[4]
      last_name = line_array[5]
      pid = line_array[6]
      
      team = Team.find_by_pid(tpid)
      player = Player.find_by_pid(pid)
      
      if !team.nil?
        #draft = Draft.find(:first, :conditions => {:team_id => team.id, :year => year, :first_name => first_name, :last_name => last_name, :league => league})
        #if draft.nil?
          draft = Draft.new
          draft.year = year
          draft.team_id = team.id
          draft.first_name = first_name
          draft.last_name = last_name
        #end
        draft.player_id = player.id if !player.nil?
        draft.league = league
        draft.draft_round = line_array[1]
        draft.selection = line_array[2]
        draft.draft_from = draft_from
        draft.save
      end
    end
  end
  
  task :import_ref_stats do 
    file_names = Array.new
    file_names << {:file_name => "#{Rails.root}/tmp/refstats/refs2008-2009.txt", :type => "regular", :year => 2009}
    file_names << {:file_name => "#{Rails.root}/tmp/refstats/refs2008-2009p.txt", :type => "playoffs", :year => 2009}
    file_names << {:file_name => "#{Rails.root}/tmp/refstats/refs2009-2010.txt", :type => "regular", :year => 2010}
    file_names << {:file_name => "#{Rails.root}/tmp/refstats/refs2009-2010p.txt", :type => "playoffs", :year => 2010}

    file_names.each do |fn|
      file_name = fn[:file_name]
      season_type = fn[:type]
      year = fn[:year]
      
      f = File.open(file_name)
      while (c = f.gets)
        line_array = c.split(",")
        
        name = line_array[0].split(" ")
        ref = Referee.find(:first, :conditions => {:first_name => name[0], :last_name => name[1]})
        if ref.nil?
          ref = Referee.new
          ref.first_name = name[0]
          ref.last_name = name[1]
          ref.save
        end
        
        officiating_type = line_array [1]
        ref_stat = RefereeStat.find(:first, :conditions => {:referee_id => ref.id, :year => year, :season_type => season_type, :officiating_type => officiating_type})
        if ref_stat.nil?
          ref_stat = RefereeStat.new
          ref_stat.referee_id = ref.id
          ref_stat.year = year
          ref_stat.season_type = season_type
          ref_stat.officiating_type = officiating_type
        end
        ref_stat.league = "N"
        ref_stat.games = line_array[2]
        ref_stat.home_win_percent = line_array[3]
        ref_stat.home_pts_diff = line_array[4]
        ref_stat.tot_ppg = line_array[5]
        ref_stat.foulspg = line_array[6]
        ref_stat.away_foul_percent = line_array[7]
        ref_stat.home_foul_percent = line_array[8]
        ref_stat.away_techpg = line_array[9]
        ref_stat.home_techpg = line_array[10]
        ref_stat.save
      end
    end
  end

  task :import_game_results do
    #"ATL", "BOS", "CHI", "CHA", "CLE", "DET", "HOU", "DAL", "DEN", "GSW", "IND", "LAC", "LAL", "MEM", "MIA", "MIL", "MIN", "NJN", "NOH","NYK","OKC","ORL","PHI","PHO", 
    teams = ["ATL", "BOS", "CHI", "CHA", "CLE", "DET", "HOU", "DAL", "DEN", "GSW", "IND", "LAC", "LAL", "MEM", "MIA", "MIL", "MIN", "NJN", "NOH","NYK","OKC","ORL","PHI","PHO","POR","SAC","SAS","TOR","UTA","WAS" ]
    teams = ["SEA", "NOO", "NOH"]
    teams = ["CHA", "VAN"]
    teams = ["INA"]
    teams = Team.find(:all)
    
    teams.each do |t|
      #team = Team.find_by_pid(t)
      team = t
      if !team.nil?
        #team.last_year.downto(team.start_year) do |year|
        start_year = [team.last_year, 1950].min
        start_year.downto(team.start_year) do |year|
          begin  
            download_schedule_and_results(team, year)
            puts "TEAM: #{team.pid} YEAR:#{year}"
          rescue
            puts "MISSED #{team.pid} YEAR:#{year}"
          end
          
        end
      end
      #download_schedule_and_results(team, "1968")
    end
    
  end
  
  def download_schedule_and_results(team, year)
    @uri = URI.parse "http://www.basketball-reference.com"
    if !team.brid.nil?
      @download_path = "/teams/#{team.brid}/#{year}_games.html"
    else
      @download_path = "/teams/#{team.pid}/#{year}_games.html"
    end
    
    http = Net::HTTP.new(@uri.host, @uri.port)
    #puts "#{@uri.host}, #{@uri.port} REQUEST: #{@download_path}"
    
    #get the file names from the current directory
    request = Net::HTTP::Get.new(@download_path)
    response = http.request(request).body
    
    #f = File.open("#{Rails.root}/tmp/test_input2")
    #response = f.read
    #puts response
    begin
      division, throw_away = find_between("NBA</a> ", " Division (<a href=", response)
    rescue
      begin
      division, throw_away = find_between("BAA</a> ", " Division (<a href=", response)
      rescue
        begin
          division, throw_away = find_between("ABA</a> ", " Division (<a href=", response)
        rescue
        end
      end
    end
    
    anchor1_index = response.index("Arena:")
    arena, throw_away = find_between("</strong> ", "&nbsp;", response[anchor1_index..anchor1_index+100])
    
    anchor1_index = response.index("Attendance:")
    begin
      attendance, throw_away = find_between("</strong> ", "(", response[anchor1_index..anchor1_index+100])
      attendance = attendance.gsub(",","")
    rescue
      attendance = 0
    end
    
    
    flag = true
    last_game_number = 0
    game_type = "regular"
    
    team_stat = team.get_team_stat(year, game_type)
    team_stat.attendance = attendance
    team_stat.arena = arena
    #team_stat.conference = conference
    team_stat.division = division
    team_stat.save
    while flag
      anchor1 = '<tr onmouseover="hl(this);" onmouseout="uhl(this);" class="">'
      anchor1_index = response.index(anchor1)
      response = response[anchor1_index+anchor1.length..response.length-1]
 
      anchor2 = '<td align="right" >'
      anchor2_index = response.index(anchor2)
  
      anchor3 = '<tr onmouseover="hl(this);" onmouseout="uhl(this);" class="">'
      anchor3_index = response.index(anchor3)
      if anchor3_index.nil?
        anchor3_index = response.index('<div id="site_footer">')
        flag = false
      end
      
      if anchor2_index < anchor3_index
        text = response[0..anchor3_index]
        game_number, text = find_between('<td align="right" >', '</td>', text)
        if game_number.to_i < last_game_number && game_type == "regular"
          game_type = "playoff"
        end
        last_game_number = game_number.to_i
        game_date, text = find_between('<td align="left"  csk="', '">', text)
        home_away, text = find_between('<td align="left" >', '</td>', text)
        opponent, text = find_between('.html">', '</A></td>', text)
        win_lose, text = find_between('<td align="left" >', '</td>', text)
        ot, text = find_between('<td align="center" >', '</td>', text)
        mp = 48
        if ot != ""
          if ot == "OT"
            mp = mp + 5
          else
            mul = ot[0].to_i
            mp = mp + 5*mul
          end
        end
        team_score, text = find_between('<td align="right" >', '</td>', text)
        opp_score, text = find_between('<td align="right" >', '</td>', text)
        wins, text = find_between('<td align="right" >', '</td>', text)
        losses, text = find_between('<td align="right" >', '</td>', text)
        streak, text = find_between('<td align="left" >', '</td>', text)
        notes, text = find_between('<td align="left" >', '</td>', text)
        
        #puts "***********"
        #puts game_number
        #puts game_type
        #puts game_date
        #puts home_away
        #puts opponent
        #puts win_lose
        #puts ot
        #puts mp
        #puts team_score
        
        
        if home_away == "" || home_away == "N" #only do home games
          away_team = Team.find_by_full_name(opponent, year.to_i)
          if home_away == "N"
            neutral = 1
          else
            neutral = 0
          end
          
          if !away_team.nil?
            
            game = Game.find(:first, :conditions => {:date_played => game_date, :home_team_id => team.id})
            if game.nil?
              game = Game.new
              game.date_played = game_date
              game.home_team_id = team.id
            end
            game.away_team_id = away_team.id
            game.game_type = game_type
            game.league = team.league
            game.home_pts = team_score
            game.away_pts = opp_score
            game.ot = ot
            game.minutes_played = mp
            game.neutral = neutral
            game.notes = notes
            game.season = year
            game.save
          end
        end
      end
    end    
  end
  
  task :get_stats_from_box do
    stats = Stat.find(:all, :conditions => {:salary => 1})
    stats.each do |stat|
      game_stats = GameStat.find(:all, :conditions => {:team_id => stat.team_id, :player_id => stat.player_id, :season => stat.season})
      gs_array = Array.new
      game_stats.each do |gs|
        game = Game.find(gs.game_id)
        if game.game_type == stat.season_type
          gs_array << gs
        end
      end
      mp = 0.0
      gs_array.each do |gs|
        stat.g += 1
        stat.gs += 1 if gs.starter == true
        mp += gs.mp
        stat.fg += gs.fg
        stat.fga += gs.fga
        stat.tfg += gs.tfg
        stat.tfga += gs.tfga
        stat.ft += gs.ft
        stat.fta += gs.fta
        stat.orb += gs.orb
        stat.drb += gs.drb
        stat.trb += gs.trb
        stat.ast += gs.ast
        stat.stl += gs.stl
        stat.blk += gs.blk
        stat.tov += gs.tov
        stat.pf += gs.pf
        stat.pts += gs.pts
      end
      stat.mp = mp.to_i
      stat.save
    end
  end
  
  task :import_game_stats do
    #game = Game.find(7471)
    #get_game_data(game)
    # and game_type = 'regular'
    games = Game.find(:all, :conditions => "date_played > '1986-10-10' and date_played < '2010-07-10' and validated = 0", :order => "date_played asc")
    games.each do |game|
      get_game_data(game)
    end
  end
  
  def get_game_data(game)
    home_team = game.get_home_team
    home_brid = home_team.brid
    away_team = game.get_away_team
    away_brid = away_team.brid
    date = game.date_played
    month = date.month.to_s
    month = "0" + month if date.month < 10
    day = date.day.to_s
    day = "0" + day if date.day < 10
    
    @uri = URI.parse "http://www.basketball-reference.com"
    @download_path = "/boxscores/#{date.year}#{month}#{day}0#{home_brid}.html"
    
    http = Net::HTTP.new(@uri.host, @uri.port)
    puts "#{@uri.host}, #{@uri.port} REQUEST: #{@download_path}"
    #get the file names from the current directory
    request = Net::HTTP::Get.new(@download_path)
    response = http.request(request).body
    
    #f = File.open("#{Rails.root}/tmp/boxscore_example")
    #response = f.read
    #puts response
    
    #Get scoring by quarter
    away_anchor = response.index('<td><a href="/teams/'+away_brid+'/'+game.season.to_s+'.html">'+away_brid+'</a></td>')
    response = response[away_anchor..response.length-1]
    game.away_quarter1, response = find_between('<td align="right">', "</td>", response)
    game.away_quarter2, response = find_between('<td align="right">', "</td>", response)
    game.away_quarter3, response = find_between('<td align="right">', "</td>", response)
    game.away_quarter4, response = find_between('<td align="right">', "</td>", response)
    
    home_anchor = response.index('<td><a href="/teams/'+home_brid+'/'+game.season.to_s+'.html">'+home_brid+'</a></td>')
    response = response[home_anchor..response.length-1]
    game.home_quarter1, response = find_between('<td align="right">', "</td>", response)
    game.home_quarter2, response = find_between('<td align="right">', "</td>", response)
    game.home_quarter3, response = find_between('<td align="right">', "</td>", response)
    game.home_quarter4, response = find_between('<td align="right">', "</td>", response)
    
    #get team advanced stats
    advanced_stats = Hash.new
    away_anchor2 = response.index('<td align="left" ><a href="/teams/'+away_brid+'/'+game.season.to_s+'.html">'+away_brid+'</A></td>')
    response = response[away_anchor2..response.length-1]
    advanced_stats[:pace], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:efg_percent], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:tov_percent], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:orb_percent], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:ft_fga], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:ortg], response = find_between('<td align="right" ', "</td>", response)
    game.insert_advanced_stats_hash(advanced_stats, "away")
    
    home_anchor2 = response.index('<td align="left" ><a href="/teams/'+home_brid+'/'+game.season.to_s+'.html">'+home_brid+'</A></td>')
    response = response[home_anchor2..response.length-1]
    advanced_stats[:pace], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:efg_percent], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:tov_percent], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:orb_percent], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:ft_fga], response = find_between('<td align="right" ', "</td>", response)
    advanced_stats[:ortg], response = find_between('<td align="right" ', "</td>", response)
    game.insert_advanced_stats_hash(advanced_stats, "home")
    
    #get player game stats
    away_box_anchor = response.index('<th align="center" colspan=19  class="bold_text over_header" >Basic Box Score Statistics</th>')
    response = response[away_box_anchor..response.length-1]
    
    starter_bench = "starter"
    starter_count = 5
    away_home = "away"
    player_team_id = away_team.id
    flag = false
    while !flag
      player_anchor = response.index('<tr onmouseover="hl(this);" onmouseout="uhl(this);" class="">')
      advanced_anchor = response.index('<th align="center" colspan=13  class="bold_text over_header" >Advanced Box Score Statistics</th>')
      basic_anchor = response.index('<th align="center" colspan=19  class="bold_text over_header" >Basic Box Score Statistics</th>')
      
      if starter_count == 0
        starter_bench = "bench"
        starter_count = 5
      end
      if starter_bench == "starter"
        starter_count -= 1
      end
      
      if advanced_anchor - player_anchor < 100
        team_total_anchor = response.index('<tr onmouseover="hl(this);" onmouseout="uhl(this);" class="bold_text stat_total">')
        
        team_stats = get_team_stats_hash(response[team_total_anchor..response.length-1])
        game.insert_team_stats_hash(team_stats, away_home)
        
        starter_bench = "starter"
        away_home = "home"
        player_team_id = home_team.id
        if !basic_anchor.nil?
          response = response[basic_anchor..response.length-1]
        else
          flag = true
        end
      else
        response = response[player_anchor..response.length-1]
        player_brid, text = find_between("/players/",'.html', response)
        player_brid = player_brid.split("/")[1]
        player_name, text = find_between('.html">', '</A></td>', response)
        
        player = Player.find_player_name_team_season(player_name, player_team_id, game.season)
        
        if player == -1
          puts "SEARCH: #{player_brid}"
          player = Player.find_by_pid_aka(player_brid)
        end
        
        if !player.nil?
          game_stat = player.get_game_stats(game.id)
          if game_stat.nil?
            game_stat = GameStat.new
            game_stat.player_id = player.id
            game_stat.game_id = game.id
            game_stat.team_id = player_team_id
          end
          game_stat.starter = (starter_bench =="starter") ? true : false
          mp, text = find_between('">', '</td>', text)
          if mp.include?(":")
            game_times = mp.split(":")
            mp = game_times[0].to_i + game_times[1].to_f/60
          end
          game_stat.mp = mp
          game_stat.fg, text = find_between('<td align="right" >', '</td>', text)
          game_stat.fga, text = find_between('<td align="right" >', '</td>', text)
          game_stat.fgpercent, text = find_between('<td align="right" >', '</td>', text)
          game_stat.tfg, text = find_between('<td align="right" >', '</td>', text)
          game_stat.tfga, text = find_between('<td align="right" >', '</td>', text)
          game_stat.tfgpercent, text = find_between('<td align="right" >', '</td>', text)
          game_stat.ft, text = find_between('<td align="right" >', '</td>', text)
          game_stat.fta, text = find_between('<td align="right" >', '</td>', text)
          game_stat.ftpercent, text = find_between('<td align="right" >', '</td>', text)
          game_stat.orb, text = find_between('<td align="right" >', '</td>', text)
          game_stat.drb, text = find_between('<td align="right" >', '</td>', text)
          game_stat.trb, text = find_between('<td align="right" >', '</td>', text)
          game_stat.ast, text = find_between('<td align="right" >', '</td>', text)
          game_stat.stl, text = find_between('<td align="right" >', '</td>', text)
          game_stat.blk, text = find_between('<td align="right" >', '</td>', text)
          game_stat.tov, text = find_between('<td align="right" >', '</td>', text)
          game_stat.pf, text = find_between('<td align="right" >', '</td>', text)
          game_stat.pts, text = find_between('<td align="right" >', '</td>', text)
          game_stat.save
          #end
        end
        response = text
        
      end
    end
    
    officials, response = find_between('<strong>Officials:</strong>', "<br>", response)
    attendance, response = find_between('<strong>Attendance:</strong>', "<br>", response)
    game_time, response = find_between('<strong>Time of Game:</strong>', "<br>", response)
    if !officials.nil?
      officials = officials.split(",")
      officials.each do |name|
        ref_id = Referee.find_full_name(name)
        game.store_ref(ref_id)
      end
    end
    if !game_time.nil?
      if game_time.include?(":")
        game_times = game_time.split(":")
        game.duration_mins = game_times[0].to_i*60 + game_times[1].to_i
      else
        game.duration_mins = game_time
      end
    end
    if !attendance.nil?
      attendance = attendance.gsub(",","").strip
      game.attendance = attendance
    end
    game.save
  end
  
  def find_between(start, finish, text)
    l_start = start.length
    l_finish = finish.length
    start_index = text.index(start)
    if !start_index.nil?
      finish_index = text.index(finish, start_index)

      return_val = text[start_index+l_start..finish_index-1].gsub(' class=" highlight_text">','').gsub(">","")
      return_val = return_val
      return return_val, text[finish_index+l_finish..text.length-1]
    else
      return nil, text
    end
  end
  
  def get_team_stats_hash(text)
    team_stats = Hash.new
    team_stats[:mp], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:fg], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:fga], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:fg_percent], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:tfg], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:tfga], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:tfg_percent], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:ft], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:fta], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:ft_percent], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:orb], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:drb], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:trb], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:ast], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:stl], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:blk], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:tov], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:pf], text = find_between('<td align="right" >', '</td>', text)
    team_stats[:pts], text = find_between('<td align="right" >', '</td>', text)
    return team_stats
  end
end
