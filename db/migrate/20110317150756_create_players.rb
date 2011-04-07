class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string  :pid
      t.string  :last_name
      t.string  :first_name
      t.string  :position,  :limit=>10
      t.string  :nick_name
      t.integer :height_inches
      t.integer :weight_pounds
      t.date    :birthday
      t.string  :birth_city
      t.string  :birth_state
      t.string  :high_school
      t.string  :college
      t.integer :draft_round
      t.integer :draft_position
      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
