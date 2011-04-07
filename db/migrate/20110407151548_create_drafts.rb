class CreateDrafts < ActiveRecord::Migration
  def self.up
    create_table :drafts do |t|
      t.integer     :year
      t.integer     :draft_round
      t.integer     :selection
      t.integer     :team_id
      t.string      :first_name
      t.string      :last_name
      t.integer     :player_id
      t.string      :draft_from
      t.string      :league, :limit => 5
      t.timestamps
    end
  end

  def self.down
    drop_table :drafts
  end
end
