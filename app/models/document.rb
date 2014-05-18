class Document < ActiveRecord::Base
  has_many :user_has_accesses, foreign_key: :document_id, :dependent => :destroy
  has_many :view_accesses, class_name: 'UserHasAccess', foreign_key: :document_id, conditions: { access_type: 0 }
  has_many :edit_accesses, class_name: 'UserHasAccess', foreign_key: :document_id, conditions: { access_type: 1 }
	has_many :users, through: :user_has_accesses, source: :user
	has_many :document_types, through: :document_has_types
	has_many :document_has_types, :dependent => :destroy
	has_many :child_documents, class_name: 'Document', foreign_key: :parent_directory, :dependent => :destroy
  belongs_to :document_folder, class_name: 'Document', foreign_key: :parent_directory
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_one :file_info, class_name: 'FileInfo', foreign_key: 'document_id', :dependent => :destroy

  validates :description, length: { maximum: 256 }
  validates :tags, length: { maximum: 256 }

  def save_with_file(file)
    begin
      transaction do
          self.save!
          file.document_id = self.id
          file.save!
          return true
      end
    rescue ActiveRecord::StatementInvalid
      #error
    rescue
      return false
    end
  end
end
