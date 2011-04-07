class CreateTeamStats < ActiveRecord::Migration
  def self.up
    create_table :team_stats do |t|
      t.integer     :year
      t.integer     :team_id
      t.string      :season_type, :limit=>10
      t.string      :arena
      t.integer     :attendance
      t.string      :conference
      t.string      :division
      t.integer     :wins
      t.integer     :losses
      t.float       :pace
      t.integer     :g
      t.integer     :mp
      t.integer     :fg
      t.integer     :fga
      t.float     :fgpercent
      t.integer     :tfg
      t.integer     :tfga
      t.float     :tfgpercent
      t.integer     :ft
      t.integer     :fta
      t.float     :ftpercent
      t.integer     :orb
      t.integer     :drb
      t.integer     :trb
      t.integer     :ast
      t.integer     :stl
      t.integer     :blk
      t.integer     :tov
      t.integer     :pf
      t.integer     :pts
      t.integer     :o_fg
      t.integer     :o_fga
      t.float     :o_fgpercent
      t.integer     :o_tfg
      t.integer     :o_tfga
      t.float     :o_tfgpercent
      t.integer     :o_ft
      t.integer     :o_fta
      t.float     :o_ftpercent
      t.integer     :o_orb
      t.integer     :o_drb
      t.integer     :o_trb
      t.integer     :o_ast
      t.integer     :o_stl
      t.integer     :o_blk
      t.integer     :o_tov
      t.integer     :o_pf
      t.integer     :o_pts
      t.timestamps
    end
  end

  def self.down
    drop_table :team_stats
  end
end
