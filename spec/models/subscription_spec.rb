require 'spec_helper'

describe Subscription do
  describe 'associations' do
  	it { should belong_to(:user) }
  	it { should belong_to(:conversation) }
  end
end
