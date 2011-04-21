class CreateRefereeStats < ActiveRecord::Migration
  def self.up
    create_table :referee_stats do |t|
      t.integer     :referee_id
      t.string      :season_type
      t.string      :league
      t.integer     :year
      t.string      :officiating_type
      t.integer     :games
      t.float     :home_win_percent
      t.float     :home_pts_diff
      t.float     :tot_ppg
      t.float     :foulspg
      t.float     :away_foul_percent
      t.float     :home_foul_percent
      t.float     :away_techpg
      t.float     :home_techpg
      t.timestamps
    end
  end

  def self.down
    drop_table :referee_stats
  end
end
