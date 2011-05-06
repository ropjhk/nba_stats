class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer   :player_id
      t.integer   :season
      t.string    :team_stats_id
      t.string    :season_type, :limit=>10
      t.string    :league,  :limit=>6
      t.integer   :g
      t.integer   :gs
      t.integer   :mp
      t.integer   :fg
      t.integer   :fga
      t.float   :fgpercent
      t.integer   :tfg
      t.integer   :tfga
      t.float   :tfgpercent
      t.integer   :ft
      t.integer   :fta
      t.float   :ftpercent
      t.integer   :orb
      t.integer   :drb
      t.integer   :trb
      t.integer   :ast
      t.integer   :stl
      t.integer   :blk
      t.integer   :tov
      t.integer   :pf
      t.integer   :pts
      t.integer   :salary
      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
