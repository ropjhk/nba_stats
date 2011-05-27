class Team < ActiveRecord::Base
  has_many :team_stats
  
  def self.find_by_full_name(name, year)
    if year == 1970 && name == "Washington Capitols"
      name = "Washington Caps"
    end
    city, franchise = Team.split_name(name)
    return_team = Team.find(:first, :conditions => "city = '#{city}' and franchise_name = '#{franchise}' and start_year <= #{year} and last_year >= #{year}")
    if return_team.nil?
      puts "Cannot find #{name}"
    end
    return return_team
  end
  
  def self.find_by_pid_year(pid,year)
    teams = Team.find(:all, :conditions => "pid='#{pid}' and start_year <= #{year} and last_year >= #{year}" )
    if teams.length==1
      return teams[0]
    else
      teams = Team.find(:all, :conditions => "pid_aka='#{pid}' and start_year <= #{year} and last_year >= #{year}" )
      if teams.length==1
        return teams[0]
      end
    end
  end
  
  def self.split_name(name)
    if name == "Spirits of St. Louis"
      name = "St. Louis Spirits"
    elsif name == "Floridians"
      name = "The Floridians"
    end
    na = name.split(" ")
    
    flag=0
    if (na[0] == "New" && na[1] == "Orleans-Oklahoma" && na[2] == "City")||
          (na[0] == "New" && na[1] == "Orleans/Oklahoma" && na[2] == "City")
      city = na[0] + " " + na[1] + " " + na[2]
      franchise = na[3]
      
      if !na[4].nil?
        franchise += " " + na[4]
      end
    elsif (na[0] == "Golden" && na[1] == "State")|| 
       (na[0] == "Fort" && na[1] == "Wayne")||
       (na[0] == "Kansas" && na[1] == "City")||
       (na[0] == "Kansas" && na[1] == "City-Omaha")||
       (na[0] == "Los")||
       (na[0] == "New")||
       (na[0] == "San")||
       (na[0] == "St.")||
       (na[0] == "Las")||
       (na[0] == "Oklahoma" && na[1] == "City")
      city = na[0] + " " + na[1]
      franchise = na[2]
      
      if !na[3].nil?
        franchise += " " + na[3]
      end
    else
      city = na[0]
      franchise = na[1]
      
      if !na[2].nil?
        franchise += " " + na[2]
      end
    end
    
    if franchise == "Knickerbockers"
      franchise = "Knicks"
    elsif franchise == "Packers" && city == "Anderson"
      franchise = "Duffey Packers"
    elsif franchise == "Steam Rollers"
      franchise = "Steamrollers"
    end
    
    if city == "New Orleans/Oklahoma City"
      city = "New Orleans-Oklahoma City"
    elsif city == "The" && franchise == "Floridians"
      city = ""
      franchise = "The Floridians"
    end
    
    return city, franchise
  end
  
  def get_team_stat(year, season_type)
    team_stat = TeamStats.find(:first, :conditions => {:year => year, :team_id => self.id, :season_type => season_type})
  end
end
