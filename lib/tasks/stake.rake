namespace 'stake' do
  
  task :calculate_average_player_by_year do
    1947.upto(2010) do |year|
      stats = Stat.find(:all, :conditions => {:season => year}, :order => :player_id)
      
      #process_averaging(stats, year, "all players")
      #process_bell_curve(stats, year, "all players")
      process_standard_deviation(stats, year, "all players")
    end
  end
  
  def process_bell_curve(stats, year, category_prepend)
    player_id = -1
    
    stats.each do |s|
      if player_id != s.player_id 
        player_id = s.player_id
        player = Player.find(player_id)
        
        
      end
    end
  end
  
  task :calculate_average_rookie do
    1947.upto(2010) do |year|
      stats = Stat.find(:all, :conditions => {:season => year}, :order => :player_id)
      go_stats = Array.new
      stats.each do |s|
        if s.player.first_active_year == year
          go_stats << s
        end
      end
      process_averaging(go_stats, year, "rookies")
    end
  end
  
  task :calculate_average_position do
    1947.upto(2010) do |year|
      stats = Stat.find(:all, :conditions => {:season => year}, :order => :player_id)
      
      go_stats = Array.new
      stats.each do |s|
        if s.player.position == "G"
          go_stats << s
        end
      end
      process_averaging(go_stats, year, "Guards")
      
      go_stats = Array.new
      stats.each do |s|
        if s.player.position == "F"
          go_stats << s
        end
      end
      process_averaging(go_stats, year, "Forwards")
      
      go_stats = Array.new
      stats.each do |s|
        if s.player.position == "C"
          go_stats << s
        end
      end
      process_averaging(go_stats, year, "Centers")
    end
  end
  
  task :graphs_by_draft_position do
    1.upto(10) do |i|
      players = Players.get_players_by_draft(-1,1,i)
      cat_title = "num #{i} overall picks"
      calculate_graph_data_by_year(players, cat_title)
    end
  end
  
  def calculate_graph_data_by_year(players)
    
  end
  
  def calculate_graph_data_by_age
  end
  
  def process_standard_deviation(stats, year, category)
    player_id = -1
    #initialize matrix
    matrix = {:num_players=>0, :height_inches=>0.0, :weight_pounds=>0.0, :birth_year=>0.0,:first_active_year=>0.0,:last_active_year=>0.0,:g=>0.0,:mp=>0.0,
      :blk=>0.0,:pts=>0.0,:orb=>0.0,:drb=>0.0,:trb=>0.0,:ast=>0.0,:stl=>0.0,:tov=>0.0,:pf=>0.0,:fg=>0.0,:fga=>0.0,:ft=>0.0,:fta=>0.0,:tfg=>0.0,:tfga=>0.0,
      :blk48=>0.0,:pts48=>0.0,:orb48=>0.0,:drb48=>0.0,:trb48=>0.0,:ast48=>0.0,:stl48=>0.0,:tov48=>0.0,:pf48=>0.0,:fg48=>0.0,:fga48=>0.0,:ft48=>0.0,:fta48=>0.0,:tfg48=>0.0,:tfga48=>0.0,
      :ft_percentage=>0.0,:fg_percentage=>0.0,:tfg_percentage=>0.0
      }
    #initialize tmpmatrix
    tmpmatrix = {:g=>0,:mp=>0,:blk=>0,:pts=>0,:orb=>0,:drb=>0,:trb=>0,:ast=>0,:stl=>0,:tov=>0,:pf=>0,:fg=>0,:fga=>0,:ft=>0,:fta=>0,:tfg=>0,:tfga=>0}
    teams_count = num_ft_players = num_fg_players = num_tfg_players = num_height_players = num_weight_players = num_birthday_players = 0
    average=AveragePlayer.find(:first, :conditions=> {:year => year, :category => category})
    
    stats.each do |s|
      if player_id != s.player_id
        player_id = s.player_id
        matrix[:num_players] += 1
        player = Player.find(player_id)
         
        if player.height_inches
          matrix[:height_inches] += (average[:height_inches] - player.height_inches)**2
          num_height_players += 1
        end
        if player.weight_pounds
          matrix[:weight_pounds] += (average[:weight_pounds] - player.weight_pounds)**2
          num_weight_players += 1
        end
        if player.birthday
          matrix[:birth_year] += (average[:birth_year] - player.birthday.year)**2
          num_birthday_players += 1
        end
        matrix[:first_active_year] += (average[:first_active_year] - player.first_active_year)**2
        matrix[:last_active_year] += (average[:last_active_year] -player.last_active_year)**2
          
        if teams_count > 0
          tmpmatrix.keys.each do |key|
            matrix[key] += (average[key] - tmpmatrix[key])**2
            if tmpmatrix[:mp] > 0 && key != :g && key != :mp
              matrix["#{key.to_s}48".to_sym] += (average["#{key.to_s}48".to_sym] - tmpmatrix[key].to_f*48/tmpmatrix[:mp].to_f)**2
            end
          end
          if tmpmatrix[:fta] > 0
            matrix[:ft_percentage] += (average[:ft_percentage]-(tmpmatrix[:ft].to_f/tmpmatrix[:fta].to_f))**2
            num_ft_players += 1
          end
          if tmpmatrix[:fga] > 0
            matrix[:fg_percentage] += (average[:fg_percentage]-(tmpmatrix[:fg].to_f/tmpmatrix[:fga].to_f))**2
            num_fg_players += 1
          end
          if tmpmatrix[:tfga] > 0
            matrix[:tfg_percentage] += (average[:tfg_percentage]-(tmpmatrix[:tfg].to_f/tmpmatrix[:tfga].to_f))**2
            num_tfg_players += 1
          end
        end
        teams_count = 0
        #re-initialize tmpmatrix
        tmpmatrix = {:g=>0,:mp=>0,:blk=>0,:pts=>0,:orb=>0,:drb=>0,:trb=>0,:ast=>0,:stl=>0,:tov=>0,:pf=>0,
          :fg=>0,:fga=>0,:ft=>0,:fta=>0,:tfg=>0,:tfga=>0}
      end
      teams_count += 1
      tmpmatrix.keys.each do |key|
        tmpmatrix[key] += s[key]
      end
    end
    #final pass
    if teams_count > 0
      tmpmatrix.keys.each do |key|
        matrix[key] += (average[key] - tmpmatrix[key])**2
        if tmpmatrix[:mp] > 0 && key != :g && key != :mp
          matrix["#{key.to_s}48".to_sym] += (average["#{key.to_s}48".to_sym] - tmpmatrix[key].to_f*48/tmpmatrix[:mp].to_f)**2
        end
      end
      if tmpmatrix[:fta] > 0
        matrix[:ft_percentage] += (average[:ft_percentage]-(tmpmatrix[:ft].to_f/tmpmatrix[:fta].to_f))**2
        num_ft_players += 1
      end
      if tmpmatrix[:fga] > 0
        matrix[:fg_percentage] += (average[:fg_percentage]-(tmpmatrix[:fg].to_f/tmpmatrix[:fga].to_f))**2
        num_fg_players += 1
      end
      if tmpmatrix[:tfga] > 0
        matrix[:tfg_percentage] += (average[:tfg_percentage]-(tmpmatrix[:tfg].to_f/tmpmatrix[:tfga].to_f))**2
        num_tfg_players += 1
      end
    end
    matrix[:height_inches] = Math.sqrt(matrix[:height_inches]/(num_height_players-1))
    matrix[:weight_pounds] = Math.sqrt(matrix[:weight_pounds]/(num_weight_players-1))
    matrix[:birth_year] = Math.sqrt(matrix[:birth_year]/(num_birthday_players-1))
    matrix[:first_active_year] = Math.sqrt(matrix[:first_active_year]/(matrix[:num_players]-1))
    matrix[:last_active_year] = Math.sqrt(matrix[:last_active_year]/(matrix[:num_players]-1))
    matrix[:ft_percentage] = Math.sqrt(matrix[:ft_percentage]/(num_ft_players-1))
    matrix[:fg_percentage] = Math.sqrt(matrix[:fg_percentage]/(num_fg_players-1))
    matrix[:tfg_percentage] = Math.sqrt(matrix[:tfg_percentage]/(num_tfg_players-1))
    
    tmpmatrix.keys.each do |key|
      matrix[key] =  Math.sqrt(matrix[key]/(matrix[:num_players]-1))
      if key != :g && key != :mp
        matrix["#{key.to_s}48".to_sym] =  Math.sqrt(matrix["#{key.to_s}48".to_sym]/(matrix[:num_players]-1))
      end
    end
    
    sd = StandardDeviation.find(:first, :conditions => {:year=>year,:category=>category})
    if sd.nil?
      sd = StandardDeviation.new
      sd.year = year
      sd.category = category
    end
    sd.attributes = matrix
    sd.save
  end
  
  def process_averaging(stats,year, category)
    player_id = -1
    #initialize matrix
    matrix = {:num_players=>0, :height_inches=>0.0, :weight_pounds=>0.0, :birth_year=>0.0,:first_active_year=>0.0,:last_active_year=>0.0,:g=>0.0,:mp=>0.0,
      :blk=>0.0,:pts=>0.0,:orb=>0.0,:drb=>0.0,:trb=>0.0,:ast=>0.0,:stl=>0.0,:tov=>0.0,:pf=>0.0,:fg=>0.0,:fga=>0.0,:ft=>0.0,:fta=>0.0,:tfg=>0.0,:tfga=>0.0,
      :blk48=>0.0,:pts48=>0.0,:orb48=>0.0,:drb48=>0.0,:trb48=>0.0,:ast48=>0.0,:stl48=>0.0,:tov48=>0.0,:pf48=>0.0,:fg48=>0.0,:fga48=>0.0,:ft48=>0.0,:fta48=>0.0,:tfg48=>0.0,:tfga48=>0.0,
      :ft_percentage=>0.0,:fg_percentage=>0.0,:tfg_percentage=>0.0
      }
    #initialize tmpmatrix
    tmpmatrix = {:g=>0,:mp=>0,:blk=>0,:pts=>0,:orb=>0,:drb=>0,:trb=>0,:ast=>0,:stl=>0,:tov=>0,:pf=>0,:fg=>0,:fga=>0,:ft=>0,:fta=>0,:tfg=>0,:tfga=>0}
    teams_count = num_ft_players = num_fg_players = num_tfg_players = num_height_players = num_weight_players = num_birthday_players = 0
    
    stats.each do |s|
      if player_id != s.player_id 
        if tmpmatrix[:fg] > tmpmatrix[:fga]
          puts player_id
        end
        
        player_id = s.player_id
        matrix[:num_players] += 1
        player = Player.find(player_id)
        
        if player.height_inches
          matrix[:height_inches] += player.height_inches
          num_height_players += 1
          BellCurve.add_one(category + " height " + year.to_s, rs = player.height_inches.to_f, rs)
        end
        if player.weight_pounds
          matrix[:weight_pounds] += player.weight_pounds
          num_weight_players += 1
          BellCurve.add_one(category + " weight " + year.to_s, rs = player.weight_pounds/5 * 5, rs + 4)
        end
        if player.birthday
          matrix[:birth_year] += player.birthday.year
          num_birthday_players += 1
          BellCurve.add_one(category + " age " + year.to_s, rs=year-player.birthday.year, rs)
        end
        matrix[:first_active_year] += player.first_active_year
        BellCurve.add_one(category + " exp " + year.to_s, rs=year-player.first_active_year, rs)
        matrix[:last_active_year] += player.last_active_year
        BellCurve.add_one(category + " YBR " + year.to_s, rs=player.last_active_year-year, rs)
        
        if teams_count > 0
          matrix = bell_curve_matrix(category, year, tmpmatrix, matrix)
          if tmpmatrix[:fta] > 0
            matrix[:ft_percentage] += tmpmatrix[:ft].to_f/tmpmatrix[:fta].to_f
            num_ft_players += 1
            BellCurve.add_one(category + " ft_percent(min50fta) " + year.to_s, rs=((tmpmatrix[:ft].to_f/tmpmatrix[:fta].to_f*100).to_i/5*5).to_f/100.0, rs + 0.04) if tmpmatrix[:fta] > 49
          end
          if tmpmatrix[:fga] > 0
            matrix[:fg_percentage] += tmpmatrix[:fg].to_f/tmpmatrix[:fga].to_f
            num_fg_players += 1
            BellCurve.add_one(category + " fg_percent(min100fga) " + year.to_s, rs=((tmpmatrix[:fg].to_f/tmpmatrix[:fga].to_f*100).to_i).to_f/100.0, rs + 0.009) if tmpmatrix[:fga] > 99
          end
          if tmpmatrix[:tfga] > 0
            matrix[:tfg_percentage] += tmpmatrix[:tfg].to_f/tmpmatrix[:tfga].to_f
            num_tfg_players += 1
            BellCurve.add_one(category + " tfg_percent(min10tfga) " + year.to_s, rs=((tmpmatrix[:tfg].to_f/tmpmatrix[:tfga].to_f*100).to_i).to_f/100.0, rs + 0.009) if tmpmatrix[:tfga] > 9
          end
        end
        teams_count = 0
        #re-initialize tmpmatrix
        tmpmatrix = {:g=>0,:mp=>0,:blk=>0,:pts=>0,:orb=>0,:drb=>0,:trb=>0,:ast=>0,:stl=>0,:tov=>0,:pf=>0,
          :fg=>0,:fga=>0,:ft=>0,:fta=>0,:tfg=>0,:tfga=>0}
      end
      
      teams_count += 1
      tmpmatrix.keys.each do |key|
        tmpmatrix[key] += s[key]
        matrix[key] += s[key]
      end
    end
    if teams_count > 0
      matrix = bell_curve_matrix(category, year, tmpmatrix, matrix)
      if tmpmatrix[:fta] > 0
        matrix[:ft_percentage] += tmpmatrix[:ft].to_f/tmpmatrix[:fta].to_f
        num_ft_players += 1
        BellCurve.add_one(category + " ft_percent(min50fta) " + year.to_s, rs=((matrix[:ft_percentage]*100).to_i).to_f/100.0, rs + 0.009) if tmpmatrix[:fta] > 49
      end
      if tmpmatrix[:fga] > 0
        matrix[:fg_percentage] += tmpmatrix[:fg].to_f/tmpmatrix[:fga].to_f
        num_fg_players += 1
        BellCurve.add_one(category + " fg_percent(min100fga) " + year.to_s, rs=((matrix[:fg_percentage]*100).to_i).to_f/100.0, rs + 0.009) if tmpmatrix[:fga] > 99
      end
      if tmpmatrix[:tfga] > 0
        matrix[:tfg_percentage] += tmpmatrix[:tfg].to_f/tmpmatrix[:tfga].to_f
        num_tfg_players += 1
        BellCurve.add_one(category + " tfg_percent(min10tfga) " + year.to_s, rs=((matrix[:tfg_percentage]*100).to_i).to_f/100.0, rs + 0.009) if tmpmatrix[:tfga] > 9
      end
    end
    
    if num_tfg_players > 0
      tfg_percentage=matrix[:tfg_percentage]/num_tfg_players.to_f
    else
      tfg_percentage=0
    end
    matrix_ave = {:num_players=>matrix[:num_players], :height_inches=>matrix[:height_inches]/num_height_players, :weight_pounds=>matrix[:weight_pounds]/num_weight_players, 
      :birth_year=>matrix[:birth_year]/num_birthday_players,:first_active_year=>matrix[:first_active_year]/matrix[:num_players],:last_active_year=>matrix[:last_active_year]/matrix[:num_players],
      :ft_percentage=>matrix[:ft_percentage]/num_ft_players,:fg_percentage=>matrix[:fg_percentage]/num_fg_players,:tfg_percentage=>tfg_percentage
    }
    matrix_ave.keys.each do |key|
      matrix[key] = matrix_ave[key]
    end

    tmpmatrix.keys.each do |key|
      matrix[key] = matrix[key]/matrix[:num_players]
      if key.to_s != "g" && key.to_s != "mp"
        matrix["#{key.to_s}48".to_sym] = matrix["#{key.to_s}48".to_sym]/matrix[:num_players]
      end
    end
    
    ap = AveragePlayer.find(:first, :conditions => {:year=>year,:category=>category})
    if ap.nil?
      ap = AveragePlayer.new
      ap.year = year
      ap.category = category
    end
    ap.attributes = matrix
    ap.save
  end
  
  def bell_curve_matrix(category, year, tmpmatrix, matrix)
    tmpmatrix.keys.each do |key|
      BellCurve.add_one(category +" "+ key.to_s+" "+ year.to_s, rs=(tmpmatrix[key]/2)*2, rs + 2) if key.to_s == "g"
      BellCurve.add_one(category +" "+ key.to_s+" "+ year.to_s, rs=(tmpmatrix[key]/100)*100, rs + 100) if key.to_s == "mp"
      if tmpmatrix[:mp] > 0 && key != :g && key != :mp
        BellCurve.add_one(category +" "+ key.to_s+"48 " + year.to_s, rs=(tmpmatrix[key]*480/(tmpmatrix[:mp]*5)*5).to_f/10.0, rs + 0.4)
        matrix["#{key.to_s}48".to_sym] += tmpmatrix[key].to_f*48/tmpmatrix[:mp].to_f
      end
    end
    return matrix
  end
  
end