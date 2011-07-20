class ValidateBoxScores < ActiveRecord::Migration
  def self.up
    #add_column(:games, :validated, :boolean)
    #change_column(:game_stats, :mp, :float)
    #add_column(:players,:first_name_aka, :string)
    #add_column(:players,:last_name_aka, :string)
    #add_column(:players,:pid_aka, :string)
    #add_column(:teams,:pid_aka, :string)
    #add_column(:game_stats,:season, :int)
    #add_column(:awards,:league, :string, :length => 1)
    #add_column(:awards,:all_defense_1_extra, :int)
    #add_column(:awards,:all_defense_2_extra, :int)
    #add_column(:awards,:all_nba_1_extra, :int)
    #add_column(:awards,:all_nba_2_extra, :int)
    #add_column(:awards,:all_nba_3_extra, :int)
    #add_column(:awards,:all_rookie_1_extra, :int)
    #add_column(:awards,:all_rookie_2_extra, :int)
    add_column(:players, :first_active_year, :int)
    add_column(:players, :last_active_year, :int)
  end

  def self.down
    #remove_column(:games, :validated)
    #remove_column(:players, :first_name_aka)
    #remove_column(:players, :last_name_aka)
    #remove_column(:players, :pid_aka)
    #remove_column(:teams, :pid_aka)
    #remove_column(:game_stats, :season)
    #remove_column(:awards, :league)
  end
end
