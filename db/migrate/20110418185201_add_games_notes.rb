class AddGamesNotes < ActiveRecord::Migration
  def self.up
    add_column(:games, :notes, :string)
    add_column(:games, :neutral, :boolean)
    add_column(:games, :season, :integer)
  end

  def self.down
    remove_column(:games, :notes)
    remove_column(:games, :neutral)
    remove_column(:games, :season)
  end
end
