class AddGameColumns < ActiveRecord::Migration
  def self.up
    add_column(:games, :away_quarter1, :integer)
    add_column(:games, :away_quarter2, :integer)
    add_column(:games, :away_quarter3, :integer)
    add_column(:games, :away_quarter4, :integer)
    add_column(:games, :home_quarter1, :integer)
    add_column(:games, :home_quarter2, :integer)
    add_column(:games, :home_quarter3, :integer)
    add_column(:games, :home_quarter4, :integer)
    add_column(:games, :away_efg_percent, :float)
    add_column(:games, :away_tov_percent, :float)
    add_column(:games, :away_orb_percent, :float)
    add_column(:games, :away_ft_fga, :float)
    add_column(:games, :away_ortg, :float)
    add_column(:games, :home_efg_percent, :float)
    add_column(:games, :home_tov_percent, :float)
    add_column(:games, :home_orb_percent, :float)
    add_column(:games, :home_ft_fga, :float)
    add_column(:games, :home_ortg, :float)
    add_column(:games, :pace, :float)
    add_column(:stats, :team_id, :integer)
  end

  def self.down
    remove_column(:games, :away_quarter1)
    remove_column(:games, :away_quarter2)
    remove_column(:games, :away_quarter3)
    remove_column(:games, :away_quarter4)
    remove_column(:games, :home_quarter1)
    remove_column(:games, :home_quarter2)
    remove_column(:games, :home_quarter3)
    remove_column(:games, :home_quarter4)
    remove_column(:games, :away_efg_percent)
    remove_column(:games, :away_tov_percent)
    remove_column(:games, :away_orb_percent)
    remove_column(:games, :away_ft_fga)
    remove_column(:games, :away_ortg)
    remove_column(:games, :home_efg_percent)
    remove_column(:games, :home_tov_percent)
    remove_column(:games, :home_orb_percent)
    remove_column(:games, :home_ft_fga)
    remove_column(:games, :home_ortg)
    remove_column(:games, :pace)
    remove_column(:stats, :team_id)
  end
end