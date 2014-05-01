class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
    	t.integer   :parent_directory
    	t.integer   :type,         null: false
    	t.integer   :owner_id,     null: false
    	t.datetime  :date_created, null: false
    	t.datetime  :date_updated, null: false
    	t.boolean   :public,       null: false
    	t.string    :title,                    limit: 50
    	t.string    :description
    	t.string    :tags
    end
  end
end
