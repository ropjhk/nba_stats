class CreateBellCurves < ActiveRecord::Migration
  def self.up
    create_table :bell_curves do |t|
      t.string      :category
      t.float       :range_start
      t.float       :range_end
      t.integer     :count
      t.timestamps
    end
  end

  def self.down
    drop_table :bell_curves
  end
end
