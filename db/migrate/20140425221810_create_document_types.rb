class CreateDocumentTypes < ActiveRecord::Migration
  def change
    create_table :document_types do |t|
    	t.string :title, null: false, limit: 45
    end
  end
end
