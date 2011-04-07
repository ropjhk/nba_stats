class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string      :pid, :limit => 5
      t.string      :city
      t.string      :state
      t.string      :franchise_name
      t.string      :league, :limit => 5
      t.string      :short_name
      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
