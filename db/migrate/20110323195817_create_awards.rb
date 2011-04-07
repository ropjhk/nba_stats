class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.integer     :year  
      t.integer     :mvp
      t.integer     :asg_mvp
      t.integer     :finals_mvp
      t.integer     :dpoy
      t.integer     :coy
      t.integer     :roy
      t.integer     :smoy
      t.integer     :mip
      t.integer     :all_defense_1_pg
      t.integer     :all_defense_1_sg
      t.integer     :all_defense_1_sf
      t.integer     :all_defense_1_pf
      t.integer     :all_defense_1_c
      t.integer     :all_defense_2_pg
      t.integer     :all_defense_2_sg
      t.integer     :all_defense_2_sf
      t.integer     :all_defense_2_pf
      t.integer     :all_defense_2_c
      t.integer     :all_nba_1_pg
      t.integer     :all_nba_1_sg
      t.integer     :all_nba_1_sf
      t.integer     :all_nba_1_pf
      t.integer     :all_nba_1_c
      t.integer     :all_nba_2_pg
      t.integer     :all_nba_2_sg
      t.integer     :all_nba_2_sf
      t.integer     :all_nba_2_pf
      t.integer     :all_nba_2_c
      t.integer     :all_nba_3_pg
      t.integer     :all_nba_3_sg
      t.integer     :all_nba_3_sf
      t.integer     :all_nba_3_pf
      t.integer     :all_nba_3_c
      t.integer     :all_rookie_1_pg
      t.integer     :all_rookie_1_sg
      t.integer     :all_rookie_1_sf
      t.integer     :all_rookie_1_pf
      t.integer     :all_rookie_1_c
      t.integer     :all_rookie_2_pg
      t.integer     :all_rookie_2_sg
      t.integer     :all_rookie_2_sf
      t.integer     :all_rookie_2_pf
      t.integer     :all_rookie_2_c
      t.integer     :west_m_nov
      t.integer     :west_m_dec
      t.integer     :west_m_jan
      t.integer     :west_m_feb
      t.integer     :west_m_mar
      t.integer     :west_m_apr
      t.integer     :east_m_nov
      t.integer     :east_m_dec
      t.integer     :east_m_jan
      t.integer     :east_m_feb
      t.integer     :east_m_mar
      t.integer     :east_m_apr
      t.timestamps
    end
  end

  def self.down
    drop_table :awards
  end
end
