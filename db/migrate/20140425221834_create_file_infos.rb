class CreateFileInfos < ActiveRecord::Migration
  def change
    create_table :file_infos do |t|
    	t.integer :document_id, null: false
    	t.string  :path, 				null: false
    	t.integer :size, 				null: false
    	t.string  :extension, 							limit: 10
    end
  end
end
