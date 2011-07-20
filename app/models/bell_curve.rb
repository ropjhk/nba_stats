class BellCurve < ActiveRecord::Base
  
  def self.add_one(category, range_start, range_end)
    bc = BellCurve.find(:first, :conditions => "category = '#{category}' and (range_start like #{range_start} or range_start = #{range_start})")
    if bc.nil?
      #puts "category = '#{category}' and range_start like #{range_start}"
      bc = BellCurve.new({:category => category, :range_start => range_start, :range_end => range_end, :count => 0})
    end
    bc.count += 1
    bc.save
  end
end
