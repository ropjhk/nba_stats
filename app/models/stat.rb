class Stat < ActiveRecord::Base
  belongs_to :team_stats
  belongs_to :player
end
