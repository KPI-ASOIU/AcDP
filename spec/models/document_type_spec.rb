require 'spec_helper'

describe DocumentType do
  describe 'associations' do
  	it {should have_many(:documents).through(:document_has_types)}
  	it {should have_many(:document_has_types)}
  end
end
