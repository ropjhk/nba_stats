class CreateCoaches < ActiveRecord::Migration
  def self.up
    create_table :coaches do |t|
      t.string      :first_name
      t.string      :last_name
      t.string      :pid
      t.date        :birthday
      t.string      :birth_city
      t.string      :high_school
      t.string      :college
      t.integer     :player_id
      t.integer      :nba_career_reg_wins
      t.integer      :nba_career_reg_losses
      t.integer      :nba_career_playoff_wins
      t.integer      :nba_career_playoff_losses
      t.integer      :aba_career_reg_wins
      t.integer      :aba_career_reg_losses
      t.integer      :aba_career_playoff_wins
      t.integer      :aba_career_playoff_losses
      t.timestamps
    end
  end

  def self.down
    drop_table :coaches
  end
end
