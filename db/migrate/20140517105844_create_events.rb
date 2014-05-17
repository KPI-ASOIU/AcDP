class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :date
      t.string :place
      t.text :plan

      t.timestamps
    end
  end
end
