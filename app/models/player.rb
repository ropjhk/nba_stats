class Player < ActiveRecord::Base
  has_many :stats
  
  def self.find_player_name_team_season(player_name, team_id, season)
    first_name, last_name = Player.process_player_name(player_name)
    candidates = Player.find(:all, :conditions => {:first_name => first_name, :last_name=> last_name})
    
    best_candidates = Array.new
    candidates.each do |c|
      stats = c.get_stats(season, team_id)
      best_candidates << c if !stats.nil?
    end
    if best_candidates.length == 1
      return best_candidates[0]
    else
      return nil
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
      else
        first_name = names[0]+" "+names[1]
        last_name = names[2]
      end
    end
    return first_name, last_name
  end
  
  
end
