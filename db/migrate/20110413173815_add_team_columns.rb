class AddTeamColumns < ActiveRecord::Migration
  def self.up
    add_column(:teams, :start_year, :integer)
    add_column(:teams, :last_year, :integer)
    add_column(:teams, :prev_team_id, :integer)
    add_column(:teams, :next_team_id, :integer)
  end

  def self.down
    remove_column(:teams, :start_year)
    remove_column(:teams, :last_year)
    remove_column(:teams, :prev_team_id)
    remove_column(:teams, :next_team_id)
  end
end
