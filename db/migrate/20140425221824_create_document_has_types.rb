class CreateDocumentHasTypes < ActiveRecord::Migration
  def change
    create_table :document_has_types do |t|
    	t.integer :document_type_id, null: false
    	t.integer :document_id,			 null: false
    end
  end
end
