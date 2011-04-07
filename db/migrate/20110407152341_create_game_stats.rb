class CreateGameStats < ActiveRecord::Migration
  def self.up
    create_table :game_stats do |t|
      t.integer   :player_id
      t.integer   :game_id
      t.integer   :team_id
      t.boolean   :starter
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
      t.timestamps
    end
  end

  def self.down
    drop_table :game_stats
  end
end
