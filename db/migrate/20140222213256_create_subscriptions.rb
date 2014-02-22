class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :conversation_id
      t.integer :unread_messages_count, default: 0

      t.timestamps
    end
  end
end
