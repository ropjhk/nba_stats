class CreateCoachYears < ActiveRecord::Migration
  def self.up
    create_table :coach_years do |t|
      t.integer     :year
      t.integer     :coach_id
      t.string      :league, :limit=>5
      t.integer     :yr_order
      t.integer     :season_wins
      t.integer     :season_losses
      t.integer     :playoff_wins
      t.integer     :playoff_losses
      t.integer     :team_stats_id
      t.timestamps
    end
  end

  def self.down
    drop_table :coach_years
  end
end
