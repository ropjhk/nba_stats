class ValidateBoxScores < ActiveRecord::Migration
  def self.up
    #add_column(:games, :validated, :boolean)
    #change_column(:game_stats, :mp, :float)
    #add_column(:players,:first_name_aka, :string)
    #add_column(:players,:last_name_aka, :string)
    #add_column(:players,:pid_aka, :string)
    #add_column(:teams,:pid_aka, :string)
    add_column(:game_stats,:season, :int)
  end

  def self.down
    #remove_column(:games, :validated)
    #remove_column(:players, :first_name_aka)
    #remove_column(:players, :last_name_aka)
    #remove_column(:players, :pid_aka)
    #remove_column(:teams, :pid_aka)
    #remove_column(:game_stats, :season)
  end
end
