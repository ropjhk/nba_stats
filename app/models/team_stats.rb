class TeamStats < ActiveRecord::Base
  belongs_to :team
  
  def self.find_by_team_and_year(pid, year)
    team = Team.find_by_pid(pid)
    puts "pid: |#{pid}|"
    puts "team: #{team.franchise_name}" if !team.nil?
    if !team.nil?
      team_stat = TeamStats.find(:first, :conditions => {:team_id => team.id, :year => year})
    else
      return nil
    end
  end
  
end
