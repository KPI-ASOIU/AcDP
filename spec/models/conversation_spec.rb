require 'spec_helper'

describe Conversation do
  describe 'associations' do
  	it { should have_many(:messages).order('created_at DESC') }
  	it { should have_many(:subscriptions) }
  end
end
