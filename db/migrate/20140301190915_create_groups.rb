class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :start_year
      t.integer :graduation_year
      t.boolean :full_time, default: true
      t.integer :degree, default: 1
      t.string :speciality
      t.string :speciality_code

      t.timestamps
    end
  end
end
