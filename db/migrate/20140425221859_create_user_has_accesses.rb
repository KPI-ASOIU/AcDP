class CreateUserHasAccesses < ActiveRecord::Migration
  def change
    create_table :user_has_accesses do |t|
    	t.integer :user_id, 		null: false
    	t.integer :document_id, null: false
    	t.string  :type, 				null: false, limit: 45
    end
  end
end
