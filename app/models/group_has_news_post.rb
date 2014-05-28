class GroupHasNewsPost < ActiveRecord::Base
  belongs_to :group
  belongs_to :news_post

  validates_uniqueness_of :group_id, scope: [:post_id]
end
