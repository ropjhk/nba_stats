class CreatePlayerGraphs < ActiveRecord::Migration
  def self.up
    create_table :player_graphs do |t|
      t.string    :category
      t.integer   :num_players_analyzed
      t.float     :minutes_played
      t.float     :blk_per_min
      t.float     :points_per_min
      t.float     :orb_per_min
      t.float     :drb_per_min
      t.float     :rebounds_per_min
      t.float     :ast_per_min
      t.float     :stl_per_min
      t.float     :tov_per_min
      t.float     :fg_per_min
      t.float     :fga_per_min
      t.float     :ft_per_min
      t.float     :fta_per_min
      t.float     :tfg_per_min
      t.float     :tfga_per_min
      t.float     :blk_per_game
      t.float     :points_per_game
      t.float     :orb_per_game
      t.float     :drb_per_game
      t.float     :rebounds_per_game
      t.float     :ast_per_game
      t.float     :stl_per_game
      t.float     :tov_per_game
      t.float     :fg_per_game
      t.float     :fga_per_game
      t.float     :ft_per_game
      t.float     :fta_per_game
      t.float     :tfg_per_game
      t.float     :tfga_per_game
      t.float     :salary
      t.float     :min_per_game
      t.float     :per
      t.float     :games
      t.float     :games_started
      t.float     :ft_percentage
      t.float     :fg_percentage
      t.float     :tfg_percentage
      t.timestamps
    end
    add_column(:players, :draft_year, :integer)
  end

  def self.down
    drop_table :player_graphs
  end
end
