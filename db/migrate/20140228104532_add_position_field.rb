class AddPositionField < ActiveRecord::Migration
  def change
  	add_column(:users, :position, :string, null: false, default: "")
  end
end
