class CreateAveragePlayers < ActiveRecord::Migration
  def self.up
    create_table :average_players do |t|
      t.integer     :year
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
      t.float     :blk
      t.float     :pts
      t.float     :orb
      t.float     :drb
      t.float     :trb
      t.float     :ast
      t.float     :stl
      t.float     :tov
      t.float     :fg
      t.float     :fga
      t.float     :ft
      t.float     :fta
      t.float     :tfg
      t.float     :tfga
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
    drop_table :average_players
  end
end
