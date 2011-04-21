class ModifyGames < ActiveRecord::Migration
  def self.up
    change_column(:games, :minutes_played, :integer)
    add_column(:games, :ot, :string)
  end

  def self.down
    remove_column(:games, :ot)
  end
end
