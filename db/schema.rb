# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110505140226) do

  create_table "awards", :force => true do |t|
    t.integer  "year"
    t.integer  "mvp"
    t.integer  "asg_mvp"
    t.integer  "finals_mvp"
    t.integer  "dpoy"
    t.integer  "coy"
    t.integer  "roy"
    t.integer  "smoy"
    t.integer  "mip"
    t.integer  "all_defense_1_pg"
    t.integer  "all_defense_1_sg"
    t.integer  "all_defense_1_sf"
    t.integer  "all_defense_1_pf"
    t.integer  "all_defense_1_c"
    t.integer  "all_defense_2_pg"
    t.integer  "all_defense_2_sg"
    t.integer  "all_defense_2_sf"
    t.integer  "all_defense_2_pf"
    t.integer  "all_defense_2_c"
    t.integer  "all_nba_1_pg"
    t.integer  "all_nba_1_sg"
    t.integer  "all_nba_1_sf"
    t.integer  "all_nba_1_pf"
    t.integer  "all_nba_1_c"
    t.integer  "all_nba_2_pg"
    t.integer  "all_nba_2_sg"
    t.integer  "all_nba_2_sf"
    t.integer  "all_nba_2_pf"
    t.integer  "all_nba_2_c"
    t.integer  "all_nba_3_pg"
    t.integer  "all_nba_3_sg"
    t.integer  "all_nba_3_sf"
    t.integer  "all_nba_3_pf"
    t.integer  "all_nba_3_c"
    t.integer  "all_rookie_1_pg"
    t.integer  "all_rookie_1_sg"
    t.integer  "all_rookie_1_sf"
    t.integer  "all_rookie_1_pf"
    t.integer  "all_rookie_1_c"
    t.integer  "all_rookie_2_pg"
    t.integer  "all_rookie_2_sg"
    t.integer  "all_rookie_2_sf"
    t.integer  "all_rookie_2_pf"
    t.integer  "all_rookie_2_c"
    t.integer  "west_m_nov"
    t.integer  "west_m_dec"
    t.integer  "west_m_jan"
    t.integer  "west_m_feb"
    t.integer  "west_m_mar"
    t.integer  "west_m_apr"
    t.integer  "east_m_nov"
    t.integer  "east_m_dec"
    t.integer  "east_m_jan"
    t.integer  "east_m_feb"
    t.integer  "east_m_mar"
    t.integer  "east_m_apr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coach_years", :force => true do |t|
    t.integer  "year"
    t.integer  "coach_id"
    t.string   "league",         :limit => 5
    t.integer  "yr_order"
    t.integer  "season_wins"
    t.integer  "season_losses"
    t.integer  "playoff_wins"
    t.integer  "playoff_losses"
    t.integer  "team_stats_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coaches", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "pid"
    t.date     "birthday"
    t.string   "birth_city"
    t.string   "high_school"
    t.string   "college"
    t.integer  "player_id"
    t.integer  "nba_career_reg_wins"
    t.integer  "nba_career_reg_losses"
    t.integer  "nba_career_playoff_wins"
    t.integer  "nba_career_playoff_losses"
    t.integer  "aba_career_reg_wins"
    t.integer  "aba_career_reg_losses"
    t.integer  "aba_career_playoff_wins"
    t.integer  "aba_career_playoff_losses"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drafts", :force => true do |t|
    t.integer  "year"
    t.integer  "draft_round"
    t.integer  "selection"
    t.integer  "team_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "player_id"
    t.string   "draft_from"
    t.string   "league",      :limit => 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "team_id"
    t.boolean  "starter"
    t.integer  "mp"
    t.integer  "fg"
    t.integer  "fga"
    t.float    "fgpercent"
    t.integer  "tfg"
    t.integer  "tfga"
    t.float    "tfgpercent"
    t.integer  "ft"
    t.integer  "fta"
    t.float    "ftpercent"
    t.integer  "orb"
    t.integer  "drb"
    t.integer  "trb"
    t.integer  "ast"
    t.integer  "stl"
    t.integer  "blk"
    t.integer  "tov"
    t.integer  "pf"
    t.integer  "pts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.date     "date_played"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "referee1_id"
    t.integer  "referee2_id"
    t.integer  "referee3_id"
    t.integer  "referee4_id"
    t.integer  "attendance"
    t.string   "location"
    t.string   "game_type"
    t.string   "league"
    t.integer  "minutes_played"
    t.integer  "home_fg"
    t.integer  "home_fga"
    t.float    "home_fgpercent"
    t.integer  "home_ft"
    t.integer  "home_fta"
    t.float    "home_ftpercent"
    t.integer  "home_tfg"
    t.integer  "home_tfga"
    t.float    "home_tfgpercent"
    t.integer  "home_orb"
    t.integer  "home_drb"
    t.integer  "home_trb"
    t.integer  "home_ast"
    t.integer  "home_stl"
    t.integer  "home_blk"
    t.integer  "home_tov"
    t.integer  "home_pf"
    t.integer  "home_tf"
    t.integer  "home_pts"
    t.integer  "away_fg"
    t.integer  "away_fga"
    t.float    "away_fgpercent"
    t.integer  "away_tfg"
    t.integer  "away_tfga"
    t.float    "away_tfgpercent"
    t.integer  "away_ft"
    t.integer  "away_fta"
    t.float    "away_ftpercent"
    t.integer  "away_orb"
    t.integer  "away_drb"
    t.integer  "away_trb"
    t.integer  "away_ast"
    t.integer  "away_stl"
    t.integer  "away_blk"
    t.integer  "away_tov"
    t.integer  "away_pf"
    t.integer  "away_pts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ot"
    t.string   "notes"
    t.boolean  "neutral"
    t.integer  "season"
    t.integer  "away_quarter1"
    t.integer  "away_quarter2"
    t.integer  "away_quarter3"
    t.integer  "away_quarter4"
    t.integer  "home_quarter1"
    t.integer  "home_quarter2"
    t.integer  "home_quarter3"
    t.integer  "home_quarter4"
    t.float    "away_efg_percent"
    t.float    "away_tov_percent"
    t.float    "away_orb_percent"
    t.float    "away_ft_fga"
    t.float    "away_ortg"
    t.float    "home_efg_percent"
    t.float    "home_tov_percent"
    t.float    "home_orb_percent"
    t.float    "home_ft_fga"
    t.float    "home_ortg"
    t.float    "pace"
  end

  create_table "players", :force => true do |t|
    t.string   "pid"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "position",       :limit => 10
    t.string   "nick_name"
    t.integer  "height_inches"
    t.integer  "weight_pounds"
    t.date     "birthday"
    t.string   "birth_city"
    t.string   "birth_state"
    t.string   "high_school"
    t.string   "college"
    t.integer  "draft_round"
    t.integer  "draft_position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playoff_series", :force => true do |t|
    t.integer  "year"
    t.integer  "round_from_finals"
    t.integer  "favoured_team_id"
    t.integer  "underdog_team_id"
    t.integer  "game_1_id"
    t.integer  "game_2_id"
    t.integer  "game_3_id"
    t.integer  "game_4_id"
    t.integer  "game_5_id"
    t.integer  "game_6_id"
    t.integer  "game_7_id"
    t.integer  "game_1_home_team_id"
    t.integer  "game_2_home_team_id"
    t.integer  "game_3_home_team_id"
    t.integer  "game_4_home_team_id"
    t.integer  "game_5_home_team_id"
    t.integer  "game_6_home_team_id"
    t.integer  "game_7_home_team_id"
    t.integer  "games_played"
    t.integer  "best_of"
    t.integer  "series_winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referee_stats", :force => true do |t|
    t.integer  "referee_id"
    t.string   "season_type"
    t.string   "league"
    t.integer  "year"
    t.string   "officiating_type"
    t.integer  "games"
    t.float    "home_win_percent"
    t.float    "home_pts_diff"
    t.float    "tot_ppg"
    t.float    "foulspg"
    t.float    "away_foul_percent"
    t.float    "home_foul_percent"
    t.float    "away_techpg"
    t.float    "home_techpg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "season"
    t.string   "team_stat_id"
    t.string   "season_type",  :limit => 10
    t.string   "league",       :limit => 6
    t.integer  "g"
    t.integer  "gs"
    t.integer  "mp"
    t.integer  "fg"
    t.integer  "fga"
    t.float    "fgpercent"
    t.integer  "tfg"
    t.integer  "tfga"
    t.float    "tfgpercent"
    t.integer  "ft"
    t.integer  "fta"
    t.float    "ftpercent"
    t.integer  "orb"
    t.integer  "drb"
    t.integer  "trb"
    t.integer  "ast"
    t.integer  "stl"
    t.integer  "blk"
    t.integer  "tov"
    t.integer  "pf"
    t.integer  "pts"
    t.integer  "salary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  create_table "team_stats", :force => true do |t|
    t.integer  "year"
    t.integer  "team_id"
    t.string   "season_type",  :limit => 10
    t.string   "arena"
    t.integer  "attendance"
    t.string   "conference"
    t.string   "division"
    t.integer  "wins"
    t.integer  "losses"
    t.float    "pace"
    t.integer  "g"
    t.integer  "mp"
    t.integer  "fg"
    t.integer  "fga"
    t.float    "fgpercent"
    t.integer  "tfg"
    t.integer  "tfga"
    t.float    "tfgpercent"
    t.integer  "ft"
    t.integer  "fta"
    t.float    "ftpercent"
    t.integer  "orb"
    t.integer  "drb"
    t.integer  "trb"
    t.integer  "ast"
    t.integer  "stl"
    t.integer  "blk"
    t.integer  "tov"
    t.integer  "pf"
    t.integer  "pts"
    t.integer  "o_fg"
    t.integer  "o_fga"
    t.float    "o_fgpercent"
    t.integer  "o_tfg"
    t.integer  "o_tfga"
    t.float    "o_tfgpercent"
    t.integer  "o_ft"
    t.integer  "o_fta"
    t.float    "o_ftpercent"
    t.integer  "o_orb"
    t.integer  "o_drb"
    t.integer  "o_trb"
    t.integer  "o_ast"
    t.integer  "o_stl"
    t.integer  "o_blk"
    t.integer  "o_tov"
    t.integer  "o_pf"
    t.integer  "o_pts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "validated"
  end

  create_table "teams", :force => true do |t|
    t.string   "pid",            :limit => 5
    t.string   "city"
    t.string   "state"
    t.string   "franchise_name"
    t.string   "league"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_year"
    t.integer  "last_year"
    t.integer  "prev_team_id"
    t.integer  "next_team_id"
    t.string   "brid",           :limit => 5
  end

end
