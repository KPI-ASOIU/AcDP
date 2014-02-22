require 'spec_helper'

describe Message do
  describe 'validations' do
  	it { should validate_presence_of(:conversation_id) }
  	it { should validate_presence_of(:author_id) }
  	it { should validate_presence_of(:body) }
  end

  describe 'associations' do
  	it { should belong_to(:author).class_name('User') }
  	it { should belong_to(:conversation) }
  end
end
