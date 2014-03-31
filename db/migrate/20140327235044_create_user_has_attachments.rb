class CreateUserHasAttachments < ActiveRecord::Migration
  def change
    create_table :user_has_attachments do |t|
    	t.integer :user_id
    	t.integer :attachment_id
    end
  end
end
