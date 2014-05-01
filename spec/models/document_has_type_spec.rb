require 'spec_helper'

describe DocumentHasType do
  describe 'associations' do
  	it {should belong_to(:document)}
  	it {should belong_to(:document_type)}
  end
end
