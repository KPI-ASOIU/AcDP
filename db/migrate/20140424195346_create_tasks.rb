class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.datetime :end_date
      t.string :status
      t.text :check_list
      t.integer :user_id

      t.timestamps
    end
  end
end
