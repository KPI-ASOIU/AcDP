class NewsPost < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_many :group_has_news_posts, foreign_key: :post_id, dependent: :destroy
  has_many :news_post_has_docs, foreign_key: :post_id, dependent: :destroy

  has_attached_file :icon,
                    :styles => { :medium => '128x128#', :large => '256x256#'},
                    :path => ':rails_root/public/system/news_icons/:id/:style/:filename',
                    :url => '/system/news_icons/:id/:style/:filename',
                    :default_url => '/system/news_icons/default/missing.png'
  validates_attachment :icon, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
  validates_attachment_size :icon, :in => 0.megabytes..2.megabytes

  validates_length_of :title, :within => 6..255
  validates_length_of :content, :minimum => 20
  validates_length_of :tags, :maximum => 255

  def custom_save(groups, docs)
    need_save_groups = !(groups.nil? || groups.length < 1)
    need_save_docs = !(docs.nil? || docs.length < 1)

    if !need_save_docs and !need_save_groups
      return self.save
    else
      begin
        transaction do
          self.save!
          if need_save_groups
            groups.each do |group|
              GroupHasNewsPost.new(group_id: group, post_id: self.id).save!
            end
          end
          if need_save_docs
            docs.each do |doc|
              NewsPostHasDoc.new(document_id: doc, post_id: self.id).save!
            end
          end
          return true
        end
      rescue ActiveRecord::StatementInvalid
        #error
      rescue
        return false
      end
    end
  end

  def custom_update(params, groups, docs)
    need_save_groups = !(groups.nil? || groups.length < 1)
    need_save_docs = !(docs.nil? || docs.length < 1)

    begin
      transaction do
        GroupHasNewsPost.destroy_all(post_id: self.id)
        NewsPostHasDoc.destroy_all(post_id: self.id)


      end
    end
  end
end
