class FixDocuments < ActiveRecord::Migration
    def self.up
      change_table :documents do |t|
        t.rename  :type,  :doc_type
        t.change  :title, :string, null: false,  limit: 80
        t.remove  :public
        t.integer :for_roles, null: false,  default: 0
        t.integer :original_doc_id
      end

      change_table :user_has_accesses do |t|
        t.rename  :type,  :access_type
        t.datetime  :date_created, null: false
      end

      change_table :file_infos do |t|
        t.remove :path, :size, :extension
        t.attachment :file
      end
    end

    def self.down
      change_table :documents do |t|
        t.rename  :doc_type,  :type
        t.change  :title, :string, null: false,  limit: 50
        t.boolean :public, null: false,  default: false
        t.remove :for_roles, :original_doc_id
      end

      change_table :user_has_accesses do |t|
        t.rename  :access_type,  :type
        t.remove  :date_created
      end

      change_table :file_infos do |t|
        t.string  :path, 				null: false
        t.integer :size, 				null: false
        t.string  :extension,   limit: 10
      end

      remove_attachment :file_infos, :file
    end
end
