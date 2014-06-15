class NewsPost < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :documents

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
  validates_presence_of :for_roles

  scope :with_tag, ->(tag) { where('tags LIKE ?', "%#{tag}%") }
  scope :with_category, ->(category) { where(for_roles: NewsPost.category_to_i(category)) }

  CATEGORIES = %w[global group].concat User::ROLES
  CATEGORIES_STUDENT = %w[global group student]

  def category
    if self.for_roles.nil?
      nil
    else
      CATEGORIES[self.for_roles]
    end
  end

  def self.category_to_i(role)
    CATEGORIES.index(role)
  end

  def category=(role)
    self.for_roles = CATEGORIES.index(role)
  end

  opinio_subjectum
end
