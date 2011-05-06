class Game < ActiveRecord::Base
  def get_home_team
    team = Team.find(self.home_team_id)
  end
  
  def get_away_team
    team = Team.find(self.away_team_id)
  end
  
  def winner
    if self.home_pts > self.away_pts
      winner_id = home_team_id
    else
      winner_id = away_team_id
    end
    return winner_id
  end
end
