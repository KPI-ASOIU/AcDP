class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string  :login,              null: false, default: ""
      t.string  :encrypted_password, null: false, default: ""
      t.integer :role,               null: false, default: 1, limit: 1
      t.string  :full_name
      t.string  :email

      t.timestamps
    end

    add_index :users, :login, unique: true
  end
end
