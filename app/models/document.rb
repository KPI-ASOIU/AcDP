require 'elasticsearch/model'

class Document < ActiveRecord::Base
  has_many :user_has_accesses, foreign_key: :document_id, :dependent => :destroy
  has_many :view_accesses, -> { where(access_type: 0) }, class_name: 'UserHasAccess', foreign_key: :document_id
  has_many :edit_accesses, -> { where(access_type: 1) }, class_name: 'UserHasAccess', foreign_key: :document_id
	has_many :users, through: :user_has_accesses, source: :user
	has_many :document_types, through: :document_has_types
	has_many :document_has_types, :dependent => :destroy
	has_many :child_documents, class_name: 'Document', foreign_key: :parent_directory, :dependent => :destroy
  belongs_to :document_folder, class_name: 'Document', foreign_key: :parent_directory
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_one :file_info, class_name: 'FileInfo', foreign_key: 'document_id', :dependent => :destroy

  has_and_belongs_to_many :tasks, join_table: :tasks_documents
  has_and_belongs_to_many :events, join_table: :events_documents
  has_and_belongs_to_many :conversations, join_table: :conversations_documents

  validate :uniqueness_of_titles_per_user, on: :create
  validates :description, length: { maximum: 256 }
  validates :tags, length: { maximum: 256 }

  scope :with_matched_field, ->(value, field) {fields=field.split(" "); where(Document.arel_table[fields[0]].matches('%' + value + '%')) || where(Document.arel_table[fields[1]].matches('%' + value + '%')) }
  scope :match_title, ->(title) { where("title ILIKE ?", "%#{title}%") }
  scope :match_description, ->(desc) { where("description ILIKE ?", "%#{desc}%") }
  scope :match_title_or_nil, ->(title) { where("title ILIKE ? OR title IS NULL", "%#{title}%") }
  scope :match_description_or_nil, ->(desc) { where("description ILIKE ? OR description IS NULL", "%#{desc}%") }

  def uniqueness_of_titles_per_user
    errors.add(:title, 'must be unique') if self.owner.documents.where(title: self.title).exists?
  end

  def save_with_parameter(param)
    begin
      transaction do
          self.save!
          param.document_id = self.id
          param.save!
          return true
      end
    rescue ActiveRecord::StatementInvalid
      #error
    rescue
      return false
    end
  end

  def to_json
    {
      id: id,
      text: title,
      description: description,
      children: doc_type == 0,
      type: doc_type == 0 ? 'folder' : 'file'
   }
  end

  def parent
    Document.find_by(id: self.parent_directory)
  end

  def path_from_root
    path, parent_folder = [self], self
    until (parent_folder = parent_folder.parent).nil? do
      path.insert(0, parent_folder)
    end
    path
  end

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings number_of_shards: 1,
    analysis: {
      filter: {
        partial_match: {
          type: "nGram",
          min_gram: 3,
          max_gram: 20
        }
      },
      analyzer: {
        partial_name: {
          type: "custom",
          tokenizer: "standard",
          filter: [
            "lowercase",
            "partial_match"
          ]
        }
      }
    } do

    mapping _source: { excludes: ['attachment'] } do
      indexes :_all, analyzer: 'partial_name', search_analyzer: 'standard'
      indexes :title, type: 'string'
      indexes :description, type: 'string'
      indexes :attachment, type: 'attachment'
    end
  end

  def attachment
    if self.doc_type == 1
      path_to_attachment = self.file_info.file.path
      Base64.encode64(open(path_to_attachment) { |file| file.read })
    end
  end

  def as_indexed_json(options={})
    self.as_json(methods: [:attachment])
  end
end
