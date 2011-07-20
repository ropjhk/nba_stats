class CreateStandardDeviations < ActiveRecord::Migration
  def self.up
    create_table :standard_deviations do |t|
      t.integer     :year
      t.string      :category
      t.integer     :num_teams
      t.integer     :num_players
      t.float       :height_inches
      t.float       :weight_pounds
      t.float       :birth_year
      t.float       :first_active_year
      t.float       :last_active_year
      t.float       :draft_round
      t.float       :draft_year
      t.float       :g
      t.float       :mp
      t.float     :pts
      t.float     :orb
      t.float     :drb
      t.float     :trb
      t.float     :ast
      t.float     :blk
      t.float     :stl
      t.float     :tov
      t.float     :pf
      t.float     :fg
      t.float     :fga
      t.float     :ft
      t.float     :fta
      t.float     :tfg
      t.float     :tfga
      t.float     :pts48
      t.float     :orb48
      t.float     :drb48
      t.float     :trb48
      t.float     :ast48
      t.float     :blk48
      t.float     :stl48
      t.float     :tov48
      t.float     :pf48
      t.float     :fg48
      t.float     :fga48
      t.float     :ft48
      t.float     :fta48
      t.float     :tfg48
      t.float     :tfga48
      t.float     :salary
      t.float     :per
      t.float     :games_started
      t.float     :ft_percentage
      t.float     :fg_percentage
      t.float     :tfg_percentage
      t.timestamps
    end
  end

  def self.down
    drop_table :standard_deviations
  end
end
