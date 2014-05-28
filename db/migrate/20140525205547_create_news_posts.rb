class CreateNewsPosts < ActiveRecord::Migration
  def change
    create_table :news_posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :tags
      t.integer :creator_id, null: false
      t.integer :for_roles, null: false

      t.timestamps
    end

    add_attachment :news_posts, :icon

    create_table :group_has_news_posts do |t|
      t.integer :group_id, null: false
      t.integer :post_id, null: false
    end

    create_table :news_post_has_docs do |t|
      t.integer :document_id, null: false
      t.integer :post_id, null: false
    end
  end
end
