class AddAboutMeField < ActiveRecord::Migration
  def change
  	add_column(:users, :about_me, :text, null: false, default: "")
  end
end
