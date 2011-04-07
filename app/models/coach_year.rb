class CoachYear < ActiveRecord::Base
  belongs_to :coach
  
  def self.find_by_coach_and_year(pid, year)
    coach = Coach.find_by_pid(pid)
    if !coach.nil?
      coach_year = CoachYear.find(:first, :conditions => {:coach_id => coach.id, :year => year})
    else
      return nil
    end
  end
  
end
