class CreateStudentInfos < ActiveRecord::Migration
  def change
    create_table :student_infos do |t|
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
