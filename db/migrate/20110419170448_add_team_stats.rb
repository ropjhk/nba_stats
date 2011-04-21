class AddTeamStats < ActiveRecord::Migration
  def self.up
    add_column(:team_stats, :validated, :boolean)
  end

  def self.down
    remove_column(:team_stats, :validated)
  end
end
