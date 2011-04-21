class AddTeamBrid < ActiveRecord::Migration
  def self.up
    add_column(:teams, :brid, :string, :limit => 5)
  end

  def self.down
    remove_column(:teams, :brid)
  end
end
