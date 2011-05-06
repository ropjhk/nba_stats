class PlayoffSeries < ActiveRecord::Base
  
  def self.get_playoff_series(team1, team2, year)
    ps = PlayoffSeries.find(:first, :conditions=>{:favoured_team_id=>team1, :underdog_team_id=>team2, :year=>year})
    if ps.nil?
      ps = PlayoffSeries.find(:first, :conditions=>{:favoured_team_id=>team2, :underdog_team_id=>team1, :year=>year})
    end
    return ps
  end
  
  def insert_next_game(game_id, home_team_id)
    if self.game_1_id.nil?
      self.game_1_id = game_id
      self.game_1_home_team_id = home_team_id
    elsif self.game_2_id.nil?
      self.game_2_id = game_id
      self.game_2_home_team_id = home_team_id
    elsif self.game_3_id.nil?
      self.game_3_id = game_id
      self.game_3_home_team_id = home_team_id
    elsif self.game_4_id.nil?
      self.game_4_id = game_id
      self.game_4_home_team_id = home_team_id
    elsif self.game_5_id.nil?
      self.game_5_id = game_id
      self.game_5_home_team_id = home_team_id
    elsif self.game_6_id.nil?
      self.game_6_id = game_id
      self.game_6_home_team_id = home_team_id
    elsif self.game_7_id.nil?
      self.game_7_id = game_id
      self.game_7_home_team_id = home_team_id
    end
    self.save
  end
  
  def game_7
    Game.find(self.game_7_id)
  end
  
  def game_6
    Game.find(self.game_6_id)
  end
  
  def game_5
    Game.find(self.game_5_id)
  end
  
  def game_4
    Game.find(self.game_4_id)
  end
  
  def game_3
    Game.find(self.game_3_id)
  end
  
  def game_2
    Game.find(self.game_2_id)
  end
  
  def game_1
    Game.find(self.game_1_id)
  end
  
end
