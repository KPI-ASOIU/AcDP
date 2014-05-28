class NewsPostHasDoc < ActiveRecord::Base
  belongs_to :news_post
  belongs_to :document

  validates_uniqueness_of :document_id, scope: [:news_post_id]
end
