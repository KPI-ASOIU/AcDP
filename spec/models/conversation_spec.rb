require 'spec_helper'

describe Conversation do
  describe 'associations' do
  	it { should have_many(:messages).order('created_at DESC') }
  	it { should have_many(:subscriptions) }
  	it { should have_many(:participants).class_name("User") }
  	it { should have_many(:participants).through(:subscriptions) }
  end
end
