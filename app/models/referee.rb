class Referee < ActiveRecord::Base
  
  def self.find_full_name(full_name)
    full_names = full_name.split(" ")
    if full_names.length > 2
      return_id = -1
    else
      matches = Referee.find(:all, :conditions => {:first_name => full_names[0], :last_name=>full_names[1]})
      if matches.length == 1
        return_id = matches[0].id
      elsif matches.length == 0
        ref = Referee.new
        ref.set_name(full_name)
        return_id = ref.id
      elsif matches.length > 1
        return_id = -2
      end
    end
    return return_id
  end
  
  def set_name(full_name)
    full_names = full_name.split(" ")
    self.first_name = full_names[0]
    self.last_name = full_names[1]
    self.save
  end
  
end
