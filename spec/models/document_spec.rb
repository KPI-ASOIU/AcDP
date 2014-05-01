require 'spec_helper'

describe Document do
  describe 'associations' do
  	it {should have_many(:users).through(:user_has_accesses)}
  	it {should have_many(:user_has_accesses)}
  	it {should have_many(:document_types).through(:document_has_types)}
  	it {should have_many(:document_has_types)}
  	it {should have_many(:child_documents).class_name('Document')}
  	it {should belong_to(:document_folder).class_name('Document')}
  end
end
