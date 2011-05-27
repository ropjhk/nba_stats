class Player < ActiveRecord::Base
  has_many :stats
  has_many :drafts
  
  def self.find_player_name_team_season(player_name, team_id, season, pid_aka="")
    first_name, last_name = Player.process_player_name(player_name)
    candidates = Player.find(:all, :conditions => "(first_name like \"#{first_name}%\" or first_name_aka like \"#{first_name}%\") and (last_name like \"#{last_name}%\" or last_name_aka like \"#{last_name}%\")")
    if candidates.length == 0
      first_name_mod = first_name.gsub("'","").gsub("-","").gsub(" ","")
      last_name_mod = last_name.gsub("'","").gsub("-","").gsub(" ","")
      candidates = Player.find(:all, :conditions => "(first_name like \"#{first_name_mod}%\" or first_name_aka like \"#{first_name_mod}%\") and (last_name like \"#{last_name_mod}%\" or last_name_aka like \"#{last_name_mod}%\")")
    end
    
    best_candidates = Array.new
    candidates.each do |c|
      stats = c.get_stats(season, team_id)
      best_candidates << c if !stats.nil?
    end
    if best_candidates.length == 1
      if first_name != best_candidates[0].first_name && best_candidates[0].first_name_aka.nil?
        best_candidates[0].first_name_aka = first_name 
        best_candidates[0].save
      end
      if last_name != best_candidates[0].last_name && best_candidates[0].last_name_aka.nil?
        best_candidates[0].last_name_aka = last_name 
        best_candidates[0].save
      end
      
      return best_candidates[0]
    else
      if best_candidates.length == 0
        #find by last name only
        #puts "last_name=\"#{last_name}\" or last_name_aka=\"#{last_name}\""
        candidates = Player.find(:all, :conditions => "last_name=\"#{last_name}\" or last_name_aka=\"#{last_name}\"")
        if candidates.length == 0
          last_name_mod = last_name.gsub("'","").gsub("-","").gsub(" ","")
          candidates = Player.find(:all, :conditions => "last_name=\"#{last_name_mod}\" or last_name_aka=\"#{last_name_mod}\"")
        end
        
        best_candidates = Array.new
        candidates.each do |c|
          stats = c.get_stats(season, team_id)
          best_candidates << c if !stats.nil?
        end
        if best_candidates.length == 1
          if best_candidates[0].first_name_aka.nil?
            best_candidates[0].first_name_aka = first_name 
            best_candidates[0].save
          end
          return best_candidates[0]
        else
          if best_candidates.length == 0
            return nil
          else
            #ambiguous
            return -1
          end
        end
      end
      #ambiguous
      return -1
    end
  end
  
  
  
  def get_game_stats(game_id)
    GameStat.find(:first, :conditions => {:player_id => self.id, :game_id => game_id})
  end
  
  def get_stats(season, team_id=-1)
    return_val = nil
    if team_id == -1
      return_val = Stats.find(:all, :conditions => {:player_id => self.id, :season=>season})
    else
      return_val = Stats.find(:first, :conditions => {:player_id => self.id, :season=>season, :team_id=>team_id})
    end
    return_val
  end
  
  def self.process_player_name(player_name)
    names = player_name.split(" ")
    first_name = ""
    last_name = ""
    if names.length == 2
      first_name = names[0]
      last_name = names[1]
    else
      if names[2] == "Jr." || names[2] == "Jr"
        first_name = names[0]
        last_name = names[1]+" "+names[2]
      elsif names[1][1] == "."
        first_name = names[0]+" "+names[1]
        last_name = names[2]
      elsif names.length == 3
        first_name = names[0]+" "+names[1]
        last_name = names[2]
      elsif names.length == 4
        first_name = names[0]
        last_name = names[3]
      end
    end
    #puts "#{first_name} #{last_name}"
    return first_name, last_name
  end
  
  def self.get_players_by_draft(year=-1, round=-1, position=-1, draft)
    if year == -1
      year_query = "draft_year is not null"
    else
      year_query = "draft_year = #{year}"
    end
    if round == -1
      round_query = "draft_round is not null"
    else
      round_query = "draft_round = #{round}"
    end
    if position == -1
      position_query = "draft_position is not null"
    else
      position_query = "draft_position = #{position}"
    end
    players = Player.find(:all, :conditions => "#{year_query} and #{round_query} and #{position_query}")
  end
  
end
