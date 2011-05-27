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
  
  def store_ref(ref_id)
    if self.referee1_id.nil?
      self.referee1_id = ref_id
    elsif self.referee1_id != ref_id
      if self.referee2_id.nil?
        self.referee2_id = ref_id
      elsif self.referee2_id != ref_id
        if self.referee3_id.nil?
          self.referee3_id = ref_id
        elsif self.referee3_id != ref_id
          self.referee4_id = ref_id
        end
      end  
    end
    self.save
  end
  
  def insert_advanced_stats_hash(advanced_stats, away_home)
    self[:pace] = advanced_stats[:pace]
    self[away_home+"_efg_percent"] = advanced_stats[:efg_percent]
    self[away_home+"_tov_percent"] = advanced_stats[:tov_percent]
    self[away_home+"_orb_percent"] = advanced_stats[:orb_percent]
    self[away_home+"_ft_fga"] = advanced_stats[:ft_fga]
    self[away_home+"_ortg"] = advanced_stats[:ortg]
    self.save
    
  end
  
  def insert_team_stats_hash(team_stats, away_home)
    self[away_home+"_fg"] = team_stats[:fg]
    self[away_home+"_fga"] = team_stats[:fga]
    self[away_home+"_fgpercent"] = team_stats[:fg_percent]
    self[away_home+"_tfg"] = team_stats[:tfg]
    self[away_home+"_tfga"] = team_stats[:tfga]
    self[away_home+"_tfgpercent"] = team_stats[:tfg_percent]
    self[away_home+"_ft"] = team_stats[:ft]
    self[away_home+"_fta"] = team_stats[:fta]
    self[away_home+"_ftpercent"] = team_stats[:ft_percent]
    self[away_home+"_orb"] = team_stats[:orb]
    self[away_home+"_drb"] = team_stats[:drb]
    self[away_home+"_trb"] = team_stats[:trb]
    self[away_home+"_ast"] = team_stats[:ast]
    self[away_home+"_stl"] = team_stats[:stl]
    self[away_home+"_blk"] = team_stats[:blk]
    self[away_home+"_tov"] = team_stats[:tov]
    self[away_home+"_pf"] = team_stats[:pf]
    self.save
  end
  
end
