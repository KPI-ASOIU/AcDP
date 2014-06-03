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

    create_table :groups_news_posts, id: false do |t|
      t.belongs_to :group
      t.belongs_to :news_post
    end

    create_table :documents_news_posts, id: false do |t|
      t.belongs_to :document
      t.belongs_to :news_post
    end
  end
end
