class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.date      :date_played
      t.integer   :home_team_id
      t.integer   :away_team_id
      t.integer   :referee1_id
      t.integer   :referee2_id
      t.integer   :referee3_id
      t.integer   :referee4_id
      t.integer   :attendance
      t.string    :location
      t.string    :game_type
      t.string    :league
      t.float     :minutes_played
      t.integer   :home_fg
      t.integer   :home_fga
      t.float   :home_fgpercent
      t.integer   :home_ft
      t.integer   :home_fta
      t.float   :home_ftpercent
      t.integer   :home_tfg
      t.integer   :home_tfga
      t.float   :home_tfgpercent
      t.integer   :home_orb
      t.integer   :home_drb
      t.integer   :home_trb
      t.integer   :home_ast
      t.integer   :home_stl
      t.integer   :home_blk
      t.integer   :home_tov
      t.integer   :home_pf
      t.integer   :home_tf
      t.integer   :home_pts
      t.integer     :away_fg
      t.integer     :away_fga
      t.float       :away_fgpercent
      t.integer     :away_tfg
      t.integer     :away_tfga
      t.float     :away_tfgpercent
      t.integer     :away_ft
      t.integer     :away_fta
      t.float     :away_ftpercent
      t.integer     :away_orb
      t.integer     :away_drb
      t.integer     :away_trb
      t.integer     :away_ast
      t.integer     :away_stl
      t.integer     :away_blk
      t.integer     :away_tov
      t.integer     :away_pf
      t.integer     :away_pts
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
