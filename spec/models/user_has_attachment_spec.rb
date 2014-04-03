require 'spec_helper'

describe UserHasAttachment do
  describe 'associations' do
  	it { should belong_to(:user) }
  	it { should belong_to(:attachment) }
  end
end