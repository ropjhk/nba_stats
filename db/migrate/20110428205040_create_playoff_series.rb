class CreatePlayoffSeries < ActiveRecord::Migration
  def self.up
    create_table :playoff_series do |t|
      t.integer   :year
      t.integer   :round_from_finals
      t.integer   :favoured_team_id
      t.integer   :underdog_team_id
      t.integer   :game_1_id
      t.integer   :game_2_id
      t.integer   :game_3_id
      t.integer   :game_4_id
      t.integer   :game_5_id
      t.integer   :game_6_id
      t.integer   :game_7_id
      t.integer   :game_1_home_team_id
      t.integer   :game_2_home_team_id
      t.integer   :game_3_home_team_id
      t.integer   :game_4_home_team_id
      t.integer   :game_5_home_team_id
      t.integer   :game_6_home_team_id
      t.integer   :game_7_home_team_id
      t.integer   :games_played
      t.integer   :best_of
      t.integer   :series_winner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :playoff_series
  end
end
